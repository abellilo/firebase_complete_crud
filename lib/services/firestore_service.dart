import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  //get collections of notes
  final notes = FirebaseFirestore.instance.collection("notes");

  //CREATE: add new notes

  Future<void> addNotes(String note) async {
    await notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //READ: get notes from database
  Stream<QuerySnapshot> getNoteStream() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();

    return noteStream;

  }
  //UPDATE: updates notes given a doc id
  Future<void> updateNote(String docId, String newNote) async{
    await notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now()
    });
  }

  //DELETE: delete notes given a doc id
  Future<void> deleteNote(String docId)async{
      await notes.doc(docId).delete();
  }
}
