import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

@injectable
class PdfLocalDataSource {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'pdfs.db');

    return openDatabase(
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

  Future<List<Map<String, dynamic>>> getAllPdfs() async {
    final db = await database;
    return db.query('pdfs', orderBy: 'id DESC');
  }

  Future<int> deletePdf(int id) async {
    final db = await database;
    return db.delete('pdfs', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertPdf(String name, String path) async {
    final db = await database;
    await db.insert('pdfs', {'name': name, 'path': path});
  }
}
