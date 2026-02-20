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

  MediatorModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    int? totalProfiles,
    int? activeMatches,
    double? commissionEarned,
    double? walletBalance,
    bool? isActive,
    String? district,
    String? state,
    DateTime? joinedAt,
  }) {
    return MediatorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      totalProfiles: totalProfiles ?? this.totalProfiles,
      activeMatches: activeMatches ?? this.activeMatches,
      commissionEarned: commissionEarned ?? this.commissionEarned,
      walletBalance: walletBalance ?? this.walletBalance,
      isActive: isActive ?? this.isActive,
      district: district ?? this.district,
      state: state ?? this.state,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
