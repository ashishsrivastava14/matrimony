import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/responsive.dart';
import 'admin_dashboard.dart';
import 'user_management_screen.dart';
import 'profile_approvals_screen.dart';
import 'subscription_management_screen.dart';
import 'mediator_management_screen.dart';
import 'commission_settings_screen.dart';
import 'wallet_management_screen.dart';
import 'cms_screen.dart';
import 'banner_management_screen.dart';
import 'reports_screen.dart';
import 'notification_broadcast_screen.dart';
import 'horoscope_settings_screen.dart';
import 'pay_per_profile_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  final _menuItems = const [
    _MenuItem(Icons.dashboard, 'Dashboard'),
    _MenuItem(Icons.people, 'Users'),
    _MenuItem(Icons.verified_user, 'Profile Approvals'),
    _MenuItem(Icons.card_membership, 'Subscriptions'),
    _MenuItem(Icons.support_agent, 'Mediators'),
    _MenuItem(Icons.percent, 'Commission'),
    _MenuItem(Icons.account_balance_wallet, 'Wallet'),
    _MenuItem(Icons.article, 'CMS'),
    _MenuItem(Icons.image, 'Banners'),
    _MenuItem(Icons.bar_chart, 'Reports'),
    _MenuItem(Icons.notifications_active, 'Broadcast'),
    _MenuItem(Icons.auto_awesome, 'Horoscope'),
    _MenuItem(Icons.lock_open, 'Pay Per Profile'),
  ];

  final _screens = const [
    AdminDashboard(),
    UserManagementScreen(),
    ProfileApprovalsScreen(),
    SubscriptionManagementScreen(),
    MediatorManagementScreen(),
    CommissionSettingsScreen(),
    WalletManagementScreen(),
    CmsScreen(),
    BannerManagementScreen(),
    ReportsScreen(),
    NotificationBroadcastScreen(),
    HoroscopeSettingsScreen(),
    PayPerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (isDesktop || isTablet) {
      return _buildDesktopLayout();
    }
    return _buildMobileLayout();
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: const Color(0xFF1A1A2E),
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Row(
                    children: [
                      Icon(Icons.favorite, color: AppColors.accent, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Matrimony Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),

                // Menu items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = index == _selectedIndex;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(item.icon,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white54,
                              size: 20),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white70,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onTap: () =>
                              setState(() => _selectedIndex = index),
                        ),
                      );
                    },
                  ),
                ),

                // Logout
                const Divider(color: Colors.white12, height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white54),
                  title: const Text('Logout',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/role-selection', (_) => false);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00897B),
                Color(0xFF26A69A),
                Color(0xFF00796B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(_menuItems[_selectedIndex].label),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1A1A2E),
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: AppColors.accent),
                      SizedBox(width: 8),
                      Text('Matrimony Admin',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = index == _selectedIndex;
                      return ListTile(
                        leading: Icon(item.icon,
                            color: isSelected
                                ? Colors.white
                                : Colors.white54,
                            size: 20),
                        title: Text(item.label,
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                fontSize: 13)),
                        selected: isSelected,
                        selectedTileColor:
                            AppColors.primary.withValues(alpha: 0.2),
                        onTap: () {
                          setState(() => _selectedIndex = index);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.logout, color: Colors.white54),
                  title: const Text('Logout',
                      style: TextStyle(color: Colors.white70)),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/role-selection', (_) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem(this.icon, this.label);
}
