import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Conversation {
  final int? id;
  final String title;
  final DateTime createdAt;

  Conversation({
    this.id,
    required this.title,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class AssistantMessage {
  final int? id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final int conversationId;

  AssistantMessage({
    this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.conversationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'conversationId': conversationId,
    };
  }

  factory AssistantMessage.fromMap(Map<String, dynamic> map) {
    return AssistantMessage(
      id: map['id'],
      message: map['message'],
      isUser: map['isUser'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
      conversationId: map['conversationId'],
    );
  }
}

class Assistant extends StatefulWidget {
  const Assistant({super.key});

  @override
  State<Assistant> createState() => _AssistantState();
}

class _AssistantState extends State<Assistant> {
  final TextEditingController _messageController = TextEditingController();
  final List<AssistantMessage> _messages = [];
  final List<Conversation> _conversations = [];
  late Database _database;
  final ScrollController _scrollController = ScrollController();
  int? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
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
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'conversations',
      orderBy: 'createdAt DESC',
    );
    setState(() {
      _conversations.clear();
      _conversations.addAll(maps.map((map) => Conversation.fromMap(map)));
    });
  }

  Future<void> _createNewConversation() async {
    final newConversation = Conversation(
      title: 'Nouvelle conversation',
      createdAt: DateTime.now(),
    );

    final id = await _database.insert(
      'conversations',
      newConversation.toMap(),
    );

    setState(() {
      _currentConversationId = id;
      _messages.clear();
      _conversations.insert(0, Conversation(
        id: id,
        title: newConversation.title,
        createdAt: newConversation.createdAt,
      ));
    });
  }

  Future<void> _loadMessages(int conversationId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );
    setState(() {
      _messages.clear();
      _messages.addAll(maps.map((map) => AssistantMessage.fromMap(map)));
      _currentConversationId = conversationId;
    });
    _scrollToBottom();
  }

  Future<void> _addMessage(String message, bool isUser) async {
    if (_currentConversationId == null) {
      await _createNewConversation();
    }

    final newMessage = AssistantMessage(
      message: message,
      isUser: isUser,
      timestamp: DateTime.now(),
      conversationId: _currentConversationId!,
    );

    await _database.insert(
      'messages',
      newMessage.toMap(),
    );

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    _addMessage(text, true);

    Future.delayed(const Duration(seconds: 1), () {
      _addMessage("Je suis votre assistant virtuel. Comment puis-je vous aider ?", false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.shade900,
            Colors.purple.shade800,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Assistant Virtuel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.shade900,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Historique des conversations',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _conversations.length,
                            itemBuilder: (context, index) {
                              final conversation = _conversations[index];
                              return ListTile(
                                title: Text(
                                  conversation.title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${conversation.createdAt.day}/${conversation.createdAt.month}/${conversation.createdAt.year}',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                ),
                                onTap: () {
                                  _loadMessages(conversation.id!);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Row(
          children: [
            // Sidebar
            Container(
              width: 250,
              decoration: BoxDecoration(
                color: Colors.purple.shade900.withOpacity(0.5),
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _createNewConversation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple.shade900,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Nouvelle conversation'),
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = _conversations[index];
                        return ListTile(
                          title: Text(
                            conversation.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${conversation.createdAt.day}/${conversation.createdAt.month}/${conversation.createdAt.year}',
                            style: TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          selected: conversation.id == _currentConversationId,
                          selectedColor: Colors.white,
                          onTap: () => _loadMessages(conversation.id!),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Chat area
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: message.isUser
                                    ? Colors.white
                                    : Colors.purple.shade200,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: Radius.circular(message.isUser ? 20 : 5),
                                  bottomRight: Radius.circular(message.isUser ? 5 : 20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                message.message,
                                style: TextStyle(
                                  color: message.isUser
                                      ? Colors.purple.shade900
                                      : Colors.white,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 60),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextField(
                              controller: _messageController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Écrivez votre message...',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              onSubmitted: _handleSubmitted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.purple,
                            ),
                            onPressed: () => _handleSubmitted(_messageController.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 