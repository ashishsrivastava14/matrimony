import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/stat_card.dart';
import '../services/mock_data.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = MockDataService.getMockProfiles();
    final stories = MockDataService.getSuccessStories();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back! Here\'s what\'s happening today.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            // Stats
            LayoutBuilder(builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 600
                      ? 2
                      : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: const [
                  StatCard(
                    title: 'Total Users',
                    value: '12,845',
                    icon: Icons.people,
                    color: AppColors.primary,
                    trend: '+12%',
                  ),
                  StatCard(
                    title: 'Active Profiles',
                    value: '8,432',
                    icon: Icons.person,
                    color: Colors.blue,
                    trend: '+8%',
                  ),
                  StatCard(
                    title: 'Revenue',
                    value: '₹4.5L',
                    icon: Icons.currency_rupee,
                    color: AppColors.success,
                    trend: '+15%',
                  ),
                  StatCard(
                    title: 'Mediators',
                    value: '156',
                    icon: Icons.support_agent,
                    color: Colors.purple,
                    trend: '+5%',
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Revenue chart placeholder
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Revenue Overview',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: 'This Month',
                          items: ['This Week', 'This Month', 'This Year']
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (_) {},
                          underline: const SizedBox(),
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: _MockBarChart(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Two column layout
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _recentRegistrations(profiles)),
                    const SizedBox(width: 16),
                    Expanded(child: _recentActivity()),
                  ],
                );
              }
              return Column(
                children: [
                  _recentRegistrations(profiles),
                  const SizedBox(height: 16),
                  _recentActivity(),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Success stories count
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Success Stories',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      '${stories.length} published success stories',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: stories.take(6).map((s) {
                        return Chip(
                          label: Text(s['couple'] ?? '',
                              style: const TextStyle(fontSize: 12)),
                          avatar: const Icon(Icons.favorite,
                              size: 16, color: Colors.pink),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentRegistrations(List profiles) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Registrations',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 8),
            ...profiles.take(5).map((p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                        p.photos.isNotEmpty
                            ? p.photos.first
                            : 'assets/images/profiles/profile_68.jpg'),
                    onBackgroundImageError: (_, _) {},
                  ),
                  title: Text(p.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  subtitle: Text('${p.age} yrs · ${p.city}',
                      style: const TextStyle(fontSize: 12)),
                  trailing: Text(
                    p.isVerified ? 'Verified' : 'Pending',
                    style: TextStyle(
                      fontSize: 12,
                      color: p.isVerified
                          ? AppColors.success
                          : AppColors.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _recentActivity() {
    final activities = [
      ('New registration: Priya S.', '2 min ago', Icons.person_add),
      ('Payment: Gold Plan - ₹3,999', '15 min ago', Icons.payment),
      ('Profile approved: Rajesh K.', '30 min ago', Icons.verified),
      ('Mediator payout: ₹2,000', '1 hr ago', Icons.money),
      ('Interest sent: MTH-45 → MTH-72', '2 hr ago', Icons.favorite),
      ('Report: Fake profile flagged', '3 hr ago', Icons.flag),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Activity',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...activities.map((a) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: Icon(a.$3, size: 20, color: AppColors.primary),
                  title: Text(a.$1, style: const TextStyle(fontSize: 13)),
                  trailing: Text(a.$2,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                )),
          ],
        ),
      ),
    );
  }
}

/// Simple mock bar chart using Container widgets
class _MockBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = [
      ('Jan', 0.4),
      ('Feb', 0.6),
      ('Mar', 0.55),
      ('Apr', 0.7),
      ('May', 0.8),
      ('Jun', 0.65),
      ('Jul', 0.9),
      ('Aug', 0.75),
      ('Sep', 0.85),
      ('Oct', 0.95),
      ('Nov', 0.7),
      ('Dec', 1.0),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.map((d) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 160 * d.$2,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.7),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(d.$1,
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.textSecondary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
