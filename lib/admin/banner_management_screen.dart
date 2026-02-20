import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

class _Banner {
  String title;
  String position;
  bool isActive;
  Color color;
  IconData icon;
  String linkUrl;

  _Banner({
    required this.title,
    required this.position,
    required this.isActive,
    required this.color,
    required this.icon,
    this.linkUrl = '',
  });
}

class BannerManagementScreen extends StatefulWidget {
  const BannerManagementScreen({super.key});

  @override
  State<BannerManagementScreen> createState() =>
      _BannerManagementScreenState();
}

class _BannerManagementScreenState
    extends State<BannerManagementScreen> {
  final List<_Banner> _banners = [
    _Banner(title: 'Premium Sale - 50% Off', position: 'Home', isActive: true, color: AppColors.primary, icon: Icons.local_offer),
    _Banner(title: 'Find Your Perfect Match', position: 'Login', isActive: true, color: AppColors.accent, icon: Icons.favorite),
    _Banner(title: 'New Feature: Horoscope Matching', position: 'Home', isActive: true, color: Colors.purple, icon: Icons.auto_awesome),
    _Banner(title: 'Refer & Earn', position: 'Profile', isActive: false, color: Colors.grey, icon: Icons.card_giftcard),
  ];

  static const _positions = ['Home', 'Search', 'Profile', 'Login'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header – Flexible prevents overflow
            Row(
              children: [
                Flexible(
                  child: Text(
                    l10n.bannerManagement,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () => _showBannerDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.addBanner),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Summary row
            Row(
              children: [
                _countChip('Total', _banners.length, AppColors.primary),
                const SizedBox(width: 8),
                _countChip('Active', _banners.where((b) => b.isActive).length, AppColors.success),
                const SizedBox(width: 8),
                _countChip('Inactive', _banners.where((b) => !b.isActive).length, Colors.grey),
              ],
            ),
            const SizedBox(height: 16),

            if (_banners.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No banners yet.',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              ..._banners.asMap().entries.map((entry) {
                final i = entry.key;
                final b = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Preview strip
                      Container(
                        height: 110,
                        width: double.infinity,
                        color: b.isActive
                            ? b.color
                            : b.color.withValues(alpha: 0.4),
                        child: Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(b.icon,
                                  color: Colors.white, size: 30),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                child: Text(
                                  b.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Action row – kept compact to avoid overflow
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${l10n.position}: ${b.position}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            // Status chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: b.isActive
                                    ? AppColors.success
                                        .withValues(alpha: 0.1)
                                    : Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                b.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: b.isActive
                                        ? AppColors.success
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Toggle switch
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: b.isActive,
                                onChanged: (v) {
                                  setState(() => b.isActive = v);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(v
                                        ? '"${b.title}" activated'
                                        : '"${b.title}" deactivated'),
                                    backgroundColor: v
                                        ? AppColors.success
                                        : Colors.orange,
                                    duration:
                                        const Duration(seconds: 2),
                                  ));
                                },
                                activeThumbColor: AppColors.primary,
                              ),
                            ),
                            // Edit
                            IconButton(
                              onPressed: () =>
                                  _showBannerDialog(context,
                                      index: i),
                              icon: const Icon(Icons.edit, size: 18),
                              tooltip: 'Edit',
                              visualDensity: VisualDensity.compact,
                            ),
                            // Delete
                            IconButton(
                              onPressed: () =>
                                  _confirmDelete(context, i),
                              icon: const Icon(Icons.delete,
                                  size: 18, color: Colors.red),
                              tooltip: 'Delete',
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _countChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text('$count',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  //  Add / Edit dialog 
  void _showBannerDialog(BuildContext context, {int? index}) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = index != null;
    final titleCtrl =
        TextEditingController(text: isEdit ? _banners[index].title : '');
    final urlCtrl =
        TextEditingController(text: isEdit ? _banners[index].linkUrl : '');
    String position = isEdit ? _banners[index].position : 'Home';
    bool isActive = isEdit ? _banners[index].isActive : true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) =>
          StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Banner' : l10n.addNewBanner),
          content: SizedBox(
            width: 380,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleCtrl,
                    decoration: InputDecoration(
                        labelText: l10n.bannerTitle,
                        prefixIcon: const Icon(Icons.title)),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: position,
                    decoration: InputDecoration(
                        labelText: l10n.position,
                        prefixIcon: const Icon(Icons.place)),
                    items: _positions
                        .map((e) => DropdownMenuItem(
                            value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) =>
                        setLocal(() => position = v ?? 'Home'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: urlCtrl,
                    decoration: InputDecoration(
                        labelText: l10n.linkUrl,
                        prefixIcon: const Icon(Icons.link)),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Active'),
                    value: isActive,
                    onChanged: (v) =>
                        setLocal(() => isActive = v),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                setState(() {
                  if (isEdit) {
                    _banners[index].title = titleCtrl.text.trim();
                    _banners[index].position = position;
                    _banners[index].linkUrl = urlCtrl.text.trim();
                    _banners[index].isActive = isActive;
                  } else {
                    _banners.add(_Banner(
                      title: titleCtrl.text.trim(),
                      position: position,
                      isActive: isActive,
                      color: AppColors.primary,
                      icon: Icons.image,
                      linkUrl: urlCtrl.text.trim(),
                    ));
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      isEdit ? 'Banner updated' : l10n.bannerAdded),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ));
              },
              child: Text(isEdit ? 'Update' : l10n.add),
            ),
          ],
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    final title = _banners[index].title;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Banner'),
        content:
            Text('Delete "$title"? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _banners.removeAt(index));
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                content: Text('"$title" deleted'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
