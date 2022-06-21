

import 'package:app1/constants/routes.dart';
import 'package:app1/helpers/loading/loading_screen.dart';
import 'package:app1/services/auth/bloc/auth_bloc.dart';
import 'package:app1/services/auth/bloc/auth_event.dart';
import 'package:app1/services/auth/bloc/auth_state.dart';
import 'package:app1/services/auth/firebase_Auth_Provider.dart';
import 'package:app1/views/forgot_password_view.dart';
import 'package:app1/views/login_view.dart';
import 'package:app1/views/notes/create_update_note_view.dart';
import 'package:app1/views/notes/notes_view.dart';
import 'package:app1/views/verifyemailview.dart';
import 'package:app1/views/registerview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const Homepage(),
      ),
      routes: {
        "/createOrUpdateNoteRoute/": (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) async{
      if (state.isLoading) {
        LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'please wait a moment');
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
