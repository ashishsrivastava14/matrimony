import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import '../widgets/powered_by_footer.dart';
import '../widgets/user_bottom_navigation.dart';

class InterestManagementScreen extends StatefulWidget {
  const InterestManagementScreen({super.key});

  @override
  State<InterestManagementScreen> createState() =>
      _InterestManagementScreenState();
}

class _InterestManagementScreenState extends State<InterestManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final profiles = MockDataService.getMockProfiles();

    return Scaffold(
      bottomSheet: const PoweredByFooter(),
      bottomNavigationBar: const UserBottomNavigation(),
      appBar: AppBar(
        title: const Text('Interest Management'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(
                text:
                    'Received (${appState.interestsReceived.length})'),
            Tab(text: 'Sent (${appState.interestsSent.length})'),
            Tab(
                text:
                    'Accepted (${appState.interestsAccepted.length})'),
            Tab(
                text:
                    'Declined (${appState.interestsDeclined.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Received
          _buildInterestList(
            profileIds: appState.interestsReceived,
            profiles: profiles,
            type: 'received',
            appState: appState,
          ),
          // Sent
          _buildInterestList(
            profileIds: appState.interestsSent,
            profiles: profiles,
            type: 'sent',
            appState: appState,
          ),
          // Accepted
          _buildInterestList(
            profileIds: appState.interestsAccepted,
            profiles: profiles,
            type: 'accepted',
            appState: appState,
          ),
          // Declined
          _buildInterestList(
            profileIds: appState.interestsDeclined,
            profiles: profiles,
            type: 'declined',
            appState: appState,
          ),
        ],
      ),
    );
  }

  Widget _buildInterestList({
    required Set<String> profileIds,
    required List profiles,
    required String type,
    required AppState appState,
  }) {
    if (profileIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_emptyIcon(type), size: 64, color: AppColors.divider),
            const SizedBox(height: 12),
            Text(
              _emptyMessage(type),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final matchedProfiles =
        profiles.where((p) => profileIds.contains(p.id)).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: matchedProfiles.length,
      itemBuilder: (context, index) {
        final profile = matchedProfiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(profile.photos.isNotEmpty
                      ? profile.photos.first
                      : 'assets/images/profiles/profile_68.jpg'),
                  onBackgroundImageError: (_, _) {},
                  child: profile.photos.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              profile.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profile.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified,
                                color: AppColors.verified, size: 16),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.age} yrs, ${profile.height} · ${profile.education}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${profile.city}, ${profile.state}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                // Actions
                if (type == 'received') ...[
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          appState.acceptInterest(profile.id);
                        },
                        icon: const Icon(Icons.check_circle,
                            color: AppColors.success),
                        tooltip: 'Accept',
                      ),
                      IconButton(
                        onPressed: () {
                          appState.declineInterest(profile.id);
                        },
                        icon: const Icon(Icons.cancel,
                            color: Colors.red),
                        tooltip: 'Decline',
                      ),
                    ],
                  ),
                ] else if (type == 'sent') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Pending',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ] else if (type == 'accepted') ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                    icon: const Icon(Icons.chat, size: 16),
                    label: const Text('Chat'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Declined',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _emptyIcon(String type) {
    switch (type) {
      case 'received':
        return Icons.favorite_border;
      case 'sent':
        return Icons.send;
      case 'accepted':
        return Icons.handshake;
      case 'declined':
        return Icons.cancel_outlined;
      default:
        return Icons.list;
    }
  }

  String _emptyMessage(String type) {
    switch (type) {
      case 'received':
        return 'No interests received yet';
      case 'sent':
        return 'No interests sent yet';
      case 'accepted':
        return 'No accepted interests';
      case 'declined':
        return 'No declined interests';
      default:
        return 'No data';
    }
  }
}
