/// Mediator / Broker model
class MediatorModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int totalProfiles;
  final int activeMatches;
  final double commissionEarned;
  final double walletBalance;
  final bool isActive;
  final DateTime joinedAt;
  final String district;
  final String state;

  MediatorModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.totalProfiles = 0,
    this.activeMatches = 0,
    this.commissionEarned = 0.0,
    this.walletBalance = 0.0,
    this.isActive = true,
    this.district = 'Chennai',
    this.state = 'Tamil Nadu',
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  factory MediatorModel.fromJson(Map<String, dynamic> json) {
    return MediatorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      totalProfiles: json['totalProfiles'] ?? 0,
      activeMatches: json['activeMatches'] ?? 0,
      commissionEarned: (json['commissionEarned'] ?? 0).toDouble(),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
      district: json['district'] ?? 'Chennai',
      state: json['state'] ?? 'Tamil Nadu',
    );
  }
}
