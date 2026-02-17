import 'package:flutter/material.dart';
import '../core/theme.dart';

class BannerManagementScreen extends StatelessWidget {
  const BannerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Banner Management',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddBannerDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Banner'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Active banners
            ..._banners.map((b) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        color: b['color'] as Color,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(b['icon'] as IconData,
                                  color: Colors.white, size: 32),
                              const SizedBox(height: 4),
                              Text(
                                b['title'] as String,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(b['title'] as String,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    'Position: ${b['position']} · ${b['status']}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: b['status'] == 'Active',
                              onChanged: (_) {},
                              activeColor: AppColors.primary,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, size: 18),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete,
                                  size: 18, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showAddBannerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Banner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                decoration: const InputDecoration(labelText: 'Banner Title')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: 'Home',
              decoration: const InputDecoration(labelText: 'Position'),
              items: ['Home', 'Search', 'Profile', 'Login']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),
            TextFormField(
                decoration: const InputDecoration(labelText: 'Link URL')),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload),
              label: const Text('Upload Image'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Banner added!'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  static final _banners = [
    {
      'title': 'Premium Sale - 50% Off',
      'position': 'Home',
      'status': 'Active',
      'color': AppColors.primary,
      'icon': Icons.local_offer,
    },
    {
      'title': 'Find Your Perfect Match',
      'position': 'Login',
      'status': 'Active',
      'color': AppColors.accent,
      'icon': Icons.favorite,
    },
    {
      'title': 'New Feature: Horoscope Matching',
      'position': 'Home',
      'status': 'Active',
      'color': Colors.purple,
      'icon': Icons.auto_awesome,
    },
    {
      'title': 'Refer & Earn',
      'position': 'Profile',
      'status': 'Inactive',
      'color': Colors.grey,
      'icon': Icons.card_giftcard,
    },
  ];
}
