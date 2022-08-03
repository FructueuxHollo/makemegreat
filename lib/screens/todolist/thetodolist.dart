// ignore_for_file: file_names
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:make_me_great/const.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  // declaration of some variables
  final Sqflitehelper helper = Sqflitehelper();
  var _todo = <Task>[];
  bool isLoading = true;
  // the ordonneur function is use to make important Task first in the Task's array _todo
  void ordonneur() {
    Task temp;
    for (int i = 0; i < _todo.length; i++) {
      for (int j = i + 1; j < _todo.length; j++) {
        if (_todo[j] > _todo[i]) {
          temp = _todo[i];
          _todo[i] = _todo[j];
          _todo[j] = temp;
        }
      }
    }
  }

  Future<void> refreshTask() async {
    isLoading = true;
    List<Task>? _todolist = await helper.getalltask();
    setState(() {
      _todo = _todolist;
    });
    ordonneur();
    isLoading = false;
  }

//  refreshTask is used in initstate to load Task from the local database
  @override
  void initState() {
    super.initState();
    refreshTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(53, 170, 242, 100),
        title: Text(widget.title),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _todo.isNotEmpty
              ? ListView.builder(
                  itemCount: _todo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      value: _todo[index].completed,
                      onChanged: (val) {
                        setState(() {
                          _todo[index].completed = !_todo[index].completed;
                        });
                      },
                      tileColor: _todo[index].completed
                          ? Colors.blue.shade100
                          : Colors.white,
                      secondary: _todo[index].completed
                          ? IconButton(
                              onPressed: () async {
                                await helper.delete(_todo[index].id);
                                await refreshTask();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ))
                          : null,
                      controlAffinity: ListTileControlAffinity.leading,
                      subtitle: Text(_todo[index].weight.toString()),
                      title: Text(
                        _todo[index].description,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  },
                )
              : Center(
                  child: Image.asset('assets/images/emptytask.png'),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<Task>(
              context: context,
              builder: (context) {
                final _textController = TextEditingController();
                final _anotherTextController = TextEditingController();
                return AlertDialog(
                  title: const Text('Ajouter une nouvelle tâche'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                            labelText: "libellée de la tâche"),
                      ),
                      TextField(
                        controller: _anotherTextController,
                        decoration: const InputDecoration(labelText: "Poids "),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                Task(
                                    completed: false,
                                    description: _textController.text,
                                    weight: int.parse(
                                        _anotherTextController.text)));
                          },
                          child: const Text('Ajouter')),
                    ],
                  ),
                  scrollable: true,
                );
              }).then((value) async {
            if (value != null) {
              await helper.insert(value);
              await refreshTask();
            }
          });
        },
        backgroundColor: const Color.fromRGBO(27, 98, 191, 100),
        tooltip: 'Ajouter une tâche',
        child: const Icon(Icons.add),
      ),
    );
  }
}
