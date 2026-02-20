import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';

//  Local data models 
class _CmsPage {
  String title;
  String content;
  String status; // 'Published' | 'Draft'
  String updated;
  _CmsPage({required this.title, required this.content, required this.status, required this.updated});
}

class _CmsFaq {
  String question;
  String answer;
  _CmsFaq({required this.question, required this.answer});
}

class _CmsStory {
  String couple;
  String location;
  String date;
  String description;
  _CmsStory({required this.couple, required this.location, required this.date, required this.description});
}

class _CmsTestimonial {
  String name;
  int rating;
  String text;
  bool enabled;
  _CmsTestimonial({required this.name, required this.rating, required this.text, this.enabled = true});
}

//  Screen 
class CmsScreen extends StatefulWidget {
  const CmsScreen({super.key});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Pages
  final List<_CmsPage> _pages = [
    _CmsPage(title: 'About Us', content: 'About our matrimony platform...', status: 'Published', updated: '10 Jan 2025'),
    _CmsPage(title: 'Privacy Policy', content: 'Your privacy matters...', status: 'Published', updated: '05 Jan 2025'),
    _CmsPage(title: 'Terms & Conditions', content: 'By using this app...', status: 'Published', updated: '05 Jan 2025'),
    _CmsPage(title: 'How It Works', content: 'Create profile, search, connect...', status: 'Published', updated: '01 Jan 2025'),
    _CmsPage(title: 'Contact Us', content: 'Reach us at support@matrimony.com', status: 'Draft', updated: '28 Dec 2024'),
    _CmsPage(title: 'Refund Policy', content: 'Refunds are processed within 7 days...', status: 'Published', updated: '20 Dec 2024'),
  ];

  // FAQs
  final List<_CmsFaq> _faqs = [
    _CmsFaq(question: 'How to create a profile?', answer: 'Tap the Register button, fill in your details and upload a photo.'),
    _CmsFaq(question: 'How to upgrade to premium?', answer: 'Go to Subscriptions in the menu and choose a plan that suits you.'),
    _CmsFaq(question: 'How does horoscope matching work?', answer: 'We use Ashtakoot matching based on your birth details.'),
    _CmsFaq(question: 'What is pay-per-profile?', answer: 'You can unlock individual profiles without a full subscription.'),
    _CmsFaq(question: 'How to contact support?', answer: 'Email us at support@matrimony.com or use in-app chat.'),
    _CmsFaq(question: 'How to delete my account?', answer: 'Go to Profile > Settings > Delete Account.'),
  ];

  // Success Stories
  final List<_CmsStory> _stories = [
    _CmsStory(couple: 'Karthick & Priya', location: 'Chennai', date: 'Dec 2024', description: 'We found each other on this app and got married within 6 months!'),
    _CmsStory(couple: 'Rajesh & Meena', location: 'Coimbatore', date: 'Nov 2024', description: 'Truly a life-changing experience. Thank you for bringing us together.'),
    _CmsStory(couple: 'Suresh & Divya', location: 'Madurai', date: 'Oct 2024', description: 'The horoscope matching feature helped us a lot.'),
  ];

  // Testimonials
  final List<_CmsTestimonial> _testimonials = [
    _CmsTestimonial(name: 'Priya S.', rating: 5, text: 'Found my perfect match within 2 months!', enabled: true),
    _CmsTestimonial(name: 'Karthick R.', rating: 4, text: 'Great platform with genuine profiles.', enabled: true),
    _CmsTestimonial(name: 'Meena D.', rating: 5, text: 'Highly recommend for Tamil community.', enabled: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _today() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tabIdx = _tabController.index;

    // Add button label per tab
    final addLabels = [l10n.addPage, 'Add FAQ', 'Add Story', 'Add Testimonial'];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Flexible(
                  child: Text(l10n.contentManagement,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _onAddTapped,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(addLabels[tabIdx]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: '${l10n.pages} (${_pages.length})'),
              Tab(text: 'FAQs (${_faqs.length})'),
              Tab(text: '${l10n.successStories} (${_stories.length})'),
              Tab(text: '${l10n.testimonials} (${_testimonials.length})'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPages(l10n),
                _buildFaqs(l10n),
                _buildStories(l10n),
                _buildTestimonials(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onAddTapped() {
    switch (_tabController.index) {
      case 0: _showPageDialog(); break;
      case 1: _showFaqDialog(); break;
      case 2: _showStoryDialog(); break;
      case 3: _showTestimonialDialog(); break;
    }
  }

  // 
  // PAGES TAB
  // 
  Widget _buildPages(AppLocalizations l10n) {
    if (_pages.isEmpty) {
      return const Center(child: Text('No pages yet.', style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _pages.length,
      itemBuilder: (context, i) {
        final p = _pages[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.article, color: AppColors.primary),
            title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Updated: ${p.updated}', style: const TextStyle(fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusChip(p.status == 'Published'),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') _showPageDialog(index: i);
                    if (v == 'toggle') {
                      setState(() => p.status = p.status == 'Published' ? 'Draft' : 'Published');
                      _snack(context, p.status == 'Published' ? 'Page published' : 'Page moved to draft', AppColors.success);
                    }
                    if (v == 'delete') _confirmDelete(context, 'page "${p.title}"', () => setState(() => _pages.removeAt(i)));
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: _MenuRow(Icons.edit, 'Edit')),
                    PopupMenuItem(
                      value: 'toggle',
                      child: _MenuRow(
                        p.status == 'Published' ? Icons.unpublished : Icons.publish,
                        p.status == 'Published' ? 'Move to Draft' : 'Publish',
                        color: p.status == 'Published' ? Colors.orange : AppColors.success,
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: 'delete', child: _MenuRow(Icons.delete_forever, 'Delete', color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPageDialog({int? index}) {
    final isEdit = index != null;
    final titleCtrl = TextEditingController(text: isEdit ? _pages[index].title : '');
    final contentCtrl = TextEditingController(text: isEdit ? _pages[index].content : '');
    String status = isEdit ? _pages[index].status : 'Draft';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Page' : 'Add New Page'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Page Title', prefixIcon: Icon(Icons.title)),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: contentCtrl,
                    decoration: const InputDecoration(labelText: 'Content', prefixIcon: Icon(Icons.text_fields), alignLabelWithHint: true),
                    maxLines: 5,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status', prefixIcon: Icon(Icons.flag)),
                    items: const [
                      DropdownMenuItem(value: 'Published', child: Text('Published')),
                      DropdownMenuItem(value: 'Draft', child: Text('Draft')),
                    ],
                    onChanged: (v) => setLocal(() => status = v ?? 'Draft'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                setState(() {
                  if (isEdit) {
                    _pages[index].title = titleCtrl.text.trim();
                    _pages[index].content = contentCtrl.text.trim();
                    _pages[index].status = status;
                    _pages[index].updated = _today();
                  } else {
                    _pages.add(_CmsPage(title: titleCtrl.text.trim(), content: contentCtrl.text.trim(), status: status, updated: _today()));
                  }
                });
                Navigator.pop(ctx);
                _snack(context, isEdit ? 'Page updated' : 'Page created', AppColors.success);
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        );
      }),
    );
  }

  // 
  // FAQs TAB
  // 
  Widget _buildFaqs(AppLocalizations l10n) {
    if (_faqs.isEmpty) {
      return const Center(child: Text('No FAQs yet.', style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _faqs.length,
      itemBuilder: (context, i) {
        final f = _faqs[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text('${i + 1}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            title: Text(f.question, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: AppColors.primary),
                  tooltip: 'Edit',
                  onPressed: () => _showFaqDialog(index: i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context, 'this FAQ', () => setState(() => _faqs.removeAt(i))),
                ),
                const Icon(Icons.expand_more), // expansion indicator
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(f.answer, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFaqDialog({int? index}) {
    final isEdit = index != null;
    final qCtrl = TextEditingController(text: isEdit ? _faqs[index].question : '');
    final aCtrl = TextEditingController(text: isEdit ? _faqs[index].answer : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit FAQ' : 'Add New FAQ'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: qCtrl,
                  decoration: const InputDecoration(labelText: 'Question', prefixIcon: Icon(Icons.help_outline)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: aCtrl,
                  decoration: const InputDecoration(labelText: 'Answer', prefixIcon: Icon(Icons.chat_bubble_outline), alignLabelWithHint: true),
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                if (isEdit) {
                  _faqs[index].question = qCtrl.text.trim();
                  _faqs[index].answer = aCtrl.text.trim();
                } else {
                  _faqs.add(_CmsFaq(question: qCtrl.text.trim(), answer: aCtrl.text.trim()));
                }
              });
              Navigator.pop(ctx);
              _snack(context, isEdit ? 'FAQ updated' : 'FAQ added', AppColors.success);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  // 
  // SUCCESS STORIES TAB
  // 
  Widget _buildStories(AppLocalizations l10n) {
    if (_stories.isEmpty) {
      return const Center(child: Text('No success stories yet.', style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _stories.length,
      itemBuilder: (context, i) {
        final s = _stories[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: Icon(Icons.favorite, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.couple, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${s.location}  ${s.date}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(s.description, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') _showStoryDialog(index: i);
                    if (v == 'delete') _confirmDelete(context, '"${s.couple}"', () => setState(() => _stories.removeAt(i)));
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: _MenuRow(Icons.edit, 'Edit')),
                    PopupMenuDivider(),
                    PopupMenuItem(value: 'delete', child: _MenuRow(Icons.delete_forever, 'Delete', color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStoryDialog({int? index}) {
    final isEdit = index != null;
    final coupleCtrl = TextEditingController(text: isEdit ? _stories[index].couple : '');
    final locationCtrl = TextEditingController(text: isEdit ? _stories[index].location : '');
    final dateCtrl = TextEditingController(text: isEdit ? _stories[index].date : '');
    final descCtrl = TextEditingController(text: isEdit ? _stories[index].description : '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit Success Story' : 'Add Success Story'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: coupleCtrl,
                  decoration: const InputDecoration(labelText: 'Couple Name', prefixIcon: Icon(Icons.favorite)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: locationCtrl,
                        decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on)),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: dateCtrl,
                        decoration: const InputDecoration(labelText: 'Month & Year', prefixIcon: Icon(Icons.calendar_today)),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Story Description', prefixIcon: Icon(Icons.edit_note), alignLabelWithHint: true),
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                if (isEdit) {
                  _stories[index].couple = coupleCtrl.text.trim();
                  _stories[index].location = locationCtrl.text.trim();
                  _stories[index].date = dateCtrl.text.trim();
                  _stories[index].description = descCtrl.text.trim();
                } else {
                  _stories.add(_CmsStory(
                    couple: coupleCtrl.text.trim(),
                    location: locationCtrl.text.trim(),
                    date: dateCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                  ));
                }
              });
              Navigator.pop(ctx);
              _snack(context, isEdit ? 'Story updated' : 'Story added', AppColors.success);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  // 
  // TESTIMONIALS TAB
  // 
  Widget _buildTestimonials(AppLocalizations l10n) {
    if (_testimonials.isEmpty) {
      return const Center(child: Text('No testimonials yet.', style: TextStyle(color: AppColors.textSecondary)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _testimonials.length,
      itemBuilder: (context, i) {
        final t = _testimonials[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(child: Text(t.name[0])),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      Row(
                        children: List.generate(5, (s) => Icon(
                          Icons.star, size: 14,
                          color: s < t.rating ? AppColors.accent : AppColors.divider,
                        )),
                      ),
                      const SizedBox(height: 4),
                      Text(t.text, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Switch(
                      value: t.enabled,
                      onChanged: (v) {
                        setState(() => t.enabled = v);
                        _snack(context, v ? 'Testimonial enabled' : 'Testimonial disabled',
                            v ? AppColors.success : Colors.orange);
                      },
                    ),
                    const Text('Visible', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') _showTestimonialDialog(index: i);
                    if (v == 'delete') _confirmDelete(context, '"${t.name}"', () => setState(() => _testimonials.removeAt(i)));
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: _MenuRow(Icons.edit, 'Edit')),
                    PopupMenuDivider(),
                    PopupMenuItem(value: 'delete', child: _MenuRow(Icons.delete_forever, 'Delete', color: Colors.red)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTestimonialDialog({int? index}) {
    final isEdit = index != null;
    final nameCtrl = TextEditingController(text: isEdit ? _testimonials[index].name : '');
    final textCtrl = TextEditingController(text: isEdit ? _testimonials[index].text : '');
    int rating = isEdit ? _testimonials[index].rating : 5;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setLocal) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Testimonial' : 'Add Testimonial'),
          content: SizedBox(
            width: 380,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: textCtrl,
                    decoration: const InputDecoration(labelText: 'Testimonial', prefixIcon: Icon(Icons.format_quote), alignLabelWithHint: true),
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Rating:', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      ...List.generate(5, (s) => GestureDetector(
                        onTap: () => setLocal(() => rating = s + 1),
                        child: Icon(Icons.star, size: 28,
                            color: s < rating ? AppColors.accent : AppColors.divider),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                setState(() {
                  if (isEdit) {
                    _testimonials[index].name = nameCtrl.text.trim();
                    _testimonials[index].text = textCtrl.text.trim();
                    _testimonials[index].rating = rating;
                  } else {
                    _testimonials.add(_CmsTestimonial(
                      name: nameCtrl.text.trim(),
                      text: textCtrl.text.trim(),
                      rating: rating,
                    ));
                  }
                });
                Navigator.pop(ctx);
                _snack(context, isEdit ? 'Testimonial updated' : 'Testimonial added', AppColors.success);
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        );
      }),
    );
  }

  //  Shared helpers 
  void _confirmDelete(BuildContext context, String label, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete $label? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
              _snack(context, 'Deleted successfully', Colors.red);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    ));
  }
}

//  Helper widgets 
class _StatusChip extends StatelessWidget {
  final bool published;
  const _StatusChip(this.published);

  @override
  Widget build(BuildContext context) {
    final color = published ? AppColors.success : AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        published ? 'Published' : 'Draft',
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _MenuRow(this.icon, this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.black87;
    return Row(children: [
      Icon(icon, size: 18, color: c),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(color: c)),
    ]);
  }
}
