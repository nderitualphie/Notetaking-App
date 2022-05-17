import 'package:app1/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentid;
  final String ownerUserId;
  final String text;

  const CloudNote(
      {required this.documentid,
      required this.ownerUserId,
      required this.text});
  CloudNote.fromsnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentid = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
