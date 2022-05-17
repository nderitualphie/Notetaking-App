import 'package:app1/constants/routes.dart';
import 'package:app1/services/auth/auth_service.dart';
import 'package:app1/services/auth/bloc/auth_bloc.dart';
import 'package:app1/services/auth/bloc/auth_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('verify email')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  "we have already sent you an email verification. kindly open to verify account"),
              const Text(
                  'if you have not received an email yet.please click below to verify email adress'),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                },
                child: const Text('send email verification'),
              ),
              TextButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: const Text('Back to login'))
            ],
          ),
        ),
      ),
    );
  }
}
