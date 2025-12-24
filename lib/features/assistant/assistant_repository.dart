import 'conversation_entity.dart';
import 'assistant_message_entity.dart';

abstract class AssistantRepository {
  Future<List<ConversationEntity>> getConversations();
  Future<int> createConversation(ConversationEntity conversation);
  Future<void> deleteConversation(int id);
  Future<List<AssistantMessageEntity>> getMessages(int conversationId);
  Future<int> saveMessage(AssistantMessageEntity message);
  Future<void> updateConversationTitle(int id, String title);
  Future<String> getAssistantResponse(String prompt);
}
