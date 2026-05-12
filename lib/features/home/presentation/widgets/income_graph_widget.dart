import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../controller/home_controller.dart';
import '../../models/payment_income_model.dart';

enum IncomeGraphFilter { monthly, daily }

class _IncomePoint {
  final String label;
  final double value;

  const _IncomePoint({required this.label, required this.value});
}

class IncomeGraphWidget extends StatefulWidget {
  const IncomeGraphWidget({super.key});

  @override
  State<IncomeGraphWidget> createState() => _IncomeGraphWidgetState();
}

class _IncomeGraphWidgetState extends State<IncomeGraphWidget> {
  IncomeGraphFilter selectedFilter = IncomeGraphFilter.daily;

  List<_IncomePoint> _pointsFromData(PaymentIncomeResponse data) {
    if (selectedFilter == IncomeGraphFilter.monthly) {
      final months = [...data.monthWise]
        ..sort((a, b) => a.monthDate.compareTo(b.monthDate));
      return months
          .map(
            (m) => _IncomePoint(
              label: DateFormat('MMM').format(m.monthDate).toUpperCase(),
              value: m.income,
            ),
          )
          .toList();
    }

    final days = [...data.dayWise]..sort((a, b) => a.day.compareTo(b.day));
    return days
        .map(
          (d) => _IncomePoint(
            label: DateFormat('dd MMM').format(d.day).toUpperCase(),
            value: d.income,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final incomeData = controller.incomeData.value;
      if (incomeData == null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Income Graph',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'No income data available',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        );
      }

      final points = _pointsFromData(incomeData);
      final screenWidth = MediaQuery.of(context).size.width;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 350 ? 12 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Income Graph',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111316),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white10),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _buildFilterButton('MONTHLY', IncomeGraphFilter.monthly),
                      _buildFilterButton('DAILY', IncomeGraphFilter.daily),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: const Color(0xFF0F1216),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF141A12), Color(0xFF0D1110)],
                      ),
                    ),
                    child: points.isEmpty
                        ? const Center(
                            child: Text(
                              'No income data found',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : CustomPaint(
                            painter: _IncomeGraphPainter(points: points),
                            child: const SizedBox.expand(),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total: ${incomeData.summary.totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: ui.Color.fromARGB(255, 15, 128, 45),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterButton(String text, IncomeGraphFilter filter) {
    final isSelected = selectedFilter == filter;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? const ui.Color.fromARGB(255, 37, 214, 46)
              : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF111111) : const ui.Color.fromARGB(179, 234, 231, 231),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _IncomeGraphPainter extends CustomPainter {
  final List<_IncomePoint> points;

  _IncomeGraphPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final left = 14.0;
    final right = 12.0;
    final top = 16.0;
    final bottom = 42.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = top + (chartHeight * i / 4);
      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );
    }

    final maxValue = math.max(
      1.0,
      points.map((e) => e.value).fold<double>(0.0, math.max),
    );
    final minValue = points
        .map((e) => e.value)
        .fold<double>(maxValue, math.min);
    final range = math.max(1.0, maxValue - minValue);

    final stepX = points.length > 1
        ? chartWidth / (points.length - 1)
        : chartWidth;
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = left + i * stepX;
      final normalized = (points[i].value - minValue) / range;
      final y =
          top +
          chartHeight -
          (normalized * chartHeight * 0.85) -
          (chartHeight * 0.07);
      offsets.add(Offset(x, y));
    }

    final linePath = Path();
    if (offsets.isNotEmpty) {
      linePath.moveTo(offsets.first.dx, offsets.first.dy);
      for (int i = 1; i < offsets.length; i++) {
        final prev = offsets[i - 1];
        final current = offsets[i];
        final cp1 = Offset((prev.dx + current.dx) / 2, prev.dy);
        final cp2 = Offset((prev.dx + current.dx) / 2, current.dy);
        linePath.cubicTo(
          cp1.dx,
          cp1.dy,
          cp2.dx,
          cp2.dy,
          current.dx,
          current.dy,
        );
      }
    }

    final fillPath = Path.from(linePath)
      ..lineTo(offsets.last.dx, top + chartHeight)
      ..lineTo(offsets.first.dx, top + chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x5539FF14), Color(0x1027A612)],
      ).createShader(Rect.fromLTWH(left, top, chartWidth, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const ui.Color.fromARGB(255, 7, 155, 64)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = const ui.Color.fromARGB(255, 34, 177, 87);
    for (final o in offsets) {
      canvas.drawCircle(o, 3, dotPaint);
    }

    // Amount label on each point
    final valuePainter = TextPainter(textDirection: ui.TextDirection.ltr);
    for (int i = 0; i < points.length; i++) {
      valuePainter.text = TextSpan(
        text: points[i].value.toStringAsFixed(2),
        style: const TextStyle(
          color: ui.Color.fromARGB(255, 44, 227, 47),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      );
      valuePainter.layout(maxWidth: 56);
      final dx = offsets[i].dx - (valuePainter.width / 2);
      final dy = offsets[i].dy - valuePainter.height - 8;
      valuePainter.paint(canvas, Offset(dx, dy));
    }

    final tp = TextPainter(textDirection: ui.TextDirection.ltr);
    for (int i = 0; i < points.length; i++) {
      tp.text = TextSpan(
        text: points[i].label,
        style: const TextStyle(
          color: Color(0xFFA6A8AB),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
      tp.layout(maxWidth: 64);
      final x = left + i * stepX - (tp.width / 2);
      tp.paint(canvas, Offset(x, size.height - bottom + 8));
    }
  }

  @override
  bool shouldRepaint(covariant _IncomeGraphPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
