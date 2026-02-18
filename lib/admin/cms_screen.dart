import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/powered_by_footer.dart';

class CmsScreen extends StatefulWidget {
  const CmsScreen({super.key});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen>
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
    return Scaffold(
      bottomSheet: const PoweredByFooter(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Content Management',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddContentDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Page'),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Pages'),
              Tab(text: 'FAQs'),
              Tab(text: 'Success Stories'),
              Tab(text: 'Testimonials'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPages(),
                _buildFaqs(),
                _buildStories(),
                _buildTestimonials(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPages() {
    final pages = [
      {'title': 'About Us', 'status': 'Published', 'updated': '10 Jan 2025'},
      {'title': 'Privacy Policy', 'status': 'Published', 'updated': '05 Jan 2025'},
      {'title': 'Terms & Conditions', 'status': 'Published', 'updated': '05 Jan 2025'},
      {'title': 'How It Works', 'status': 'Published', 'updated': '01 Jan 2025'},
      {'title': 'Contact Us', 'status': 'Draft', 'updated': '28 Dec 2024'},
      {'title': 'Refund Policy', 'status': 'Published', 'updated': '20 Dec 2024'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final p = pages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.article, color: AppColors.primary),
            title: Text(p['title']!,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Updated: ${p['updated']}',
                style: const TextStyle(fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: p['status'] == 'Published'
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p['status']!,
                    style: TextStyle(
                      fontSize: 11,
                      color: p['status'] == 'Published'
                          ? AppColors.success
                          : AppColors.accent,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFaqs() {
    final faqs = [
      'How to create a profile?',
      'How to upgrade to premium?',
      'How does horoscope matching work?',
      'What is pay-per-profile?',
      'How to contact support?',
      'How to delete my account?',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text('${index + 1}',
                  style: const TextStyle(color: AppColors.primary)),
            ),
            title: Text(faqs[index],
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStories() {
    final stories = [
      {'couple': 'Karthick & Priya', 'date': 'Dec 2024', 'location': 'Chennai'},
      {'couple': 'Rajesh & Meena', 'date': 'Nov 2024', 'location': 'Coimbatore'},
      {'couple': 'Suresh & Divya', 'date': 'Oct 2024', 'location': 'Madurai'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final s = stories[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(Icons.favorite, color: Colors.white, size: 18),
            ),
            title: Text(s['couple']!,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('${s['location']} · ${s['date']}',
                style: const TextStyle(fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 18)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestimonials() {
    final testimonials = [
      {'name': 'Priya S.', 'rating': 5, 'text': 'Found my perfect match within 2 months!'},
      {'name': 'Karthick R.', 'rating': 4, 'text': 'Great platform with genuine profiles.'},
      {'name': 'Meena D.', 'rating': 5, 'text': 'Highly recommend for Tamil community.'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: testimonials.length,
      itemBuilder: (context, index) {
        final t = testimonials[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(child: Text(t['name'].toString()[0])),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t['name'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500)),
                          Row(
                            children: List.generate(
                                5,
                                (i) => Icon(
                                      Icons.star,
                                      size: 14,
                                      color: i < (t['rating'] as int)
                                          ? AppColors.accent
                                          : AppColors.divider,
                                    )),
                          ),
                        ],
                      ),
                    ),
                    Switch(value: true, onChanged: (_) {}),
                  ],
                ),
                const SizedBox(height: 8),
                Text(t['text'] as String,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddContentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Page'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(decoration: const InputDecoration(labelText: 'Page Title')),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
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
                    content: Text('Page created!'),
                    backgroundColor: AppColors.success),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
