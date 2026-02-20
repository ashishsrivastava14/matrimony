import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_state.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // Period selection
  static const _periods = ['Last 7 Days', 'Last 30 Days', 'This Year'];
  String _selectedPeriod = 'Last 7 Days';

  // Chart datasets per period
  static const _chartData = {
    'Last 7 Days': [32, 45, 38, 52, 48, 60, 42],
    'Last 30 Days': [120, 145, 110, 160, 140, 180, 130, 155, 170, 190,
                     140, 165, 150, 175, 130, 145, 168, 200, 155, 140,
                     160, 175, 130, 145, 155, 170, 190, 210, 180, 165],
    'This Year': [420, 580, 510, 690, 720, 640, 780, 850, 760, 920, 880, 1050],
  };

  static const _chartLabels = {
    'Last 7 Days': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    'Last 30 Days': ['1','2','3','4','5','6','7','8','9','10',
                     '11','12','13','14','15','16','17','18','19','20',
                     '21','22','23','24','25','26','27','28','29','30'],
    'This Year': ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
  };

  // Metrics per period
  static const _metrics = {
    'Last 7 Days': {
      'newUsers': '42', 'newTrend': '+18%',
      'sessions': '1,245', 'sessionTrend': '+5%',
      'revenue': '₹28,500', 'revenueTrend': '+22%',
      'interests': '368', 'interestTrend': '+12%',
    },
    'Last 30 Days': {
      'newUsers': '1,280', 'newTrend': '+14%',
      'sessions': '38,400', 'sessionTrend': '+8%',
      'revenue': '₹8,40,000', 'revenueTrend': '+19%',
      'interests': '11,200', 'interestTrend': '+9%',
    },
    'This Year': {
      'newUsers': '14,360', 'newTrend': '+31%',
      'sessions': '4,20,000', 'sessionTrend': '+24%',
      'revenue': '₹1,02,00,000', 'revenueTrend': '+42%',
      'interests': '1,34,000', 'interestTrend': '+27%',
    },
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final m = _metrics[_selectedPeriod]!;
    final data = _chartData[_selectedPeriod]!;
    final labels = _chartLabels[_selectedPeriod]!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Flexible(
                  child: Text(l10n.reportsAnalytics,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 12),
                // Period selector
                SegmentedButton<String>(
                  segments: _periods
                      .map((p) => ButtonSegment(
                          value: p,
                          label: Text(
                            p == 'Last 7 Days'
                                ? '7D'
                                : p == 'Last 30 Days'
                                    ? '30D'
                                    : '1Y',
                            style: const TextStyle(fontSize: 12),
                          )))
                      .toList(),
                  selected: {_selectedPeriod},
                  onSelectionChanged: (s) =>
                      setState(() => _selectedPeriod = s.first),
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick metrics
            LayoutBuilder(builder: (context, constraints) {
              final cols = constraints.maxWidth > 600 ? 4 : 2;
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.0,
                children: [
                  _metricCard(l10n.newUsersToday, m['newUsers']!, m['newTrend']!, AppColors.primary, Icons.person_add),
                  _metricCard(l10n.activeSessions, m['sessions']!, m['sessionTrend']!, Colors.blue, Icons.devices),
                  _metricCard(l10n.revenueToday, m['revenue']!, m['revenueTrend']!, AppColors.success, Icons.currency_rupee),
                  _metricCard(l10n.interestsSent, m['interests']!, m['interestTrend']!, Colors.pink, Icons.favorite),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Registration chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(l10n.userRegistrations,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          _selectedPeriod,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${data.fold(0, (s, v) => s + v)} registrations',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: _BarChart(data: data, labels: labels),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Demographics row
            LayoutBuilder(builder: (ctx, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _genderCard(appState)),
                    const SizedBox(width: 16),
                    Expanded(child: _ageCard()),
                  ],
                );
              }
              return Column(children: [
                _genderCard(appState),
                const SizedBox(height: 16),
                _ageCard(),
              ]);
            }),
            const SizedBox(height: 16),

            // Top locations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Top Locations',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._topLocations.map((l) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 90,
                                child: Text(l.$1,
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: l.$2),
                                    duration: const Duration(milliseconds: 700),
                                    builder: (_, v, __) =>
                                        LinearProgressIndicator(
                                      value: v,
                                      minHeight: 10,
                                      backgroundColor: AppColors.divider,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              AppColors.primary),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('${(l.$2 * 100).toInt()}%',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subscription breakdown
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Subscription Breakdown',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._subscriptionData.map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Container(
                                width: 12, height: 12,
                                decoration: BoxDecoration(
                                    color: s.$3,
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(s.$1,
                                    style:
                                        const TextStyle(fontSize: 13)),
                              ),
                              Text('${s.$2}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                        )),
                ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Download reports
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.download, size: 18, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text('Download Reports',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                        'Exports will be sent to your admin email.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _downloadChip(context, 'User Report (${ _selectedPeriod})', Icons.people),
                        _downloadChip(context, 'Revenue Report ($_selectedPeriod)', Icons.currency_rupee),
                        _downloadChip(context, 'Mediator Report', Icons.support_agent),
                        _downloadChip(context, 'Subscription Report', Icons.card_membership),
                        _downloadChip(context, 'Full Analytics Export', Icons.analytics),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(
      String label, String value, String trend, Color color, IconData icon) {
    final isPositive = trend.startsWith('+');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.success : Colors.red)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(trend,
                      style: TextStyle(
                          fontSize: 10,
                          color: isPositive ? AppColors.success : Colors.red,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _genderCard(AppState appState) {
    final total = appState.allUsers.length;
    final male = total > 0
        ? (appState.allUsers.where((u) => u.role != 'admin').length * 0.58).toInt()
        : 0;
    final female = total - male;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender Distribution',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _genderStat('Male', '58%', Colors.blue, Icons.male),
                _genderStat('Female', '42%', Colors.pink, Icons.female),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    Flexible(
                      flex: 58,
                      child: Container(color: Colors.blue.withValues(alpha: 0.7)),
                    ),
                    Flexible(
                      flex: 42,
                      child: Container(color: Colors.pink.withValues(alpha: 0.7)),
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

  Widget _genderStat(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                Text(value,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _ageCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Age Distribution',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ageRow('18-25', 0.35, Colors.indigo),
            _ageRow('26-30', 0.45, AppColors.primary),
            _ageRow('31-35', 0.15, AppColors.accent),
            _ageRow('36+', 0.05, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _ageRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
              width: 42, child: Text(label, style: const TextStyle(fontSize: 12))),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: value),
                duration: const Duration(milliseconds: 600),
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  minHeight: 14,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(value * 100).toInt()}%',
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _downloadChip(BuildContext context, String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.download, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(child: Text('"$label" export started. You will receive it by email.')),
          ]),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ));
      },
    );
  }

  static const _topLocations = [
    ('Chennai', 0.35),
    ('Coimbatore', 0.22),
    ('Madurai', 0.18),
    ('Trichy', 0.12),
    ('Salem', 0.08),
    ('Tirunelveli', 0.05),
  ];

  static const _subscriptionData = [
    ('Free', 45, Colors.grey),
    ('Silver (Monthly)', 22, AppColors.accent),
    ('Gold (Quarterly)', 20, AppColors.primary),
    ('Diamond (Yearly)', 13, Colors.purple),
  ];
}

//  Bar chart widget 
class _BarChart extends StatelessWidget {
  final List<int> data;
  final List<String> labels;
  const _BarChart({required this.data, required this.labels});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    // Show at most 12 bars to keep it readable
    final showCount = data.length > 12 ? 12 : data.length;
    final step = (data.length / showCount).ceil();
    final displayData = [
      for (int i = 0; i < data.length; i += step) data[i]
    ];
    final displayLabels = [
      for (int i = 0; i < labels.length; i += step) labels[i]
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(displayData.length, (i) {
        final barH = 110.0 * (displayData[i] / maxVal);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${displayData[i]}',
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: barH),
                  duration: const Duration(milliseconds: 500),
                  builder: (_, h, __) => Container(
                    height: h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.55),
                        ],
                      ),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(displayLabels[i],
                    style: const TextStyle(
                        fontSize: 9, color: AppColors.textSecondary)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
