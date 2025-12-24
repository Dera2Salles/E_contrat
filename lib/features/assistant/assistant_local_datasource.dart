import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../../core/config/app_config.dart';
import 'conversation_model.dart';
import 'assistant_message_model.dart';

abstract class AssistantLocalDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<int> createConversation(ConversationModel conversation);
  Future<void> deleteConversation(int id);
  Future<List<AssistantMessageModel>> getMessages(int conversationId);
  Future<int> saveMessage(AssistantMessageModel message);
  Future<void> updateConversationTitle(int id, String title);
}

@LazySingleton(as: AssistantLocalDataSource)
class AssistantLocalDataSourceImpl implements AssistantLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      path.join(await getDatabasesPath(), AppConfig.databaseName),
      version: AppConfig.databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE conversations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            createdAt TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            message TEXT,
            isUser INTEGER,
            timestamp TEXT,
            conversationId INTEGER,
            FOREIGN KEY (conversationId) REFERENCES conversations (id)
          )
        ''');
      },
    );
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => ConversationModel.fromMap(map)).toList();
  }

  @override
  Future<int> createConversation(ConversationModel conversation) async {
    final db = await database;
    return await db.insert('conversations', conversation.toMap());
  }

  @override
  Future<void> deleteConversation(int id) async {
    final db = await database;
    await db.delete(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [id],
    );
    await db.delete(
      'conversations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<AssistantMessageModel>> getMessages(int conversationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((map) => AssistantMessageModel.fromMap(map)).toList();
  }

  @override
  Future<int> saveMessage(AssistantMessageModel message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  @override
  Future<void> updateConversationTitle(int id, String title) async {
    final db = await database;
    await db.update(
      'conversations',
      {'title': title},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
