/// Types of chat messages supported
enum ChatMessageType { text, image, document, location }

/// Chat message model (local state only)
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final bool isSentByMe;
  final ChatMessageType type;
  final String? attachmentData; // image asset path | doc name | "lat,lon|label"

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    DateTime? timestamp,
    this.isRead = false,
    this.isSentByMe = true,
    this.type = ChatMessageType.text,
    this.attachmentData,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Chat conversation summary
class ChatConversation {
  final String id;
  final String recipientName;
  final String recipientImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isVerified;
  final bool isPremium;

  ChatConversation({
    required this.id,
    required this.recipientName,
    required this.recipientImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isVerified = false,
    this.isPremium = false,
  });
}
