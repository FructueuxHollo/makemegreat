import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  int? id;
  final String description;
  bool completed;
  final int weight;
  Task({
    this.id,
    required this.completed,
    required this.description,
    required this.weight,
  });

  bool operator >(Task b) {
    if (weight > b.weight) {
      return true;
    } else {
      return false;
    }
  }

  Task copy({String? description, int? id, int? weight, bool? completed}) =>
      Task(
          completed: completed ?? this.completed,
          description: description ?? this.description,
          weight: weight ?? this.weight,
          id: id ?? this.id);

//  tomap convert Task to Json format

  Map<String, dynamic> tomap() {
    return {
      "description": description,
      "weight": weight,
      "completed": completed ? 1 : 0
    };
  }

// fromMap convert Json to Task

  factory Task.fromMap(Map<String, dynamic> fMap) {
    return Task(
        id: fMap['id'],
        completed: fMap['completed'] == 1 ? true : false,
        description: fMap['description'],
        weight: fMap['weight']);
  }
}

//  this class is use to implement the persistence of Task in a local database
class Sqflitehelper {
  Database? db;
  String tableName = 'Tasktable';
  Future<void> open() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'makemegreat.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableName(
        id integer primary key autoincrement,
        description text not null,
        weight integer not null,
        completed integer not null
      )
      ''');
    });
  }

  Future<Task> insert(Task task) async {
    await open();
    task.id = await db!.insert(tableName, task.tomap());
    await close();
    return task;
  }

  Future<List<Task>> getalltask() async {
    await open();
    List<Map<String, dynamic>> maps = await db!.query(tableName);
    await close();
    return maps.map((e) => Task.fromMap(e)).toList();
  }

  Future<int?> delete(int? id) async {
    await open();
    int? a = await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
    await close();
    return a;
  }

  Future close() async {
    await db!.close();
  }
}
