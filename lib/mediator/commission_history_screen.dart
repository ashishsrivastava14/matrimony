import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../widgets/powered_by_footer.dart';

class CommissionHistoryScreen extends StatefulWidget {
  const CommissionHistoryScreen({super.key});

  @override
  State<CommissionHistoryScreen> createState() =>
      _CommissionHistoryScreenState();
}

class _CommissionHistoryScreenState extends State<CommissionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        title: const Text('Commission History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Earned'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF004D40)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem('Total Earned', '₹15,000'),
                Container(
                    width: 1, height: 40, color: Colors.white24),
                _summaryItem('This Month', '₹4,000'),
                Container(
                    width: 1, height: 40, color: Colors.white24),
                _summaryItem('Pending', '₹2,000'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_allCommissions),
                _buildList(_allCommissions
                    .where((c) => c['status'] == 'Earned')
                    .toList()),
                _buildList(_allCommissions
                    .where((c) => c['status'] == 'Pending')
                    .toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildList(List<Map<String, String>> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No records found',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        final isEarned = item['status'] == 'Earned';
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isEarned
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.accent.withValues(alpha: 0.1),
            child: Icon(
              isEarned ? Icons.check_circle : Icons.schedule,
              color: isEarned ? AppColors.success : AppColors.accent,
              size: 20,
            ),
          ),
          title: Text(item['couple']!,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 14)),
          subtitle: Text(
            '${item['date']} · Match ID: ${item['matchId']}',
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['amount']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isEarned ? AppColors.success : AppColors.accent,
                ),
              ),
              Text(
                item['status']!,
                style: TextStyle(
                  fontSize: 11,
                  color: isEarned ? AppColors.success : AppColors.accent,
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  static final _allCommissions = [
    {
      'couple': 'Karthick & Priya',
      'amount': '₹2,000',
      'status': 'Earned',
      'date': '10 Jan 2025',
      'matchId': 'MTH-001',
    },
    {
      'couple': 'Rajesh & Meena',
      'amount': '₹2,000',
      'status': 'Earned',
      'date': '08 Jan 2025',
      'matchId': 'MTH-002',
    },
    {
      'couple': 'Suresh & Divya',
      'amount': '₹2,000',
      'status': 'Pending',
      'date': '05 Jan 2025',
      'matchId': 'MTH-003',
    },
    {
      'couple': 'Arun & Kavitha',
      'amount': '₹2,500',
      'status': 'Earned',
      'date': '28 Dec 2024',
      'matchId': 'MTH-004',
    },
    {
      'couple': 'Vijay & Lakshmi',
      'amount': '₹2,000',
      'status': 'Earned',
      'date': '20 Dec 2024',
      'matchId': 'MTH-005',
    },
    {
      'couple': 'Naveen & Sneha',
      'amount': '₹2,500',
      'status': 'Earned',
      'date': '15 Dec 2024',
      'matchId': 'MTH-006',
    },
    {
      'couple': 'Prakash & Ranjini',
      'amount': '₹2,000',
      'status': 'Pending',
      'date': '12 Dec 2024',
      'matchId': 'MTH-007',
    },
    {
      'couple': 'Manoj & Anitha',
      'amount': '₹2,000',
      'status': 'Earned',
      'date': '01 Dec 2024',
      'matchId': 'MTH-008',
    },
  ];
}
