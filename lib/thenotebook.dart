import 'package:flutter/material.dart';
import 'package:make_me_great/const.dart';
import 'package:make_me_great/editpage.dart';
import 'package:make_me_great/notepage.dart';

class NoteBook extends StatefulWidget {
  const NoteBook({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _NoteBookState createState() => _NoteBookState();
}

class _NoteBookState extends State<NoteBook> {
  List notes = <Notes>[];
  NoteSaver saver = NoteSaver();
  void refreshNotes() async {
    List<Notes?> notelist = await saver.getallnotes();
    setState(() {
      notes = notelist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NoteBook'),
        ),
        body: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(05),
                child: GestureDetector(
                  onTap: null,
                  // () async {
                  //   notes[index] = await Navigator.push(context,
                  //       MaterialPageRoute<Notes>(
                  //           builder: (BuildContext context) {
                  //     return PageNote(
                  //       note: notes[index],
                  //     );
                  //   }));
                  //   setState(() {});
                  // },
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              notes[index].title ?? 'sans titre',
                              style: TextStyle(
                                  color: notes[index].title == null ||
                                          notes[index].title == 'sans titre'
                                      ? Colors.grey
                                      : Colors.blueAccent,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: notes[index].title == null ||
                                          notes[index].title == 'sans titre'
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                            )
                          ],
                        ),
                        Container(
                          width: 150,
                          height: 100,
                          child: Text(
                            notes[index].content,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.star,
                              color: notes[index].isfavorite
                                  ? Colors.blueAccent
                                  : Colors.transparent,
                              size: 25,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const EditPage();
            }));
            refreshNotes();
          },
          child: const Icon(Icons.note_add_rounded),
        ));
  }
}
