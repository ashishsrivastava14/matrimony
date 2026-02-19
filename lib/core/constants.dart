import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Application-wide constants
class AppConstants {
  // Non-localizable constants
  static const String maleAvatar = 'https://i.pravatar.cc/300?img=68';
  static const String femaleAvatar = 'https://i.pravatar.cc/300?img=47';
  static const String mockOtp = '1234';

  // Subscription tiers
  static const List<String> planDurations = ['Monthly', 'Quarterly', 'Yearly'];

  // Roles (keys only - use for identification)
  static const String roleGuest = 'guest';
  static const String roleUser = 'user';
  static const String rolePaid = 'paid';
  static const String roleMediator = 'mediator';
  static const String roleAdmin = 'admin';
  
  // Localizable app info - use AppLocalizations instead
  // appName → l10n.appName
  // tagline → l10n.tagline
  // yearsOfService → l10n.yearsOfService
  // customersServed → l10n.customersServed
}

/// Enum for user roles
enum UserRole { guest, user, paid, mediator, admin }

extension UserRoleX on UserRole {
  /// Get localized label for the role
  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case UserRole.guest:
        return l10n.guest;
      case UserRole.user:
        return l10n.registeredUser;
      case UserRole.paid:
        return l10n.paidMember;
      case UserRole.mediator:
        return l10n.mediatorBroker;
      case UserRole.admin:
        return l10n.admin;
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
