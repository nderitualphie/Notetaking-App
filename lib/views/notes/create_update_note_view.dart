import 'package:app1/services/auth/auth_service.dart';
import 'package:app1/services/cloud/cloud_note.dart';
import 'package:app1/services/cloud/cloud_storage_exceptions.dart';
import 'package:app1/services/cloud/firebase_cloud_storage.dart';
import 'package:app1/utilities/dialogs/cannot_share_empty_notesdialogs.dart';
import 'package:app1/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _notes;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _notes;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesService.updateNote(text: text, documentid: note.documentid);
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _notes = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _notes;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _notes = newNote;
    return newNote;
  }

  void _deleteNoteIfNoteIsEmpty() {
    final note = _notes;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentid: note.documentid);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _notes;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(documentid: note.documentid, text: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfNoteIsEmpty();
    _saveNoteIfNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NewNote'),
          actions: [
            IconButton(
              onPressed: () async {
                final text = _textEditingController.text;
                if (_notes == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share),
            )
          ],
        ),
        body: FutureBuilder(
            future: createOrGetExistingNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'start typing your note'),
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
