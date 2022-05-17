import 'package:app1/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'An error ocurred',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
