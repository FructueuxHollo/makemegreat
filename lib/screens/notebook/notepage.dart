import 'package:flutter/material.dart';
import 'package:make_me_great/const.dart';
import 'package:make_me_great/editpage.dart';

class PageNote extends StatefulWidget {
  const PageNote({Key? key, required this.note}) : super(key: key);
  final Notes note;

  @override
  _PageNoteState createState() => _PageNoteState();
}

class _PageNoteState extends State<PageNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title ?? 'Sans titre'),
        actions: [
          widget.note.isfavorite
              ? icone(Colors.white)
              : icone(Colors.transparent),
          const SizedBox(width: 20)
        ],
      ),
      body: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return EditPage(
            note: Notes(
                content: widget.note.content,
                title: widget.note.title,
                isfavorite: widget.note.isfavorite),
          );
        })),
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              widget.note.content,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 1,
                wordSpacing: 1,
              ),
            )),
      ),
    );
  }
}

Icon icone(Color color) {
  return Icon(Icons.star, color: color);
}
