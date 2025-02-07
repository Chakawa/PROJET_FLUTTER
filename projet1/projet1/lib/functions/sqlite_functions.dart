import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/event_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'reminders.db');
    //await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE Reminders ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title TEXT DEFAULT "Untitled Reminder", '
              'description TEXT DEFAULT "No Description", '
              'date DATETIME DEFAULT CURRENT_TIMESTAMP, '
              'location TEXT DEFAULT "Unknown Location", '
              'isCompleted BOOLEAN DEFAULT 0'
              ')',
        );
      },
    );
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert('Reminders', reminder.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Reminders');

    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await database;
    return await db.update(
      'Reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(
      'Reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
