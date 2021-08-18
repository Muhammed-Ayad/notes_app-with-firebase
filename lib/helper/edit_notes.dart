import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/show_loading.dart';

class EditNotes extends StatefulWidget {
  final docsid;
  final list;
  EditNotes({required this.docsid, required this.list});

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  CollectionReference noresref = FirebaseFirestore.instance.collection('notes');
  var _title, _note;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  editNotes(BuildContext context) async {
    var formdata = _formKey.currentState;

    if (formdata!.validate()) {
      showLoading(context);
      formdata.save();

      await noresref
          .doc(widget.docsid)
          .update({
            'title': _title,
            'note': _note,
          })
          .then((value) => {
                Navigator.of(context).pushNamed('home'),
              })
          .catchError((onError) {
            print(onError);
          });
    } else {
      if (formdata.validate()) {
        showLoading(context);
        formdata.save();

        await noresref
            .doc(widget.docsid)
            .update({
              'title': _title,
              'note': _note,
            })
            .then((value) => {
                  Navigator.of(context).pushNamed('home'),
                })
            .catchError((onError) {
              print(onError);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit '),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.list['title'],
                    onSaved: (value) {
                      _title = value;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please Enter Title';
                      }
                      if (val.length > 100) {
                        return "Should be at least 100 charcters long";
                      }
                      if (val.length < 3) {
                        return "Should be at least 3 charcters long";
                      }
                      return null;
                    },
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText: 'Title Note',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: widget.list['note'],
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please Enter Note';
                      }
                      if (val.length > 250) {
                        return "Note can't to be larger than 250 letter";
                      }
                      if (val.length < 5) {
                        return "Note can't to be less than 5 letter";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _note = value;
                    },
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: ' Note',
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        primary: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () async {
                      await editNotes(context);
                    },
                    label: Text(
                      'Edit Note',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
