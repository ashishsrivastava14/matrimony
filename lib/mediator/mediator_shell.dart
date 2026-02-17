import 'package:flutter/material.dart';
import 'mediator_dashboard.dart';
import 'create_profile_screen.dart';
import 'commission_history_screen.dart';
import 'wallet_screen.dart';

class MediatorShell extends StatefulWidget {
  const MediatorShell({super.key});

  @override
  State<MediatorShell> createState() => _MediatorShellState();
}

class _MediatorShellState extends State<MediatorShell> {
  int _currentIndex = 0;

  final _screens = const [
    MediatorDashboard(),
    CreateProfileScreen(),
    CommissionHistoryScreen(),
    WalletScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_outlined),
            selectedIcon: Icon(Icons.person_add),
            label: 'Add Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Commission',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
        ],
      ),
    );
  }
}
