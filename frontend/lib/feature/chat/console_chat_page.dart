import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/database/local_db.dart';
import 'package:frontend/feature/chat/bloc/chat_bloc.dart';
import 'package:frontend/repository/chat_repository.dart';
import 'package:intl/intl.dart';

class ConsoleChatPage extends StatelessWidget {
  final String chatId;
  const ConsoleChatPage({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) =>
            ChatBloc(context.read<ChatRepository>(), chatId)
              ..add(LoadChatEvent()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TerminalHeader(chatId: chatId),
            Expanded(child: _TerminalBody(chatId)),
            _TerminalInput(),
          ],
        ),
      ),
    );
  }
}

class _TerminalBody extends StatelessWidget {
  final String _chatId;
  const _TerminalBody(this._chatId);
  @override
  Widget build(BuildContext context) {
    final repo = context.read<ChatRepository>();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            // Слушаем изменения в таблице Chats (для галочек)
            return StreamBuilder<Chat>(
              stream: repo.watchChat(_chatId),
              builder: (context, snapshot) {
                final chat = snapshot.data;
                if (chat == null) return SizedBox.shrink();
                final messages = state.messages;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return InkWell(
                      onTap: () => _showContextMenu(context, msg),
                      child: _ConsoleRow(
                        msg: msg,
                        chat: chat, // Вот он наш чат из базы
                        myId: repo.currentUserId, // Берем из репо
                        myRole: repo.role, // Берем из репо
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _showContextMenu(BuildContext context, Message msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.greenAccent)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.greenAccent),
              title: const Text(
                "EDIT_RECORD",
                style: TextStyle(color: Colors.white, fontFamily: 'monospace'),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showEditDialog(context, msg);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text(
                "PURGE_DATA",
                style: TextStyle(color: Colors.white, fontFamily: 'monospace'),
              ),
              onTap: () {
                context.read<ChatBloc>().add(DeleteMessageEvent(msg.id));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Message msg) {
    final controller = TextEditingController(text: msg.textContent);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "REWRITE_ENTRY",
          style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ABORT"),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatBloc>().add(
                UpdateMessageEvent(msg.id, controller.text),
              );
              Navigator.pop(ctx);
            },
            child: const Text("EXECUTE"),
          ),
        ],
      ),
    );
  }
}

class _TerminalInput extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          const Text(
            "CMD>",
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "type_message...",
              ),
              onSubmitted: (val) => _send(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.greenAccent, size: 20),
            onPressed: () => _send(context),
          ),
        ],
      ),
    );
  }

  void _send(BuildContext context) {
    if (_controller.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(_controller.text));
      _controller.clear();
    }
  }
}

class _TerminalHeader extends StatelessWidget {
  final String chatId;
  const _TerminalHeader({required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SRC: $chatId",
            style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "[ DISCONNECT / EXIT ]",
              style: TextStyle(color: Colors.redAccent, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsoleRow extends StatelessWidget {
  final Message msg;
  final Chat? chat;
  final String myId;
  final String myRole;

  const _ConsoleRow({
    required this.msg,
    this.chat,
    required this.myId,
    required this.myRole,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(msg.createdAt);
    final isMine = msg.senderId == myId;

    // Безопасно вычисляем статус прочтения
    bool isRead = false;
    if (chat != null) {
      // Сравниваем BigInt (pts сообщения) с BigInt (pts прочтения из таблицы чата)
      final companionReadPts = (myRole == "admin")
          ? chat!.userReadPts
          : chat!.adminReadPts;
      isRead = msg.pts <= companionReadPts;
    }

    final String status = isRead ? "vv" : "v ";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          children: [
            // Метка времени
            TextSpan(
              text: "[$time] ",
              style: const TextStyle(color: Colors.grey),
            ),

            // Статус прочтения (только для моих сообщений)
            if (isMine)
              TextSpan(
                text: "[$status] ",
                style: TextStyle(
                  color: isRead ? Colors.blueAccent : Colors.grey,
                ),
              ),

            // Никнейм/ID отправителя
            TextSpan(
              text:
                  "${msg.senderId.length > 4 ? msg.senderId.substring(0, 4) : msg.senderId}> ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: msg.senderId == "admin"
                    ? Colors.blueAccent
                    : Colors.greenAccent,
              ),
            ),

            // Текст сообщения
            TextSpan(
              text: msg.textContent,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
