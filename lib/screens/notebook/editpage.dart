import 'package:flutter/material.dart';
import 'package:make_me_great/const.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, this.note}) : super(key: key);

  final Notes? note;
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late String _content;
  String? _title;
  bool shouldivalidate = false;
  late bool _isfavorite;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  NoteSaver saver = NoteSaver();

  @override
  void initState() {
    super.initState();
    if (widget.note == null) {
      _isfavorite = false;
    } else {
      _isfavorite = widget.note!.isfavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.note?.title ?? 'nouvelle note'),
          actions: [
            IconButton(
                onPressed: () {
                  _isfavorite = !_isfavorite;
                  setState(() {});
                },
                icon: _isfavorite
                    ? const Icon(Icons.star)
                    : const Icon(Icons.star_border)),
            IconButton(
                onPressed: () {
                  bool b = _formKey.currentState?.validate() ?? false;
                  setState(() {
                    shouldivalidate = true;
                  });
                  if (b) {
                    _formKey.currentState?.save();
                    Notes note = Notes(
                        content: _content,
                        title: _title!.trim().isEmpty ? 'sans titre' : _title,
                        isfavorite: _isfavorite);
                    () async {
                      if (note != null) {
                        await saver.insert(note);
                      }
                      Navigator.pop(context, note);
                    };
                  }
                },
                icon: const Icon(Icons.save)),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        initialValue: widget.note?.title,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: InputBorder.none, labelText: 'Title'),
                        onSaved: (titleinfield) {
                          _title = titleinfield;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autovalidateMode: shouldivalidate
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        initialValue: widget.note?.content,
                        minLines: 5,
                        maxLines: null,
                        style: const TextStyle(
                            fontSize: 18, letterSpacing: 1, wordSpacing: 1),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Content',
                        ),
                        validator: (value) {
                          if ((value == null) || (value.trim().isEmpty)) {
                            return 'ajouter d\'abord du contenue';
                          }
                          return null;
                        },
                        onSaved: (contentinfield) {
                          _content = contentinfield ?? '';
                        },
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
