import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/plan_card.dart';
import '../services/mock_data.dart';
import '../models/subscription_plan.dart';
import '../widgets/user_bottom_navigation.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final plans = MockDataService.getMockPlans();
    final bundles = MockDataService.getMockBundles();

    return Scaffold(
      bottomNavigationBar: const UserBottomNavigation(),
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
        title: const Text('Subscription Plans'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Plans'),
            Tab(text: 'Pay Per Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Plans tab
          _buildPlansTab(appState, plans),
          // Pay per profile tab
          _buildBundlesTab(appState, bundles),
        ],
      ),
    );
  }

  Widget _buildPlansTab(AppState appState, List<SubscriptionPlan> plans) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current plan
          if (appState.currentPlan != null) ...[
            _buildCurrentPlanCard(appState),
            const SizedBox(height: 20),
          ],

          // Duration toggle
          const Text(
            'Choose Your Plan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Upgrade to unlock more features',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Plans list
          ...plans.map((plan) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PlanCard(
                  plan: plan,
                  isCurrentPlan:
                      appState.currentPlan?.name == plan.name,
                  onSubscribe: () => _showPaymentDialog(plan, appState),
                ),
              )),

          const SizedBox(height: 20),

          // Feature comparison
          _buildFeatureComparison(),
        ],
      ),
    );
  }

  Widget _buildBundlesTab(
      AppState appState, List<ProfileUnlockBundle> bundles) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unlock balance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.lock_open,
                        color: AppColors.accent, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Available Unlocks',
                          style: TextStyle(color: AppColors.textSecondary)),
                      Text(
                        '${appState.profileUnlocksRemaining}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Buy Profile Unlocks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'View contact details of profiles you are interested in',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),

          ...bundles.map((bundle) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: InkWell(
                    onTap: () => _showBundlePaymentDialog(bundle, appState),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${bundle.unlockCount}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${bundle.unlockCount} Profile Unlock${bundle.unlockCount > 1 ? "s" : ""}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '₹${(bundle.price / bundle.unlockCount).toStringAsFixed(0)} per profile',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${bundle.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanCard(AppState appState) {
    final plan = appState.currentPlan!;
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium,
                    color: Colors.white, size: 28),
                const SizedBox(width: 8),
                Text(plan.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Active',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${plan.contactViews} contact views remaining · ${plan.durationMonths} month duration',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureComparison() {
    final features = [
      ('Send Interest', '✓', '✓', '✓'),
      ('View Contact Details', '10', '25', 'Unlimited'),
      ('Chat with Matches', '✗', '✓', '✓'),
      ('Profile Highlight', '✗', '✓', '✓'),
      ('Priority Support', '✗', '✗', '✓'),
      ('Horoscope Matching', '✗', '✓', '✓'),
      ('Profile Boost', '✗', '✗', '✓'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feature Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.divider),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Feature',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Silver',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Gold',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Diamond',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ...features.map((f) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(f.$1, style: const TextStyle(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(f.$2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(f.$3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(f.$4,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13)),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(SubscriptionPlan plan, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Subscribe to ${plan.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${plan.price.toStringAsFixed(0)} for ${plan.durationMonths} month${plan.durationMonths > 1 ? "s" : ""}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Select Payment Method:'),
            const SizedBox(height: 8),
            RadioGroup<String>(
              groupValue: 'UPI',
              onChanged: (_) {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _paymentOption('UPI', Icons.account_balance),
                  _paymentOption('Credit / Debit Card', Icons.credit_card),
                  _paymentOption('Net Banking', Icons.language),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.subscribeToPlan(plan.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Subscribed to ${plan.name} successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  void _showBundlePaymentDialog(
      ProfileUnlockBundle bundle, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Buy ${bundle.unlockCount} Unlocks'),
        content: Text(
            'Pay ₹${bundle.price.toStringAsFixed(0)} for ${bundle.unlockCount} profile unlock${bundle.unlockCount > 1 ? "s" : ""}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.purchaseUnlockBundle(bundle.profileCount);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${bundle.unlockCount} unlocks added!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  Widget _paymentOption(String label, IconData icon) {
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: Radio<String>(value: label),
      contentPadding: EdgeInsets.zero,
    );
  }
}
