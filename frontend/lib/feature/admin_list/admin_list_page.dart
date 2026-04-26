import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data_source/local/token_storage.dart';
import 'package:frontend/feature/admin_list/bloc/admin_bloc.dart';
import 'package:frontend/feature/chat/console_chat_page.dart';
import 'package:frontend/repository/auth_repository.dart';
import 'package:frontend/repository/chat_repository.dart';

class AdminListPage extends StatelessWidget {
  const AdminListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) => AdminBloc(
          context.read<AuthRepository>(),
          context.read<ChatRepository>(),
          context.read<TokenStorage>(),
        )..add(LoadAdminData()),
        child: Column(
          children: [
            const _Header(text: "ACTIVE CHANNELS"),
            Expanded(child: _ChatListView()),
            const _AdminActions(),
          ],
        ),
      ),
    );
  }
}

class _ChatListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state.chats.isEmpty) {
          return const Center(
            child: Text(
              ">> NO_RECORDS_FOUND",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: state.chats.length,
          itemBuilder: (context, index) {
            final chat = state.chats[index];
            return ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConsoleChatPage(chatId: chat.id),
                ),
              ),
              title: Text(
                "CHANNEL: ${chat.title} [PTS: ${chat.lastPts}]",
                style: const TextStyle(color: Colors.greenAccent),
              ),
              subtitle: Text(
                "ID: ${chat.id}",
                style: const TextStyle(color: Colors.white24, fontSize: 10),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.greenAccent,
              ),
            );
          },
        );
      },
    );
  }
}

class _AdminActions extends StatelessWidget {
  const _AdminActions();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white10,
      child: Row(
        children: [
          const Text("COMMAND> ", style: TextStyle(color: Colors.amber)),
          TextButton(
            onPressed: () => _showAddClientDialog(context),
            child: const Text(
              "[ CREATE_NEW_CLIENT + ]",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddClientDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.black,
        // Рамка в стиле терминала
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.greenAccent, width: 1),
          borderRadius: BorderRadius.circular(0),
        ),
        title: const Text(
          "REGISTER_NEW_COMPANY",
          style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
          autofocus: true,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
            hintText: "ENTER_NAME...",
            hintStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "ABORT",
              style: TextStyle(color: Colors.grey, fontFamily: 'monospace'),
            ),
          ),
          // Слушаем изменения в контроллере в реальном времени
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final bool isEnabled = value.text.trim().isNotEmpty;
              return TextButton(
                onPressed: isEnabled
                    ? () {
                        context.read<AdminBloc>().add(
                          CreateClientEvent(controller.text.trim()),
                        );
                        Navigator.pop(ctx);
                      }
                    : null, // Кнопка становится disabled
                child: Text(
                  "EXECUTE",
                  style: TextStyle(
                    color: isEnabled ? Colors.greenAccent : Colors.white10,
                    fontFamily: 'monospace',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white12, // Слегка выделяем фон заголовка
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
