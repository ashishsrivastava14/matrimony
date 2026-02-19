/// Core user model for authentication & role management
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // guest, user, paid, mediator, admin
  final bool isVerified;
  final bool isPremium;
  final String? profileImage;
  final DateTime createdAt;
  final bool isBlocked;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.isVerified = false,
    this.isPremium = false,
    this.profileImage,
    DateTime? createdAt,
    this.isBlocked = false,
  }) : createdAt = createdAt ?? DateTime.now();

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isVerified,
    bool? isPremium,
    String? profileImage,
    DateTime? createdAt,
    bool? isBlocked,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
      isVerified: json['isVerified'] ?? false,
      isPremium: json['isPremium'] ?? false,
      profileImage: json['profileImage'],
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'isVerified': isVerified,
        'isPremium': isPremium,
        'profileImage': profileImage,
        'isBlocked': isBlocked,
      };
}
