/// Subscription plan model
class SubscriptionPlan {
  final String id;
  final String name;
  final String duration; // Monthly, Quarterly, Yearly
  final double price;
  final double originalPrice;
  final List<String> features;
  final bool isPopular;
  final bool isEnabled;
  final int durationMonths;
  final int contactViews;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.originalPrice,
    required this.features,
    this.isPopular = false,
    this.isEnabled = true,
    this.durationMonths = 3,
    this.contactViews = 50,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? 'Monthly',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      features: List<String>.from(json['features'] ?? []),
      isPopular: json['isPopular'] ?? false,
      isEnabled: json['isEnabled'] ?? true,
      durationMonths: json['durationMonths'] ?? 3,
      contactViews: json['contactViews'] ?? 50,
    );
  }
}

/// Pay-per-profile unlock bundle
class ProfileUnlockBundle {
  final String id;
  final int profileCount;
  final double price;
  final bool isEnabled;

  int get unlockCount => profileCount;

  ProfileUnlockBundle({
    required this.id,
    required this.profileCount,
    required this.price,
    this.isEnabled = true,
  });
}
