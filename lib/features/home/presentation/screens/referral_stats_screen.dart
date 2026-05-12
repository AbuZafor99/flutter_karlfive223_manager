import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/home_repository.dart';
import '../../models/referral_stats_model.dart';

enum ReferralStatsFilter { daily, monthly }

class ReferralStatsPoint {
  final String label;
  final int value;

  const ReferralStatsPoint({required this.label, required this.value});
}

class ReferralStatsScreen extends StatefulWidget {
  final String referralId;
  final String referralName;
  final bool asPopup;

  const ReferralStatsScreen({
    super.key,
    required this.referralId,
    required this.referralName,
    this.asPopup = false,
  });

  @override
  State<ReferralStatsScreen> createState() => _ReferralStatsScreenState();
}

class _ReferralStatsScreenState extends State<ReferralStatsScreen> {
  late Future<ReferralStatsResponse> _statsFuture;
  ReferralStatsFilter _selectedFilter = ReferralStatsFilter.daily;

  @override
  void initState() {
    super.initState();
    _statsFuture = _fetchStats();
  }

  Future<ReferralStatsResponse> _fetchStats() async {
    final repository = Get.find<HomeRepository>();
    final result = await repository.getReferralStats(widget.referralId);
    return result.fold((failure) => throw Exception(failure.message), (
      success,
    ) {
      return success.data;
    });
  }

  List<ReferralStatsPoint> _buildPoints(List<ReferralDailyStat> dailyStats) {
    final sorted = [...dailyStats]..sort((a, b) => a.date.compareTo(b.date));

    if (_selectedFilter == ReferralStatsFilter.daily) {
      return sorted
          .map(
            (e) => ReferralStatsPoint(
              label: DateFormat('dd MMM').format(e.date),
              value: e.joinedCount,
            ),
          )
          .toList();
    }

    final Map<String, int> grouped = {};
    for (final stat in sorted) {
      final key = DateFormat('yyyy-MM').format(stat.date);
      grouped[key] = (grouped[key] ?? 0) + stat.joinedCount;
    }
    final keys = grouped.keys.toList()..sort();
    return keys.map((key) {
      final monthDate = DateTime.parse('$key-01');
      return ReferralStatsPoint(
        label: DateFormat('MMM yy').format(monthDate),
        value: grouped[key] ?? 0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asPopup) {
      final size = MediaQuery.of(context).size;
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          width: size.width,
          height: size.height * 0.8,
          decoration: BoxDecoration(
            color: AppColors.leagueBackgroundGrey,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 6, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${widget.referralName} Stats',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white12),
              Expanded(child: _buildStatsBody()),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.leagueBackgroundGrey,
        title: Text('${widget.referralName} Stats'),
      ),
      body: _buildStatsBody(),
    );
  }

  Widget _buildStatsBody() {
    return FutureBuilder<ReferralStatsResponse>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load stats. Please try again.',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final response = snapshot.data;
        if (response == null) {
          return const Center(
            child: Text(
              'No statistics found.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final points = _buildPoints(response.dailyStats);
        final total = points.fold<int>(0, (sum, item) => sum + item.value);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF202020),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response.referralPerson.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Total invited: ${response.referralPerson.joinedCount}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('Daily', ReferralStatsFilter.daily),
                  _buildFilterChip('Monthly', ReferralStatsFilter.monthly),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: points.isEmpty
                    ? const Center(
                        child: Text(
                          'No data for selected filter',
                          style: TextStyle(color: Colors.white60),
                        ),
                      )
                    : _ReferralStatsChart(points: points),
              ),
              const SizedBox(height: 16),
              Text(
                'Period total: $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ...points.map(
                (point) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          point.label,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        point.value.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String title, ReferralStatsFilter filter) {
    final isSelected = _selectedFilter == filter;
    return ChoiceChip(
      label: Text(title),
      selected: isSelected,
      labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white70),
      selectedColor: AppColors.primaryGreen,
      backgroundColor: const Color(0xFF2B2B2B),
      side: const BorderSide(color: Colors.transparent),
      onSelected: (_) {
        setState(() {
          _selectedFilter = filter;
        });
      },
    );
  }
}

class _ReferralStatsChart extends StatelessWidget {
  final List<ReferralStatsPoint> points;

  const _ReferralStatsChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ReferralStatsChartPainter(points),
        );
      },
    );
  }
}

class _ReferralStatsChartPainter extends CustomPainter {
  final List<ReferralStatsPoint> points;

  _ReferralStatsChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = 20.0;
    final rightPad = 10.0;
    final topPad = 10.0;
    final bottomPad = 32.0;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final gridPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = topPad + (chartHeight * i / 4);
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );
    }

    final maxValue = math.max(1, points.map((e) => e.value).reduce(math.max));
    final stepX = points.length > 1 ? chartWidth / (points.length - 1) : 0.0;

    final linePath = Path();
    final pointOffsets = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final x = leftPad + (stepX * i);
      final y =
          topPad + chartHeight - ((points[i].value / maxValue) * chartHeight);
      final offset = Offset(x, y);
      pointOffsets.add(offset);
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = Colors.redAccent;
    for (final point in pointOffsets) {
      canvas.drawCircle(point, 3.5, dotPaint);
    }

    final labelPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    for (int i = 0; i < points.length; i++) {
      final x = leftPad + (stepX * i);
      final label = points[i].label;
      final shortLabel = label.length > 7 ? label.substring(0, 7) : label;

      labelPainter.text = TextSpan(
        text: shortLabel,
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      );
      labelPainter.layout(minWidth: 0, maxWidth: 50);
      labelPainter.paint(
        canvas,
        Offset(x - (labelPainter.width / 2), size.height - bottomPad + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ReferralStatsChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
