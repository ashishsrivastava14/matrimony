import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';
import '../models/notification_model.dart';
import '../models/subscription_plan.dart';
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
