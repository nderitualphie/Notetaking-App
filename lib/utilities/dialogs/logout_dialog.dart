import 'package:app1/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'log out',
    content: 'Are you sure you want to logout',
    optionsBuilder: () => {'cancel': false, 'log out': true},
  ).then((value) => value ?? false);
}
