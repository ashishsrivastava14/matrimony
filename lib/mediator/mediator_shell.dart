import 'package:flutter/material.dart';
import 'mediator_dashboard.dart';
import 'create_profile_screen.dart';
import 'commission_history_screen.dart';
import 'wallet_screen.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_add_outlined),
            selectedIcon: const Icon(Icons.person_add),
            label: l10n.addProfile,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.commission,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet),
            label: l10n.wallet,
          ),
        ],
      ),
    );
  }
}
