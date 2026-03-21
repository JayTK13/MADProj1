import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('focus_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        taskType TEXT NOT NULL,
        duration INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertSession(Map<String, dynamic> session) async {
    final db = await instance.database;
    return await db.insert('sessions', session);
  }

  // READ
  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await instance.database;
    return await db.query('sessions', orderBy: 'createdAt DESC');
  }

  // DELETE
  Future<int> deleteSession(int id) async {
    final db = await instance.database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }
}
