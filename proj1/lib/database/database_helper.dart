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

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
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
    final db = await database;
    return await db.insert('sessions', session);
  }

  // READ
  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await database;
    return await db.query('sessions', orderBy: 'createdAt DESC');
  }

  // DELETE
  Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // AI Intergration
  Future<Map<String, dynamic>?> getRecommendation() async {
    final db = await database;

    final sessions = await db.query(
      'sessions',
      orderBy: 'createdAt DESC',
      limit: 3,
    );

    if (sessions.isEmpty) return null;

    Map<String, int> moodCount = {};
    Map<String, int> taskCount = {};

    for (var session in sessions) {
      String mood = session['mood'] as String;
      String task = session['taskType'] as String;

      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
      taskCount[task] = (taskCount[task] ?? 0) + 1;
    }

    String bestMood =
        moodCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    String bestTask =
        taskCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return {
      'mood': bestMood,
      'taskType': bestTask,
      'reason': 'Based on your last ${sessions.length} sessions',
    };
  }
}