import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/mock_data.dart';

/// Chat state management (local only, no backend)
class ChatProvider extends ChangeNotifier {
  List<ChatConversation> _conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};

  List<ChatConversation> get conversations => _conversations;

  void loadConversations() {
    _conversations = MockDataService.getMockConversations();
    notifyListeners();
  }

  List<ChatMessage> getMessages(String conversationId) {
    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = MockDataService.getMockMessages(conversationId);
    }
    return _messages[conversationId] ?? [];
  }

  void sendMessage(String conversationId, String message) {
    if (!_messages.containsKey(conversationId)) {
      _messages[conversationId] = MockDataService.getMockMessages(conversationId);
    }
    _messages[conversationId]!.add(ChatMessage(
      id: 'MSG_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'U001',
      receiverId: 'other',
      message: message,
      isSentByMe: true,
    ));

    // Update conversation last message
    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      final c = _conversations[idx];
      _conversations[idx] = ChatConversation(
        id: c.id,
        recipientName: c.recipientName,
        recipientImage: c.recipientImage,
        lastMessage: message,
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
        isOnline: c.isOnline,
        isVerified: c.isVerified,
        isPremium: c.isPremium,
      );
    }

    notifyListeners();

    // Simulate auto-reply after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _messages[conversationId]!.add(ChatMessage(
        id: 'MSG_REPLY_${DateTime.now().millisecondsSinceEpoch}',
        senderId: 'other',
        receiverId: 'U001',
        message: 'Thank you for your message! I will get back to you soon.',
        isSentByMe: false,
      ));
      notifyListeners();
    });
  }
}
