import 'package:flutter/material.dart';

class VisionTable extends StatefulWidget {
  const VisionTable({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _VisionTableState createState() => _VisionTableState();
}

class _VisionTableState extends State<VisionTable> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('VisionTable'),
      ),
    );
  }
}
