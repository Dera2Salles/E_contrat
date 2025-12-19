import 'package:injectable/injectable.dart';
import '../entities/conversation_entity.dart';
import '../entities/assistant_message_entity.dart';
import '../repositories/assistant_repository.dart';

@injectable
class GetConversations {
  final AssistantRepository repository;
  GetConversations(this.repository);
  Future<List<ConversationEntity>> call() => repository.getConversations();
}

@injectable
class CreateConversation {
  final AssistantRepository repository;
  CreateConversation(this.repository);
  Future<int> call(ConversationEntity conversation) => repository.createConversation(conversation);
}

@injectable
class DeleteConversation {
  final AssistantRepository repository;
  DeleteConversation(this.repository);
  Future<void> call(int id) => repository.deleteConversation(id);
}

@injectable
class GetMessages {
  final AssistantRepository repository;
  GetMessages(this.repository);
  Future<List<AssistantMessageEntity>> call(int conversationId) => repository.getMessages(conversationId);
}

@injectable
class SendMessage {
  final AssistantRepository repository;
  SendMessage(this.repository);
  Future<String> call(String prompt) => repository.getAssistantResponse(prompt);
}

@injectable
class SaveMessage {
  final AssistantRepository repository;
  SaveMessage(this.repository);
  Future<int> call(AssistantMessageEntity message) => repository.saveMessage(message);
}

@injectable
class UpdateConversationTitle {
  final AssistantRepository repository;
  UpdateConversationTitle(this.repository);
  Future<void> call(int id, String title) => repository.updateConversationTitle(id, title);
}
