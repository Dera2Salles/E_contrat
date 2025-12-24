import 'assistant_message_entity.dart';

class AssistantMessageModel extends AssistantMessageEntity {
  const AssistantMessageModel({
    super.id,
    required super.message,
    required super.isUser,
    required super.timestamp,
    required super.conversationId,
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

  factory AssistantMessageModel.fromMap(Map<String, dynamic> map) {
    return AssistantMessageModel(
      id: map['id'],
      message: map['message'],
      isUser: map['isUser'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
      conversationId: map['conversationId'],
    );
  }

  factory AssistantMessageModel.fromEntity(AssistantMessageEntity entity) {
    return AssistantMessageModel(
      id: entity.id,
      message: entity.message,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      conversationId: entity.conversationId,
    );
  }
}
