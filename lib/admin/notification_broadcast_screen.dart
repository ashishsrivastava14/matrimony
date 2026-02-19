import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.notificationBroadcast,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Compose card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.composeNotification,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: l10n.title),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: l10n.message),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 14),

                    // Target audience
                    Text(l10n.targetAudience,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.allUsers),
                          selected: _target == 'all',
                          onSelected: (_) =>
                              setState(() => _target = 'all'),
                        ),
                        ChoiceChip(
                          label: Text(l10n.premium),
                          selected: _target == 'premium',
                          onSelected: (_) =>
                              setState(() => _target = 'premium'),
                        ),
                        ChoiceChip(
                          label: Text(l10n.freeUsers),
                          selected: _target == 'free',
                          onSelected: (_) =>
                              setState(() => _target = 'free'),
                        ),
                        ChoiceChip(
                          label: Text(l10n.mediator),
                          selected: _target == 'mediators',
                          onSelected: (_) =>
                              setState(() => _target = 'mediators'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Notification type
                    Text(l10n.notificationType,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
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
                          label: Text(l10n.email),
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
                                SnackBar(
                                    content: Text(l10n.scheduledForLater)),
                              );
                            },
                            child: Text(l10n.schedule),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(l10n.notificationSentSuccess),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            child: Text(l10n.sendNow),
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
            Text(l10n.recentBroadcasts,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      child: Builder(builder: (ctx) {
                        final l10n2 = AppLocalizations.of(ctx)!;
                        return Text(l10n2.sentStatus,
                            style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 11,
                                fontWeight: FontWeight.w500));
                      }),
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
