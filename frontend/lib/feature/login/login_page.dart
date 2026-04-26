import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data_source/local/token_storage.dart';
import 'package:frontend/data_source/remote/web_socket.dart';
import 'package:frontend/feature/admin_list/admin_list_page.dart';
import 'package:frontend/feature/login/bloc/login_bloc.dart';
import 'package:frontend/repository/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) => AuthBloc(
          context.read<AuthRepository>(),
          context.read<TokenStorage>(),
          context.read<WebSocketDataSource>(),
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AdminListPage()),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      ">> DIRECT CHAT",
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                    const Text(
                      ">> RESTRICTED_AREA: AUTHORIZATION_REQUIRED",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    _buildInput("USER_ID:", _userController, false),
                    _buildInput("PASS_KEY:", _passController, true),
                    const SizedBox(height: 20),
                    if (state.isLoading)
                      const Text(
                        ">> CHECKING_CREDENTIALS...",
                        style: TextStyle(color: Colors.amber),
                      ),
                    if (state.error != null)
                      Text(
                        ">> ERROR: ${state.error}",
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    if (!state.isLoading)
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginSubmitted(
                              _userController.text,
                              _passController.text,
                            ),
                          );
                        },
                        child: const Text(
                          "[ ATTEMPT_LOGIN ]",
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    bool obscure,
  ) {
    return Row(
      children: [
        Text("$label ", style: const TextStyle(color: Colors.greenAccent)),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
            ),
            decoration: const InputDecoration(border: InputBorder.none),
            cursorColor: Colors.greenAccent,
          ),
        ),
      ],
    );
  }
}
