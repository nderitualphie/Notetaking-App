// ignore_for_file: avoid_print

import 'package:app1/constants/routes.dart';
import 'package:app1/services/auth/auth_exceptions.dart';
import 'package:app1/services/auth/bloc/auth_bloc.dart';
import 'package:app1/services/auth/bloc/auth_event.dart';
import 'package:app1/services/auth/bloc/auth_state.dart';
import 'package:app1/utilities/dialogs/loading_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'Could not find a user with the entered credentials');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            
            child: Column(children: [
              const Text('please login in order to access your notes'),
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'enter your email here'),
              ),
              TextField(
                  controller: _password,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration:
                      const InputDecoration(hintText: 'enter your password here')),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(AuthEventLogin(email, password));
                },
                child: const Text('login'),
              ),
             
              TextButton(
                onPressed: ()  {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());
                },
                child: const Text('forgot your password| reset here'),
              ),
               TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text('not registered yet? register here'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
