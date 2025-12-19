import '../../domain/entities/assistant_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/assistant_repository.dart';
import '../datasources/assistant_local_datasource.dart';
import '../datasources/assistant_remote_datasource.dart';
import '../models/assistant_message_model.dart';
import '../models/conversation_model.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: AssistantRepository)
class AssistantRepositoryImpl implements AssistantRepository {
  final AssistantLocalDataSource localDataSource;
  final AssistantRemoteDataSource remoteDataSource;

  AssistantRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<ConversationEntity>> getConversations() async {
    return await localDataSource.getConversations();
  }

  @override
  Future<int> createConversation(ConversationEntity conversation) async {
    return await localDataSource.createConversation(
      ConversationModel.fromEntity(conversation),
    );
  }

  @override
  Future<void> deleteConversation(int id) async {
    await localDataSource.deleteConversation(id);
  }

  @override
  Future<List<AssistantMessageEntity>> getMessages(int conversationId) async {
    return await localDataSource.getMessages(conversationId);
  }

  @override
  Future<int> saveMessage(AssistantMessageEntity message) async {
    return await localDataSource.saveMessage(
      AssistantMessageModel.fromEntity(message),
    );
  }

  @override
  Future<void> updateConversationTitle(int id, String title) async {
    await localDataSource.updateConversationTitle(id, title);
  }

  @override
  Future<String> getAssistantResponse(String prompt) async {
    return await remoteDataSource.getGeminiResponse(prompt);
  }
}
