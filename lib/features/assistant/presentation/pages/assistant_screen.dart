import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/linear.dart';
import '../../../../core/config/app_config.dart';
import '../../contract/presentation/responsive.dart';
import '../bloc/assistant_bloc.dart';
import '../bloc/assistant_event.dart';
import '../bloc/assistant_state.dart';
import 'dart:ui' as ui;

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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppConfig.appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.rf(24),
            fontWeight: FontWeight.w900,
            fontFamily: 'Outfit',
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: context.rs(28)),
          onPressed: () => context.read<AssistantBloc>().add(StartNewConversation()),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history_rounded, color: Colors.white, size: context.rs(28)),
            onPressed: () {
              context.read<AssistantBloc>().add(LoadConversations());
              _showHistory(context);
            },
          ),
          SizedBox(width: context.rs(8)),
        ],
      ),
      body: Stack(
        children: [
          const Linear(),
          // Subtle glow effect
          Positioned(
            top: -context.rs(50),
            left: -context.rs(50),
            child: Container(
              width: context.rs(300),
              height: context.rs(300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [scheme.primary.withValues(alpha: 0.2), Colors.transparent],
                ),
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
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded, color: Colors.white, size: context.rs(64)).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms),
              SizedBox(height: context.rs(20)),
              Text(
                "Comment puis-je vous aider ?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: context.rf(20),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(context.rs(16), context.rs(100), context.rs(16), context.rs(16)),
        physics: const BouncingScrollPhysics(),
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final message = state.messages[index];
          return _buildMessageBubble(message);
        },
      );
    } else if (state is AssistantError) {
      return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)));
    }
    return Center(
      child: Text(
        "Commencez une conversation",
        style: TextStyle(
          color: Colors.white,
          fontSize: context.rf(18),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    final bool isUser = message.isUser;
    final scheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: context.isExpanded ? context.rs(500) : context.rs(280),
        ),
        margin: EdgeInsets.symmetric(vertical: context.rs(8)),
        padding: EdgeInsets.all(context.rs(16)),
        decoration: BoxDecoration(
          color: isUser 
            ? Colors.white.withValues(alpha: 0.95) 
            : scheme.primary.withValues(alpha: 0.8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.rs(20)),
            topRight: Radius.circular(context.rs(20)),
            bottomLeft: Radius.circular(isUser ? context.rs(20) : context.rs(5)),
            bottomRight: Radius.circular(isUser ? context.rs(5) : context.rs(20)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: isUser ? scheme.primary : Colors.white,
            fontSize: context.rf(16),
            fontWeight: isUser ? FontWeight.w700 : FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildInputArea(AssistantState state) {
    final bool isSending = state is AssistantChatLoaded && state.isSending;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(context.rs(16), context.rs(12), context.rs(16), context.rs(32)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.rs(30))),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.rs(30)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  style: TextStyle(color: Colors.black87, fontSize: context.rf(16)),
                  decoration: InputDecoration(
                    hintText: 'Posez votre question...',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: context.rf(16)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.rs(30)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: scheme.primary.withValues(alpha: 0.05),
                    contentPadding: EdgeInsets.symmetric(horizontal: context.rs(24), vertical: context.rs(12)),
                  ),
                ),
              ),
              SizedBox(width: context.rs(12)),
              GestureDetector(
                onTap: isSending ? null : () {
                  if (_messageController.text.trim().isNotEmpty) {
                    context.read<AssistantBloc>().add(SendUserMessage(_messageController.text));
                    _messageController.clear();
                  }
                },
                child: Container(
                  height: context.rs(54),
                  width: context.rs(54),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: scheme.primary.withValues(alpha: 0.4), blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Center(
                    child: isSending 
                      ? SizedBox(width: context.rs(24), height: context.rs(24), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Icon(Icons.send_rounded, color: Colors.white, size: context.rs(24)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocBuilder<AssistantBloc, AssistantState>(
        builder: (context, state) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(context.rs(32))),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(context.rs(32))),
                ),
                child: Column(
                  children: [
                    SizedBox(height: context.rs(12)),
                    Center(
                      child: Container(
                        width: context.rs(40),
                        height: context.rs(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(context.rs(2)),
                        ),
                      ),
                    ),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Text(
                        'Historique',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: context.rf(22),
                          fontFamily: 'Outfit',
                        ),
                      ),
                      centerTitle: true,
                      actions: [
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: Colors.black54, size: context.rs(28)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: context.rs(8)),
                      ],
                    ),
                    Expanded(
                      child: state is AssistantConversationsLoaded
                          ? ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.conversations.length,
                              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.black.withValues(alpha: 0.05)),
                              itemBuilder: (context, index) {
                                final conv = state.conversations[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: context.rs(16), vertical: context.rs(4)),
                                  leading: Container(
                                    padding: EdgeInsets.all(context.rs(10)),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.chat_bubble_outline_rounded, color: Theme.of(context).colorScheme.primary, size: context.rs(24)),
                                  ),
                                  title: Text(
                                    conv.title,
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: context.rf(16)),
                                  ),
                                  subtitle: Text(
                                    '${conv.createdAt.day}/${conv.createdAt.month}/${conv.createdAt.year}',
                                    style: TextStyle(color: Colors.black45, fontSize: context.rf(13)),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: context.rs(24)),
                                    onPressed: () => context.read<AssistantBloc>().add(DeleteConversationEvent(conv.id!)),
                                  ),
                                  onTap: () {
                                    context.read<AssistantBloc>().add(LoadMessages(conv.id!));
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            )
                          : Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
