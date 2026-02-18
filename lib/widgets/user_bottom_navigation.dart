import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../core/theme.dart';

/// Reusable bottom navigation bar for user screens
/// Shows Home, Search, Matches, Chat, and Profile tabs
class UserBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  
  const UserBottomNavigation({
    super.key,
    this.currentIndex = -1, // -1 means no tab is selected (for detail pages)
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex >= 0 && currentIndex < 5 ? currentIndex : 0,
        onTap: (index) => _handleNavigation(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Consumer<ChatProvider>(
              builder: (_, chat, child) {
                final unread = chat.conversations
                    .fold<int>(0, (s, c) => s + c.unreadCount);
                if (unread > 0) {
                  return Badge(
                    label: Text('$unread'),
                    child: child!,
                  );
                }
                return child!;
              },
              child: const Icon(Icons.chat_bubble_outline),
            ),
            activeIcon: const Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // If a custom onTap is provided (from UserShell), use it
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Otherwise, navigate to user shell with the selected index
    // This is for detail pages that need to return to the main shell
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/user',
      (route) => false,
      arguments: index,
    );
  }
}
