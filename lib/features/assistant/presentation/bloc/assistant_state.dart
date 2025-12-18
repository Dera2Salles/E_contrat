import 'package:equatable/equatable.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/assistant_message_entity.dart';

abstract class AssistantState extends Equatable {
  const AssistantState();
  @override
  List<Object?> get props => [];
}

class AssistantInitial extends AssistantState {}

class AssistantLoading extends AssistantState {}

class AssistantConversationsLoaded extends AssistantState {
  final List<ConversationEntity> conversations;
  const AssistantConversationsLoaded(this.conversations);
  @override
  List<Object?> get props => [conversations];
}

class AssistantChatLoaded extends AssistantState {
  final List<AssistantMessageEntity> messages;
  final int? currentConversationId;
  final bool isSending;
  const AssistantChatLoaded({
    required this.messages,
    this.currentConversationId,
    this.isSending = false,
  });
  @override
  List<Object?> get props => [messages, currentConversationId, isSending];
}

class AssistantError extends AssistantState {
  final String message;
  const AssistantError(this.message);
  @override
  List<Object?> get props => [message];
}
