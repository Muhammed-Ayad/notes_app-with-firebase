import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../widgets/list_note.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference _noteColl = FirebaseFirestore.instance.collection('notes');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('login');
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _noteColl
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (direction) async {
                        await _noteColl
                            .doc(snapshot.data.docs[index].id)
                            .delete();
                        await FirebaseStorage.instance
                            .refFromURL(snapshot.data.docs[index]['imageUrl'])
                            .delete();
                      },
                      key: UniqueKey(),
                      child: ListNote(
                        docsid: snapshot.data.docs[index].id,
                        notes: snapshot.data.docs[index].data(),
                      ),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, 'AddNotes');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
