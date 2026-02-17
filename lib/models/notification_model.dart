/// In-app notification model
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // interest, match, message, system
  final bool isRead;
  final DateTime createdAt;
  final String? targetUserId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'system',
    this.isRead = false,
    DateTime? createdAt,
    this.targetUserId,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'system',
      isRead: json['isRead'] ?? false,
      targetUserId: json['targetUserId'],
    );
  }
}
