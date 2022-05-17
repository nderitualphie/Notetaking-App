
import 'package:app1/services/cloud/cloud_note.dart';
import 'package:app1/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> note;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const NotesListView({
    Key? key,
    required this.note,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: note.length,
        itemBuilder: (context, index) {
          final notes = note.elementAt(index);
          return ListTile(
            onTap:() {
              onTap(notes);
            },
            title: Text(notes.text,
                maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(notes);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
