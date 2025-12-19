import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widgets/linear.dart';
import '../../../../core/config/app_config.dart';
import '../bloc/assistant_bloc.dart';
import '../bloc/assistant_event.dart';
import '../bloc/assistant_state.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          AppConfig.appName,
          style: AppConfig.headingStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => context.read<AssistantBloc>().add(StartNewConversation()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              context.read<AssistantBloc>().add(LoadConversations());
              _showHistory(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const Linear(),
          Positioned(
            top: 35.h,
            right: 55.w,
            child: Transform.scale(
              scale: 3.0,
              child: SvgPicture.asset(
                'assets/svg/background.svg',
                width: 35.w,
                height: 35.h,
              ),
            ),
          ),
          BlocConsumer<AssistantBloc, AssistantState>(
            listener: (context, state) {
              if (state is AssistantChatLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                   SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
                  Expanded(
                    child: _buildChatContent(state),
                  ),
                  _buildInputArea(state),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent(AssistantState state) {
    if (state is AssistantLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    } else if (state is AssistantChatLoaded) {
      if (state.messages.isEmpty) {
        return const Center(
          child: Text(
            "Comment puis-je vous aider ?",
            style: AppConfig.headingStyle,
          ),
        );
      }
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final message = state.messages[index];
          return _buildMessageBubble(message);
        },
      );
    } else if (state is AssistantError) {
      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
    }
    return const Center(
      child: Text(
        "Commencez une conversation",
        style: AppConfig.headingStyle,
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    final bool isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 75.w,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? Colors.white : const Color(0xFF3200d5).withValues(alpha: 0.8),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 5),
            bottomRight: Radius.circular(isUser ? 5 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: isUser ? const Color(0xFF3200d5) : Colors.white,
            fontSize: 11.sp,
            fontWeight: isUser ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInputArea(AssistantState state) {
    final bool isSending = state is AssistantChatLoaded && state.isSending;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Posez votre question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF3200d5).withValues(alpha: 0.05),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF3200d5),
            radius: 24,
            child: IconButton(
              icon: isSending 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: isSending ? null : () {
                if (_messageController.text.trim().isNotEmpty) {
                  context.read<AssistantBloc>().add(SendUserMessage(_messageController.text));
                  _messageController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocBuilder<AssistantBloc, AssistantState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: const Text('Historique', style: TextStyle(color: Color(0xFF3200d5), fontWeight: FontWeight.bold)),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF3200d5)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: state is AssistantConversationsLoaded
                      ? ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.conversations.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final conv = state.conversations[index];
                            return ListTile(
                              title: Text(conv.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                '${conv.createdAt.day}/${conv.createdAt.month}/${conv.createdAt.year}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => context.read<AssistantBloc>().add(DeleteConversationEvent(conv.id!)),
                              ),
                              onTap: () {
                                context.read<AssistantBloc>().add(LoadMessages(conv.id!));
                                Navigator.pop(context);
                              },
                            );
                          },
                        )
                      : const Center(child: CircularProgressIndicator(color: Color(0xFF3200d5))),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
