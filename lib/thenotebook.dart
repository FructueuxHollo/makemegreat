import 'package:flutter/material.dart';

class NoteBook extends StatefulWidget {
  const NoteBook({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _NoteBookState createState() => _NoteBookState();
}

class _NoteBookState extends State<NoteBook> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('NoteBook'),
      ),
    );
  }
}
