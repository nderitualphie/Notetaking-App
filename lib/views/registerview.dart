// ignore_for_file: avoid_print
import 'package:app1/services/auth/auth_exceptions.dart';
import 'package:app1/services/auth/bloc/auth_bloc.dart';
import 'package:app1/services/auth/bloc/auth_event.dart';
import 'package:app1/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          if (state is AuthStateRegistering) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context, 'Weak Password');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(context, 'Email Already In Use');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Failed to register');
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid Email');
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('register here'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Enter email and password to register'),
                    TextField(
                      controller: _email,
                      autocorrect: false,
                      autofocus: true,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'enter your email here'),
                    ),
                    TextField(
                        controller: _password,
                        obscureText: true,
                        autocorrect: false,
                        autofocus: true,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                            hintText: 'enter your password here')),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: () async {
                                final email = _email.text;
                                final password = _password.text;
                                context
                                    .read<AuthBloc>()
                                    .add(AuthEventRegister(email, password));
                              },
                              child: const Text('register')),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthEventLogout());
                            },
                            child: const Text(
                                "already have an account| login here"),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
