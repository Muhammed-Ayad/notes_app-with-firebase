import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final notes;
  ViewNote({required this.notes});

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Note'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Image.network(
                widget.notes['imageUrl'],
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.notes['title'],
                style: Theme.of(context).textTheme.headline5
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: Text(
                widget.notes['note'],
                style: TextStyle(fontSize: 20),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
