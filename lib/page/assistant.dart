import 'package:e_contrat/page/linear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:e_contrat/page/confirm.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:retry/retry.dart';
import '../config/app_config.dart';
import '../utils/error_handler.dart';

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
  late GenerativeModel _model;
  bool _isLoading = false;
  final _internetConnection = InternetConnection();
  StreamSubscription? _connectivitySubscription;
  bool _isConnected = true;

  // Add prompt definition
  static const String _promptDef = '''
Tu es un expert plus de 20 ans en Contrat de toute sorte. Réponds uniquement aux prompts liés aux Contrat de manière précise,concise et ordonnee, n'utilise pas de ** dans test reponse.
Si le prompt ne concerne pas le Contrat, corrige l'utilisateur et ne donne pas la reponse
''';

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _initGemini();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _internetConnection.onStatusChange.listen((InternetStatus status) {
      if (mounted) {
        setState(() {
          _isConnected = status == InternetStatus.connected;
        });
      }
      if (status == InternetStatus.disconnected) {
        ErrorHandler.handleError(NetworkError(AppConfig.networkError));
      }
    });
  }

  Future<void> _initGemini() async {
    try {
    
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null) {
        throw Exception('GEMINI_API_KEY not found in .env file');
      }
      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey,
      );
    } catch (e) {
      ErrorHandler.handleError(e);
      // Re-throw to prevent the app from continuing with an uninitialized model
      rethrow;
    }
  }

  Future<void> _initDatabase() async {
    try {
      _database = await openDatabase(
        path.join(await getDatabasesPath(), AppConfig.databaseName),
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
        version: AppConfig.databaseVersion,
      );
      await _loadConversations();
    } catch (e) {
      ErrorHandler.handleError(DatabaseError(AppConfig.databaseError));
    }
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

  Future<void> _deleteConversation(int conversationId) async {
    if (!mounted) return;
    
    await ConfirmationDialog.show(
      context,
      title: 'Supprimer la conversation',
      message: 'Êtes-vous sûr de vouloir supprimer cette conversation ?',
      onConfirm: () async {
        try {
          // Delete messages first
          await _database.delete(
            'messages',
            where: 'conversationId = ?',
            whereArgs: [conversationId],
          );
          
          // Then delete the conversation
          await _database.delete(
            'conversations',
            where: 'id = ?',
            whereArgs: [conversationId],
          );

          if (mounted) {
            setState(() {
              // Remove from conversations list
              _conversations.removeWhere((c) => c.id == conversationId);
              
              // Clear messages if this was the current conversation
              if (_currentConversationId == conversationId) {
                _currentConversationId = null;
                _messages.clear();
              }
            });

            // Reload conversations to ensure UI is in sync
            await _loadConversations();
          }
        } catch (e) {
          ErrorHandler.handleError(e);
        }
      },
      confirmText: 'Supprimer',
      confirmColor: Colors.red,
    );
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

    // Update conversation title if this is the first user message
    if (isUser && _messages.isEmpty) {
      // Truncate message if it's too long
      final title = message.length > 30 ? '${message.substring(0, 30)}...' : message;
      await _database.update(
        'conversations',
        {'title': title},
        where: 'id = ?',
        whereArgs: [_currentConversationId],
      );
      
      // Update the conversation in the list
      setState(() {
        final index = _conversations.indexWhere((c) => c.id == _currentConversationId);
        if (index != -1) {
          _conversations[index] = Conversation(
            id: _currentConversationId,
            title: title,
            createdAt: _conversations[index].createdAt,
          );
        }
      });
    }

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();
  }

  Future<void> _getGeminiResponse(String message) async {
    if (!_isConnected) {
      ErrorHandler.handleError(NetworkError(AppConfig.networkError));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Combine prompt definition with user message
      final finalPrompt = '$_promptDef\nPrompt : $message';
      
      final response = await retry(
        () => _model.generateContent([Content.text(finalPrompt)]),
        maxAttempts: 3,
        onRetry: (e) {
          ErrorHandler.logWarning('Retrying API call due to error: $e');
        },
      );
      
      if (response.text != null) {
        await _addMessage(response.text!, false);
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
    if (text.trim().isEmpty || _isLoading) return;

    _messageController.clear();
    _addMessage(text, true);
    _getGeminiResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       resizeToAvoidBottomInset:false ,
       extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
           automaticallyImplyLeading: false,
           leading: IconButton(
              icon: Icon(Icons.add, color: _messages.isNotEmpty? Colors.white : const Color.fromARGB(169, 255, 255, 255)),
              onPressed: _messages.isNotEmpty? _createNewConversation : null, 
              ) ,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            AppConfig.appName,
            style: AppConfig.headingStyle,
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
                          child:
                           ListView.builder(
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
                                  style: TextStyle(color: Colors.white.withAlpha(128)),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.white),
                                  onPressed: () => _deleteConversation(conversation.id!),
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
        body:Scaffold(
          body: Stack(
            children: [
                Linear(),
                 Positioned(
          top: 35.h,
                 right: 55.w,
           child: Transform.scale(
                scale: 3.0,
                 child: SvgPicture.asset(
          'assets/svg/background.svg',
          width: 35.w,
          height:35.h,
                 ),
           ),
                 ) ,
          
          
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.12,),
                  Expanded(
                    child:
                    _messages.isEmpty ?
                                Center(
                                  child: Text(
                                        "Comment puis-je vous aider ?",
                                           style: AppConfig.headingStyle,
                                      ),
                                ) : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
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
                                    color: Colors.black.withAlpha(32),
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
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextField(
                              controller: _messageController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Message...',
                                hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor:  Color(0xFF3200d5),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                              ),
                              onSubmitted: _handleSubmitted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color:   Color(0xFF3200d5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: _isLoading ? null : () => _handleSubmitted(_messageController.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    _connectivitySubscription?.cancel();
    super.dispose();
  }
} 


