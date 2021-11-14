import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_me_great/theToDoList.dart';
import 'package:make_me_great/thenotebook.dart';
import 'package:make_me_great/thevisiontable.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MMG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageList = <Widget>[
    const NoteBook(
      title: 'NoteBook',
    ),
    const ToDo(title: 'To-Do'),
    const VisionTable(title: 'DreamSpace')
  ];
  int selectedindex = 1;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pageList.elementAt(selectedindex)),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        items: const [
          Icon(Icons.book_rounded),
          Icon(Icons.check_box_outlined),
          Icon(Icons.trending_up)
        ],
        onTap: (index) {
          setState(() {
            selectedindex = index;
          });
        },
      ),
    );
  }
}
