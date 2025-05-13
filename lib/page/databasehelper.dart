import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }
  
  static Future<int> deletePdf(int id) async {
  final db = await  database;
  return await db.delete(
    'pdfs',
    where: 'id = ?',
    whereArgs: [id],
  );
}

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pdfs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pdfs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            path TEXT
          )
        ''');
      },
    );
  }

    static initDbConersation() async {
    
  await openDatabase(
      join(await getDatabasesPath(), 'assistant_messages.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE conversations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            createdAt TEXT
          )
        ''').then((_) {
          return db.execute('''
            CREATE TABLE messages(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              message TEXT,
              isUser INTEGER,
              timestamp TEXT,
              conversationId INTEGER,
              FOREIGN KEY (conversationId) REFERENCES conversations (id)
            )
          ''');
        });
      },
      version: 1,
    );
  }


  static Future<void> insertPdf(String name, String path) async {
    final db = await database;
    await db.insert('pdfs', {'name': name, 'path': path});
  }

  static Future<List<Map<String, dynamic>>> getAllPdfs() async {
    final db = await database;
    return await db.query('pdfs', orderBy: 'id DESC');
  }
}
