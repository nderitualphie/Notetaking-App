import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUser({required this.email, required this.isEmailVerified, required this.id});
  factory AuthUser.fromFirebase(user) =>
      AuthUser(email: user.email!, isEmailVerified: user.emailVerified,id: user.uid);
}
