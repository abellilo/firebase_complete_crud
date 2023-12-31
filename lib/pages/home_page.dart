import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/services/firestore_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //initialize firestore
  final firestoreService = FireStoreService();

  //text controller
  final textController = TextEditingController();

  //open a dialogue box to add new note
  void openNoteBox({String? docId}) async {
    await showDialog(
        context: context,
        builder: (cxt) {
          return AlertDialog(
            title: Text("Add New Note"),
            content: TextField(
              controller: textController,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (docId == null) {
                      firestoreService.addNotes(textController.text);
                    } else {
                      firestoreService.updateNote(docId, textController.text);
                    }

                    textController.clear();
                  },
                  child: Text("Add note"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: StreamBuilder(
        stream: firestoreService.getNoteStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteListIds = snapshot.data!.docs;
            return ListView.builder(
                itemCount: noteListIds.length,
                itemBuilder: (context, index) {
                  //get each individual doc id
                  DocumentSnapshot document = noteListIds[index];
                  String docId = document.id;

                  //get note from each of the id
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  //display as a list tile
                  return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () => openNoteBox(docId: docId),
                        ),

                        //delete button
                        IconButton(onPressed: ()=> firestoreService.deleteNote(
                            docId), icon: Icon(Icons.delete)),
                      ],
                    ),
                  );
                });
          }
          //if there is no data return nothing
          else {
            return const Text("No notes...");
          }
        },
      ),
    );
  }
}
