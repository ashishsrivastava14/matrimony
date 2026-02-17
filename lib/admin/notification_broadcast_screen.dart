import 'package:flutter/material.dart';
import '../core/theme.dart';

class NotificationBroadcastScreen extends StatefulWidget {
  const NotificationBroadcastScreen({super.key});

  @override
  State<NotificationBroadcastScreen> createState() =>
      _NotificationBroadcastScreenState();
}

class _NotificationBroadcastScreenState
    extends State<NotificationBroadcastScreen> {
  String _target = 'all';
  String _type = 'push';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notification Broadcast',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Compose card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Compose Notification',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Message'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 14),

                    // Target audience
                    const Text('Target Audience',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All Users'),
                          selected: _target == 'all',
                          onSelected: (_) =>
                              setState(() => _target = 'all'),
                        ),
                        ChoiceChip(
                          label: const Text('Premium'),
                          selected: _target == 'premium',
                          onSelected: (_) =>
                              setState(() => _target = 'premium'),
                        ),
                        ChoiceChip(
                          label: const Text('Free Users'),
                          selected: _target == 'free',
                          onSelected: (_) =>
                              setState(() => _target = 'free'),
                        ),
                        ChoiceChip(
                          label: const Text('Mediators'),
                          selected: _target == 'mediators',
                          onSelected: (_) =>
                              setState(() => _target = 'mediators'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Notification type
                    const Text('Notification Type',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Push'),
                          selected: _type == 'push',
                          onSelected: (_) =>
                              setState(() => _type = 'push'),
                        ),
                        ChoiceChip(
                          label: const Text('In-App'),
                          selected: _type == 'inapp',
                          onSelected: (_) =>
                              setState(() => _type = 'inapp'),
                        ),
                        ChoiceChip(
                          label: const Text('Email'),
                          selected: _type == 'email',
                          onSelected: (_) =>
                              setState(() => _type = 'email'),
                        ),
                        ChoiceChip(
                          label: const Text('SMS'),
                          selected: _type == 'sms',
                          onSelected: (_) =>
                              setState(() => _type = 'sms'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Scheduled for later')),
                              );
                            },
                            child: const Text('Schedule'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Notification sent to all users!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            child: const Text('Send Now'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // History
            const Text('Recent Broadcasts',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._recentBroadcasts.map((b) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        b['type'] == 'push'
                            ? Icons.notifications
                            : b['type'] == 'email'
                                ? Icons.email
                                : Icons.sms,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(b['title']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                    subtitle: Text(
                      '${b['target']} · ${b['date']} · ${b['sent']} delivered',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Sent',
                          style: TextStyle(
                              color: AppColors.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  static const _recentBroadcasts = [
    {
      'title': 'New Year Offer - 50% Off',
      'type': 'push',
      'target': 'All Users',
      'date': '01 Jan 2025',
      'sent': '12,845',
    },
    {
      'title': 'Profile Completion Reminder',
      'type': 'push',
      'target': 'Free Users',
      'date': '28 Dec 2024',
      'sent': '8,432',
    },
    {
      'title': 'Commission Update',
      'type': 'email',
      'target': 'Mediators',
      'date': '25 Dec 2024',
      'sent': '156',
    },
    {
      'title': 'Holiday Greetings',
      'type': 'push',
      'target': 'All Users',
      'date': '25 Dec 2024',
      'sent': '12,845',
    },
  ];
}
