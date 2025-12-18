import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/assistant_message_entity.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/assistant_usecases.dart';
import 'assistant_event.dart';
import 'assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  final GetConversations getConversations;
  final CreateConversation createConversation;
  final DeleteConversation deleteConversation;
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final SaveMessage saveMessage;
  final UpdateConversationTitle updateConversationTitle;

  AssistantBloc({
    required this.getConversations,
    required this.createConversation,
    required this.deleteConversation,
    required this.getMessages,
    required this.sendMessage,
    required this.saveMessage,
    required this.updateConversationTitle,
  }) : super(AssistantInitial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<StartNewConversation>(_onStartNewConversation);
    on<SendUserMessage>(_onSendUserMessage);
    on<DeleteConversationEvent>(_onDeleteConversation);
  }

  Future<void> _onLoadConversations(LoadConversations event, Emitter<AssistantState> emit) async {
    emit(AssistantLoading());
    try {
      final conversations = await getConversations();
      emit(AssistantConversationsLoaded(conversations));
    } catch (e) {
      emit(const AssistantError('Failed to load conversations'));
    }
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<AssistantState> emit) async {
    emit(AssistantLoading());
    try {
      final messages = await getMessages(event.conversationId);
      emit(AssistantChatLoaded(
        messages: messages,
        currentConversationId: event.conversationId,
      ));
    } catch (e) {
      emit(const AssistantError('Failed to load messages'));
    }
  }

  Future<void> _onStartNewConversation(StartNewConversation event, Emitter<AssistantState> emit) async {
    final newConv = ConversationEntity(
      title: 'Nouvelle conversation',
      createdAt: DateTime.now(),
    );
    try {
      final id = await createConversation(newConv);
      emit(AssistantChatLoaded(messages: const [], currentConversationId: id));
    } catch (e) {
      emit(const AssistantError('Failed to create conversation'));
    }
  }

  Future<void> _onSendUserMessage(SendUserMessage event, Emitter<AssistantState> emit) async {
    if (state is! AssistantChatLoaded) return;
    final currentState = state as AssistantChatLoaded;
    int? convId = currentState.currentConversationId;

    if (convId == null) {
      final newConv = ConversationEntity(
        title: event.text.length > 30 ? '${event.text.substring(0, 30)}...' : event.text,
        createdAt: DateTime.now(),
      );
      convId = await createConversation(newConv);
    } else if (currentState.messages.isEmpty) {
      final title = event.text.length > 30 ? '${event.text.substring(0, 30)}...' : event.text;
      await updateConversationTitle(convId, title);
    }

    final userMsg = AssistantMessageEntity(
      message: event.text,
      isUser: true,
      timestamp: DateTime.now(),
      conversationId: convId,
    );

    await saveMessage(userMsg);
    final updatedMessages = List<AssistantMessageEntity>.from(currentState.messages)..add(userMsg);
    
    emit(AssistantChatLoaded(
      messages: updatedMessages,
      currentConversationId: convId,
      isSending: true,
    ));

    try {
      final responseText = await sendMessage(event.text);
      final assistantMsg = AssistantMessageEntity(
        message: responseText,
        isUser: false,
        timestamp: DateTime.now(),
        conversationId: convId,
      );
      await saveMessage(assistantMsg);
      
      final finalMessages = List<AssistantMessageEntity>.from(updatedMessages)..add(assistantMsg);
      emit(AssistantChatLoaded(
        messages: finalMessages,
        currentConversationId: convId,
        isSending: false,
      ));
    } catch (e) {
      emit(AssistantChatLoaded(
        messages: updatedMessages,
        currentConversationId: convId,
        isSending: false,
      ));
      // Optionally emit error or toast
    }
  }

  Future<void> _onDeleteConversation(DeleteConversationEvent event, Emitter<AssistantState> emit) async {
    try {
      await deleteConversation(event.id);
      add(LoadConversations());
    } catch (e) {
      emit(const AssistantError('Failed to delete conversation'));
    }
  }
}
