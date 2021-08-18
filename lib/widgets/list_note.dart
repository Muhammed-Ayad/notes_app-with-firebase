import 'package:flutter/material.dart';
import '../helper/edit_notes.dart';
import '../helper/view_note.dart';

class ListNote extends StatelessWidget {
  final docsid;
  final notes;
  ListNote({required this.notes, required this.docsid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNote(
                  notes: notes,
                )));
      },
      child: Card(
          elevation: 0.8,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  '${notes['imageUrl']}',
                ),
              ),
              Expanded(
                flex: 3,
                child: ListTile(
                  title: Text(
                    '${notes['title']}',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${notes['note']}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditNotes(
                                docsid: docsid,
                                list: notes,
                              )));
                    },
                    icon: Icon(Icons.edit,color: Colors.blue[600],),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
