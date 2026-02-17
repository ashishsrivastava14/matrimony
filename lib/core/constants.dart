/// Application-wide constants
class AppConstants {
  static const String appName = 'AP Matrimony';
  static const String tagline = 'Biggest Matrimony Service for AP';
  static const String yearsText = '10 Years of Successful Matchmaking';
  static const String membersText = '1 Crore+ Customers Served';

  // Dummy avatar placeholders
  static const String maleAvatar = 'https://i.pravatar.cc/300?img=68';
  static const String femaleAvatar = 'https://i.pravatar.cc/300?img=47';

  // Mock OTP
  static const String mockOtp = '1234';

  // Subscription tiers
  static const List<String> planDurations = ['Monthly', 'Quarterly', 'Yearly'];

  // Roles
  static const String roleGuest = 'guest';
  static const String roleUser = 'user';
  static const String rolePaid = 'paid';
  static const String roleMediator = 'mediator';
  static const String roleAdmin = 'admin';
}

/// Enum for user roles
enum UserRole { guest, user, paid, mediator, admin }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.guest:
        return 'Guest';
      case UserRole.user:
        return 'Registered User (Free)';
      case UserRole.paid:
        return 'Paid Member';
      case UserRole.mediator:
        return 'Mediator / Broker';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String get value {
    switch (this) {
      case UserRole.guest:
        return AppConstants.roleGuest;
      case UserRole.user:
        return AppConstants.roleUser;
      case UserRole.paid:
        return AppConstants.rolePaid;
      case UserRole.mediator:
        return AppConstants.roleMediator;
      case UserRole.admin:
        return AppConstants.roleAdmin;
    }
  }
}
