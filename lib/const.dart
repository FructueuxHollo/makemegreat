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

class Notes {
  int? id;
  String content;
  String? title;
  bool isfavorite;
  Notes({this.title, required this.content, this.isfavorite = false, this.id});
  Map<String, dynamic> tomap() {
    return {
      "title": title,
      "content": content,
      "isfavorite": isfavorite ? 1 : 0
    };
  }

  factory Notes.fromMap(Map<String, dynamic> fmap) {
    return Notes(
        content: fmap['content'],
        title: fmap['title'],
        isfavorite: fmap['isfavorite'] == 1 ? true : false,
        id: fmap['id']);
  }
}

class NoteSaver {
  Database? db;
  String tableName = 'Notetable';
  Future<void> open() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'makemegreatnote.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableName(
        id integer primary key autoincrement,
        content text not null,
        title text,
        isfavorite integer
      )
      ''');
    });
    print('open');
  }

  Future close() async {
    await db!.close();
  }

  Future<Notes> insert(Notes note) async {
    await open();
    note.id = await db!.insert(tableName, note.tomap());
    await close();
    print('insert');
    return note;
  }

  Future<List<Notes>> getallnotes() async {
    await open();
    List<Map<String, dynamic>> maps = await db!.query(tableName);
    await close();
    return maps.map((e) => Notes.fromMap(e)).toList();
  }

  Future<int?> delete(int? id) async {
    await open();
    int? a = await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
    await close();
    return a;
  }

  Future<Notes?>? getnotes(int id) async {
    await open();
    List<Map<String, dynamic>> maps =
        await db!.query(tableName, where: 'id = ?', whereArgs: [id]);
    await close();
    int l = maps.length;
    if (l > 0) {
      return Notes.fromMap(maps.first);
    }
    return null;
  }

  Future<int?> update(Notes note) async {
    await open();
    int? a = await db!
        .update(tableName, note.tomap(), where: 'id = ?', whereArgs: [note.id]);
    await close();
    return a;
  }
}
