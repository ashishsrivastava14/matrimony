import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart' show ChatConversation;
import 'package:intl/intl.dart';
import '../widgets/powered_by_footer.dart';

/// Chat conversations list screen
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const PoweredByFooter(),
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chat, _) {
          if (chat.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No Conversations Yet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  const Text('Start chatting with your matches',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: chat.conversations.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 80),
            itemBuilder: (context, i) {
              final conv = chat.conversations[i];
              return _ConversationTile(
                conversation: conv,
                onTap: () => Navigator.of(context).pushNamed(
                  '/chat',
                  arguments: conv,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback? onTap;

  const _ConversationTile({required this.conversation, this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeText = _formatTime(conversation.lastMessageTime);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage(conversation.recipientImage),
            onBackgroundImageError: (_, _) {},
            child: conversation.recipientImage.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          if (conversation.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  conversation.recipientName,
                  style: TextStyle(
                    fontWeight: conversation.unreadCount > 0
                        ? FontWeight.bold
                        : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                if (conversation.isVerified) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.verified,
                      size: 14, color: AppColors.verified),
                ],
                if (conversation.isPremium) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.workspace_premium,
                      size: 14, color: AppColors.accent),
                ],
              ],
            ),
          ),
          Text(
            timeText,
            style: TextStyle(
              fontSize: 11,
              color: conversation.unreadCount > 0
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: conversation.unreadCount > 0
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return DateFormat('h:mm a').format(dt);
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('dd/MM').format(dt);
  }
}
