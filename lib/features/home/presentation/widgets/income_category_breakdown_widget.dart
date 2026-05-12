import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../controller/home_controller.dart';
import '../../models/payment_income_model.dart';

class IncomeCategoryBreakdownWidget extends StatelessWidget {
  const IncomeCategoryBreakdownWidget({super.key});

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'gold':
        return const Color(0xFFF6C431);
      case 'basic':
        return const Color(0xFF596274);
      case 'premium':
        return const Color(0xFFB9FF00);
      case 'club':
        return const Color(0xFF8B5BEF);
      default:
        return const Color(0xFF39FF14);
    }
  }

  String _titleCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final data = controller.incomeCategoryData.value;
      if (data == null || data.overallCategoryWise.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Subscription Breakdown',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'No category-wise income data available',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        );
      }

      final categories = data.overallCategoryWise;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Breakdown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF131416),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(260, 260),
                          painter: _DonutPainter(
                            categories: categories,
                            colorFor: _categoryColor,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'TOTAL INCOME',
                              style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${data.summary.totalIncome.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 26,
                    runSpacing: 14,
                    children: categories.map((item) {
                      return SizedBox(
                        width: 130,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.only(top: 3),
                              decoration: BoxDecoration(
                                color: _categoryColor(item.category),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _titleCase(item.category),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${item.percentageByAmount.toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DonutPainter extends CustomPainter {
  final List<PaymentCategoryItem> categories;
  final Color Function(String) colorFor;

  _DonutPainter({required this.categories, required this.colorFor});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 36.0;
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    const gapRadians = 0.02;
    const startAngle = -math.pi / 2;
    final totalPercent = categories.fold<double>(
      0,
      (s, e) => s + e.percentageByAmount,
    );
    final safeTotal = totalPercent <= 0 ? 100 : totalPercent;

    var currentAngle = startAngle;
    for (final item in categories) {
      final sweep =
          ((item.percentageByAmount / safeTotal) * 2 * math.pi) - gapRadians;
      if (sweep <= 0) {
        continue;
      }

      final paint = Paint()
        ..color = colorFor(item.category)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, currentAngle, sweep, false, paint);
      currentAngle += sweep + gapRadians;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}
