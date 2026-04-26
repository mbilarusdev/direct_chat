import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/data_source/local/token_storage.dart';
import 'package:frontend/data_source/remote/web_socket.dart';
import 'package:frontend/database/local_db.dart';
import 'package:frontend/feature/admin_list/admin_list_page.dart';
import 'package:frontend/feature/chat/console_chat_page.dart';
import 'package:frontend/feature/login/login_page.dart';
import 'package:frontend/repository/auth_repository.dart';
import 'package:frontend/repository/chat_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage(prefs);

  final db = LocalDatabase(connectWeb().executor);

  final dio = createDio(tokenStorage);
  final wsDataSource = WebSocketDataSource();

  final uri = Uri.base;
  final String? tokenFromUrl = uri.queryParameters['token'];
  final String? chatIdFromUrl = uri.pathSegments.isNotEmpty
      ? uri.pathSegments.last
      : null;

  String? activeToken = tokenFromUrl ?? tokenStorage.getToken();
  String? currentUserId;
  String role = "user";

  if (activeToken != null) {
    if (!JwtDecoder.isExpired(activeToken)) {
      final payload = JwtDecoder.decode(activeToken);
      currentUserId = payload['sub'];
      role = payload['role'] ?? "user";

      wsDataSource.connect("ws://localhost:8080/ws", activeToken);
    } else {
      await tokenStorage.clear();
      activeToken = null;
    }
  }

  final authRepo = AuthRepository(dio);
  final chatRepo = ChatRepository(
    wsDataSource,
    db.messagesDao,
    db.chatsDao,
    currentUserId ?? "",
    role,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: chatRepo),
        RepositoryProvider.value(value: tokenStorage),
        RepositoryProvider.value(value: wsDataSource),
      ],
      child: MyApp(
        isAuthorized: activeToken != null,
        initialChatId: chatIdFromUrl,
        role: role,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthorized;
  final String? initialChatId;
  final String role;

  const MyApp({
    super.key,
    required this.isAuthorized,
    this.initialChatId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VaultDesk Terminal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'monospace', color: Colors.white),
        ),
      ),
      // Простая логика навигации
      home: _getHome(),
    );
  }

  Widget _getHome() {
    if (!isAuthorized) return const LoginPage();

    if (role == 'user') {
      return initialChatId != null
          ? ConsoleChatPage(chatId: initialChatId!)
          : const Scaffold(body: Center(child: Text(">> ERROR: NO_CHAT_ID")));
    }

    return const AdminListPage();
  }
}
