import 'package:equatable/equatable.dart';

abstract class AssistantEvent extends Equatable {
  const AssistantEvent();
  @override
  List<Object?> get props => [];
}

class LoadConversations extends AssistantEvent {}

class LoadMessages extends AssistantEvent {
  final int conversationId;
  const LoadMessages(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class StartNewConversation extends AssistantEvent {}

class SendUserMessage extends AssistantEvent {
  final String text;
  const SendUserMessage(this.text);
  @override
  List<Object?> get props => [text];
}

class DeleteConversationEvent extends AssistantEvent {
  final int id;
  const DeleteConversationEvent(this.id);
  @override
  List<Object?> get props => [id];
}
