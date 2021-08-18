import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../widgets/show_loading.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class AddNotes extends StatefulWidget {
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  CollectionReference _noteColl =
      FirebaseFirestore.instance.collection('notes');
  var _title, _note, _file, _imageUrl, _ref;

  var _image = ImagePicker();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  addNotes(BuildContext context) async {
    if (_file == null) {
      return AwesomeDialog(
          context: context,
          title: "Error",
          body: Text("please choose Image"),
          dialogType: DialogType.ERROR)
        ..show();
    }
    var formdata = _formKey.currentState;
    if (formdata!.validate()) {
      showLoading(context);
      formdata.save();
      await _ref.putFile(_file);
      _imageUrl = await _ref.getDownloadURL();
      await _noteColl
          .add({
            'title': _title,
            'note': _note,
            'imageUrl': _imageUrl,
            'userId': FirebaseAuth.instance.currentUser!.uid,
          })
          .then((value) => {
                Navigator.of(context).pushNamed('home'),
              })
          .catchError((onError) {
            print(onError);
          });
    }
  }

  uploadImage(ImageSource imageSource, BuildContext context) async {
    var imagePicker = await _image.getImage(source: imageSource);
    if (imagePicker != null) {
      _file = File(imagePicker.path);
      var rand = Random().nextInt(10000000);
      var nameImage = "$rand" + basename(imagePicker.path);
      _ref = FirebaseStorage.instance.ref('images').child(nameImage);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notes'),
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
                  ElevatedButton(
                    onPressed: () {
                      showBottonSheet(context);
                    },
                    child: Text('Add Image'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          primary: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      onPressed: () async {
                        await addNotes(context);
                      },
                      label: Text(
                        'Add Note',
                        style: Theme.of(context).textTheme.headline3,
                      ),
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

  showBottonSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Please choose Image',
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.camera),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            primary: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        onPressed: () async {
                          await uploadImage(ImageSource.camera, context);
                        },
                        label: Text(
                          'camera',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.art_track_rounded),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            primary: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        onPressed: () async {
                          await uploadImage(ImageSource.gallery, context);
                        },
                        label: Text(
                          'gallery',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
