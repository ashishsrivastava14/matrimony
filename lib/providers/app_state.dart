import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';
import '../models/notification_model.dart';
import '../models/subscription_plan.dart';
import '../models/mediator_model.dart';
import '../services/mock_data.dart';

/// Global application state managed via Provider
class AppState extends ChangeNotifier {
  // ── Auth state ─────────────────────────────────────────────────
  bool _isLoggedIn = false;
  UserRole _currentRole = UserRole.guest;
  UserModel? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  UserRole get currentRole => _currentRole;
  UserModel? get currentUser => _currentUser;

  // ── Subscription state ─────────────────────────────────────────
  bool _isSubscribed = false;
  int _unlockCount = 0;
  String _currentPlanId = '';

  bool get isSubscribed => _isSubscribed;
  int get unlockCount => _unlockCount;
  int get profileUnlocksRemaining => _unlockCount;
  String get currentPlanId => _currentPlanId;
  SubscriptionPlan? get currentPlan => _isSubscribed && _currentPlanId.isNotEmpty
      ? _plans.cast<SubscriptionPlan?>().firstWhere((p) => p!.id == _currentPlanId, orElse: () => null)
      : null;

  /// True when the user's plan includes horoscope matching (Gold / Diamond).
  bool get canAccessHoroscope {
    if (!_isSubscribed) return false;
    // Default paid user with no explicit plan gets full access
    if (_currentPlanId.isEmpty) return true;
    return _currentPlanId == 'PLAN_Q' || _currentPlanId == 'PLAN_Y';
  }

  // ── Profile data ───────────────────────────────────────────────
  List<ProfileModel> _profiles = [];
  List<ProfileModel> _shortlisted = [];
  List<String> _sentInterests = [];
  List<String> _receivedInterests = [];
  List<String> _acceptedInterests = [];
  List<String> _declinedInterests = [];
  final Set<String> _hiddenProfiles = {};
  final Set<String> _unlockedProfiles = {};

  List<ProfileModel> get profiles =>
      _profiles.where((p) => !_hiddenProfiles.contains(p.id)).toList();
  Set<String> get hiddenProfiles => _hiddenProfiles;
  bool isHidden(String profileId) => _hiddenProfiles.contains(profileId);
  bool isProfileUnlocked(String profileId) =>
      _isSubscribed || _unlockedProfiles.contains(profileId);
  List<ProfileModel> get shortlisted => _shortlisted;
  List<String> get sentInterests => _sentInterests;
  List<String> get receivedInterests => _receivedInterests;
  List<String> get acceptedInterests => _acceptedInterests;
  List<String> get declinedInterests => _declinedInterests;

  // Alias getters used by interest_management_screen (returns Set<String>)
  Set<String> get interestsReceived => _receivedInterests.toSet();
  Set<String> get interestsSent => _sentInterests.toSet();
  Set<String> get interestsAccepted => _acceptedInterests.toSet();
  Set<String> get interestsDeclined => _declinedInterests.toSet();

  // ── Notifications ──────────────────────────────────────────────
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  int get unreadNotifications => _notifications.where((n) => !n.isRead).length;

  // ── User management (admin) ────────────────────────────────────
  List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;
  Set<String> get blockedUsers => _allUsers.where((u) => u.isBlocked).map((u) => u.id).toSet();

  // ── Profile approval (admin) ───────────────────────────────────
  final Set<String> _rejectedProfileIds = {};
  Set<String> get rejectedProfileIds => _rejectedProfileIds;

  List<ProfileModel> get allProfiles => _profiles;

  List<ProfileModel> get pendingProfiles =>
      _profiles.where((p) => !p.isVerified && !_rejectedProfileIds.contains(p.id)).toList();

  List<ProfileModel> get approvedProfiles =>
      _profiles.where((p) => p.isVerified).toList();

  List<ProfileModel> get rejectedProfiles =>
      _profiles.where((p) => _rejectedProfileIds.contains(p.id)).toList();

  // ── Mediator management (admin) ───────────────────────────────
  List<MediatorModel> _mediators = [];
  List<MediatorModel> get mediators => _mediators;

  // ── Subscription plans (admin) ─────────────────────────────────
  List<SubscriptionPlan> _plans = [];
  List<SubscriptionPlan> get plans => _plans;
  // ── Bottom-nav shell index (shared between HomeScreen & UserShell) ──
  int _shellIndex = 0;
  int get shellIndex => _shellIndex;
  void setShellIndex(int index) {
    if (_shellIndex == index) return;
    _shellIndex = index;
    notifyListeners();
  }
  // ── Profile completion ─────────────────────────────────────────
  int _profileCompletion = 65;
  int get profileCompletion => _profileCompletion;

  // ── Initialize mock data ───────────────────────────────────────
  void loadMockData() {
    _profiles = MockDataService.getMockProfiles();
    _notifications = MockDataService.getMockNotifications();
    _allUsers = MockDataService.getMockUsers();
    _plans = MockDataService.getMockPlans();
    _mediators = MockDataService.getMockMediators();
    _receivedInterests = ['P002', 'P008', 'P011', 'P014', 'P019', 'P021', 'P024', 'P027', 'P029', 'P032', 'P037'];
    _sentInterests = ['P003', 'P012', 'P018', 'P030', 'P035'];
    _acceptedInterests = ['P002', 'P011', 'P021'];
    _declinedInterests = ['P008'];
    notifyListeners();
  }

  // ── Auth methods ───────────────────────────────────────────────
  /// Mock login — replace with real API call
  void login(UserRole role, {String? email}) {
    _isLoggedIn = true;
    _currentRole = role;

    // Create a mock user based on role
    switch (role) {
      case UserRole.admin:
        _currentUser = UserModel(
          id: 'ADMIN001',
          name: 'Admin User',
          email: email ?? 'admin@matrimony.com',
          phone: '+91 99999 99999',
          role: 'admin',
          isVerified: true,
        );
        break;
      case UserRole.mediator:
        _currentUser = UserModel(
          id: 'MED001',
          name: 'Rajesh Kumar',
          email: email ?? 'rajesh@mediator.com',
          phone: '+91 99887 76654',
          role: 'mediator',
          isVerified: true,
        );
        break;
      case UserRole.paid:
        _currentUser = UserModel(
          id: 'U001',
          name: 'Karthick',
          email: email ?? 'karthick@gmail.com',
          phone: '+91 98765 43211',
          role: 'paid',
          isVerified: true,
          isPremium: true,
          profileImage: 'https://i.pravatar.cc/300?img=68',
        );
        _isSubscribed = true;
        _currentPlanId = 'PLAN_Q'; // Gold plan by default
        _unlockCount = 10;
        _profileCompletion = 90;
        break;
      case UserRole.user:
        _currentUser = UserModel(
          id: 'U005',
          name: 'Meera Desigan',
          email: email ?? 'meera@gmail.com',
          phone: '+91 90*** *****',
          role: 'user',
          isVerified: false,
          profileImage: 'https://i.pravatar.cc/300?img=44',
        );
        _isSubscribed = false;
        _unlockCount = 0;
        _profileCompletion = 55;
        break;
      case UserRole.guest:
        _currentUser = null;
        break;
    }

    loadMockData();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentRole = UserRole.guest;
    _currentUser = null;
    _isSubscribed = false;
    _unlockCount = 0;
    _profiles = [];
    _shortlisted = [];
    _sentInterests = [];
    _receivedInterests = [];
    _acceptedInterests = [];
    _declinedInterests = [];
    _hiddenProfiles.clear();
    _unlockedProfiles.clear();
    _notifications = [];
    notifyListeners();
  }

  // ── Profile actions ────────────────────────────────────────────
  void toggleShortlist(ProfileModel profile) {
    if (_shortlisted.any((p) => p.id == profile.id)) {
      _shortlisted.removeWhere((p) => p.id == profile.id);
    } else {
      _shortlisted.add(profile);
    }
    notifyListeners();
  }

  bool isShortlisted(String profileId) {
    return _shortlisted.any((p) => p.id == profileId);
  }

  void sendInterest(String profileId) {
    if (!_sentInterests.contains(profileId)) {
      _sentInterests.add(profileId);
      notifyListeners();
    }
  }

  void hideProfile(String profileId) {
    _hiddenProfiles.add(profileId);
    _shortlisted.removeWhere((p) => p.id == profileId);
    notifyListeners();
  }

  void acceptInterest(String profileId) {
    if (_receivedInterests.contains(profileId)) {
      _receivedInterests.remove(profileId);
      _acceptedInterests.add(profileId);
      notifyListeners();
    }
  }

  void declineInterest(String profileId) {
    if (_receivedInterests.contains(profileId)) {
      _receivedInterests.remove(profileId);
      _declinedInterests.add(profileId);
      notifyListeners();
    }
  }

  // ── Subscription actions ───────────────────────────────────────
  void subscribeToPlan(String planId) {
    _isSubscribed = true;
    _currentPlanId = planId;
    _currentRole = UserRole.paid;
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isPremium: true, role: 'paid');
    }
    notifyListeners();
  }

  // ── Subscription plan CRUD (admin) ─────────────────────────────
  void addPlan(SubscriptionPlan plan) {
    _plans.add(plan);
    notifyListeners();
  }

  void updatePlan(SubscriptionPlan updated) {
    final idx = _plans.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      _plans[idx] = updated;
      notifyListeners();
    }
  }

  void deletePlan(String planId) {
    _plans.removeWhere((p) => p.id == planId);
    notifyListeners();
  }

  void togglePlanEnabled(String planId) {
    final idx = _plans.indexWhere((p) => p.id == planId);
    if (idx != -1) {
      _plans[idx] = _plans[idx].copyWith(isEnabled: !_plans[idx].isEnabled);
      notifyListeners();
    }
  }

  // ── Mediator CRUD (admin) ──────────────────────────────────────
  void addMediator(MediatorModel mediator) {
    _mediators.add(mediator);
    notifyListeners();
  }

  void updateMediator(MediatorModel updated) {
    final idx = _mediators.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      _mediators[idx] = updated;
      notifyListeners();
    }
  }

  void deleteMediator(String mediatorId) {
    _mediators.removeWhere((m) => m.id == mediatorId);
    notifyListeners();
  }

  void toggleMediatorActive(String mediatorId) {
    final idx = _mediators.indexWhere((m) => m.id == mediatorId);
    if (idx != -1) {
      _mediators[idx] = _mediators[idx].copyWith(isActive: !_mediators[idx].isActive);
      notifyListeners();
    }
  }

  // ── Commission settings ────────────────────────────────────────
  double _commissionDefaultRate = 10;
  double _commissionPremiumRate = 15;
  double _commissionMinPayout = 500;
  double _commissionPerMatch = 2000;
  double _commissionPerProfile = 200;
  double _commissionSubscriptionReferral = 10;
  double _commissionBonusPerMonth = 5000;

  double get commissionDefaultRate => _commissionDefaultRate;
  double get commissionPremiumRate => _commissionPremiumRate;
  double get commissionMinPayout => _commissionMinPayout;
  double get commissionPerMatch => _commissionPerMatch;
  double get commissionPerProfile => _commissionPerProfile;
  double get commissionSubscriptionReferral => _commissionSubscriptionReferral;
  double get commissionBonusPerMonth => _commissionBonusPerMonth;

  void saveCommissionSettings({
    required double defaultRate,
    required double premiumRate,
    required double minPayout,
    required double perMatch,
    required double perProfile,
    required double subscriptionReferral,
    required double bonusPerMonth,
  }) {
    _commissionDefaultRate = defaultRate;
    _commissionPremiumRate = premiumRate;
    _commissionMinPayout = minPayout;
    _commissionPerMatch = perMatch;
    _commissionPerProfile = perProfile;
    _commissionSubscriptionReferral = subscriptionReferral;
    _commissionBonusPerMonth = bonusPerMonth;
    notifyListeners();
  }

  void purchaseUnlockBundle(int count) {
    _unlockCount += count;
    notifyListeners();
  }

  bool useUnlock([String? profileId]) {
    if (_isSubscribed) {
      if (profileId != null) _unlockedProfiles.add(profileId);
      notifyListeners();
      return true;
    }
    if (_unlockCount > 0) {
      _unlockCount--;
      if (profileId != null) _unlockedProfiles.add(profileId);
      notifyListeners();
      return true;
    }
    return false;
  }

  // ── Admin actions ──────────────────────────────────────────────
  void approveProfile(String profileId) {
    final idx = _profiles.indexWhere((p) => p.id == profileId);
    if (idx != -1) {
      _rejectedProfileIds.remove(profileId);
      _profiles[idx] = _profiles[idx].copyWith(isVerified: true, isApproved: true);
      notifyListeners();
    }
  }

  void rejectProfile(String profileId) {
    final idx = _profiles.indexWhere((p) => p.id == profileId);
    if (idx != -1) {
      _rejectedProfileIds.add(profileId);
      _profiles[idx] = _profiles[idx].copyWith(isVerified: false, isApproved: false);
      notifyListeners();
    }
  }

  void undoRejectProfile(String profileId) {
    _rejectedProfileIds.remove(profileId);
    notifyListeners();
  }

  void revokeApproval(String profileId) {
    final idx = _profiles.indexWhere((p) => p.id == profileId);
    if (idx != -1) {
      // Move back to pending: clear verified flag but do NOT add to rejected set
      _rejectedProfileIds.remove(profileId);
      _profiles[idx] = _profiles[idx].copyWith(isVerified: false, isApproved: false);
      notifyListeners();
    }
  }

  void toggleUserBlock(String userId) {
    final idx = _allUsers.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _allUsers[idx] = _allUsers[idx].copyWith(isBlocked: !_allUsers[idx].isBlocked);
      notifyListeners();
    }
  }

  void toggleUserVerification(String userId) {
    final idx = _allUsers.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      _allUsers[idx] = _allUsers[idx].copyWith(isVerified: !_allUsers[idx].isVerified);
      notifyListeners();
    }
  }

  void addUser(UserModel user) {
    _allUsers.add(user);
    notifyListeners();
  }

  void updateUser(UserModel updated) {
    final idx = _allUsers.indexWhere((u) => u.id == updated.id);
    if (idx != -1) {
      _allUsers[idx] = updated;
      notifyListeners();
    }
  }

  void deleteUser(String userId) {
    _allUsers.removeWhere((u) => u.id == userId);
    notifyListeners();
  }

  void updateProfileCompletion(int value) {
    _profileCompletion = value;
    notifyListeners();
  }

  // ── Notification actions ───────────────────────────────────────
  void markNotificationRead(String notificationId) {
    final idx = _notifications.indexWhere((n) => n.id == notificationId);
    if (idx != -1) {
      final n = _notifications[idx];
      _notifications[idx] = NotificationModel(
        id: n.id,
        title: n.title,
        body: n.body,
        type: n.type,
        isRead: true,
        createdAt: n.createdAt,
      );
      notifyListeners();
    }
  }
}
