import 'package:app1/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Password Reset',
      content:
          'We have sent you a password reset link to your email, kindly check for further information',
      optionsBuilder: (() => {
        'OK':null,
      }));
}
