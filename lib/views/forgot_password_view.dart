import 'package:app1/services/auth/bloc/auth_bloc.dart';
import 'package:app1/services/auth/bloc/auth_event.dart';
import 'package:app1/services/auth/bloc/auth_state.dart';
import 'package:app1/services/cloud/cloud_storage_constants.dart';
import 'package:app1/utilities/dialogs/error_dialog.dart';
import 'package:app1/utilities/dialogs/password_reset_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
                context, 'your request could not be processed');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('forgot password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
          child: Column(children: [
            const Text(
                'We have sent you a password reset link to your email, kindly check for further information'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _controller,
              autocorrect: false,
              autofocus: true,
              decoration: const InputDecoration(
                  hintText: 'enter your email adress here'),
            ),
            TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add( AuthEventForgotPassword(email: email));
                },
                child: const Text('send me a password reset link')),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text('back to login page'))
          ]),
        ),
      ),
    ));
  }
}
