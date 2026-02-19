import 'package:flutter/material.dart';
import '../core/theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _faqs = [
    (
      q: 'How do I create my profile?',
      a:
          'Tap "Edit Profile" on the Profile page to complete your personal details, add photos, and set your partner preferences.'
    ),
    (
      q: 'How do I send an interest?',
      a:
          'Browse profiles on the Home screen and tap the heart icon, or open a profile and tap "Send Interest".'
    ),
    (
      q: 'How do I upgrade my subscription?',
      a:
          'Go to Profile → Subscription Plans to view available plans and upgrade to Premium.'
    ),
    (
      q: 'Why is my profile pending approval?',
      a:
          'All new profiles are reviewed by our team before going live. This usually takes 24–48 hours.'
    ),
    (
      q: 'How do I reset my password?',
      a:
          'On the login screen tap "Forgot Password" and follow the OTP verification steps.'
    ),
    (
      q: 'How do I delete my account?',
      a:
          'Please contact our support team via the form below or email us at support@matrimony.com and we will process your request within 7 days.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00897B),
                Color(0xFF26A69A),
                Color(0xFF00796B),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Help & Support'),
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact cards
          Row(
            children: [
              Expanded(
                child: _ContactCard(
                  icon: Icons.email_outlined,
                  label: 'Email Us',
                  value: 'support@matrimony.com',
                  onTap: () => _showSnack(context, 'Opening email client…'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ContactCard(
                  icon: Icons.chat_bubble_outline,
                  label: 'Live Chat',
                  value: 'Available 9 AM – 6 PM',
                  onTap: () => _showSnack(context, 'Live chat coming soon'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // FAQ section
          const _SectionHeader(title: 'Frequently Asked Questions'),
          ...HelpSupportScreen._faqs.map((faq) => _FaqTile(q: faq.q, a: faq.a)),

          const SizedBox(height: 20),

          // Support ticket form
          const _SectionHeader(title: 'Send Us a Message'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _SupportForm(),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

// ─── Contact card ────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── FAQ tile ─────────────────────────────────────────────────────────────────

class _FaqTile extends StatelessWidget {
  final String q;
  final String a;

  const _FaqTile({required this.q, required this.a});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 14),
        iconColor: AppColors.primary,
        title: Text(q,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14)),
        children: [
          Text(a,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}

// ─── Support form ─────────────────────────────────────────────────────────────

class _SupportForm extends StatefulWidget {
  @override
  State<_SupportForm> createState() => _SupportFormState();
}

class _SupportFormState extends State<_SupportForm> {
  final _formKey = GlobalKey<FormState>();
  String _subject = 'Account Issue';
  final _msgCtrl = TextEditingController();

  static const _subjects = [
    'Account Issue',
    'Profile Issue',
    'Payment / Subscription',
    'Inappropriate Content',
    'Technical Bug',
    'Other',
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _subject,
            decoration: const InputDecoration(labelText: 'Subject'),
            items: _subjects
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _subject = v!),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _msgCtrl,
            decoration: const InputDecoration(
              labelText: 'Describe your issue',
              alignLabelWithHint: true,
            ),
            maxLines: 4,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter a message' : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _msgCtrl.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Your message has been sent. We\'ll reply within 24 hours.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Submit',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
