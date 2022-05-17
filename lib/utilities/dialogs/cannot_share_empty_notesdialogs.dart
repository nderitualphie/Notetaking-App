import 'package:flutter/material.dart';

import 'package:app1/utilities/dialogs/generic_dialog.dart';
Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'sharing',
    content: 'you cannot share an empty note',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
