import 'package:equatable/equatable.dart';

class AssistantMessageEntity extends Equatable {
  final int? id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final int conversationId;

  const AssistantMessageEntity({
    this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [id, message, isUser, timestamp, conversationId];
}
