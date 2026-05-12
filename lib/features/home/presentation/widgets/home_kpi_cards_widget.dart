import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';

class HomeKpiCardsWidget extends StatelessWidget {
  const HomeKpiCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final kpi = controller.paymentKpiData.value;
      if (kpi == null) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'No KPI data available',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.45,
          children: [
            _KpiCard(
              title: 'Total Income',
              value: '\$${kpi.totalMonthlyIncome.toStringAsFixed(2)}',
              badgeText: '${kpi.totalMonthlyPayments} pay',
            ),
            _KpiCard(
              title: 'Total User Join',
              value: '${kpi.totalMonthlyPayments}',
              badgeText: 'New',
              badgeColor: const Color(0xFFB9FF00),
            ),
            _ActiveLeagueKpiCard(
              title: 'Active League',
              total: kpi.totalActiveLeagues,
              publicCount: kpi.activePublicLeagues,
              privateCount: kpi.breakdown.activePrivateLeagues,
              americanoCount: kpi.breakdown.activeAmericanoLeagues,
            ),
            _KpiCard(
              title: 'Active Event',
              value: '${kpi.activeEvents}',
              badgeText: 'Scheduled',
              badgeColor: Colors.white54,
            ),
          ],
        ),
      );
    });
  }
}

class _ActiveLeagueKpiCard extends StatelessWidget {
  final String title;
  final int total;
  final int publicCount;
  final int privateCount;
  final int americanoCount;

  const _ActiveLeagueKpiCard({
    required this.title,
    required this.total,
    required this.publicCount,
    required this.privateCount,
    required this.americanoCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF14161A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Public: $publicCount',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Private: $privateCount',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Americano: $americanoCount',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String badgeText;
  final Color badgeColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.badgeText,
    this.badgeColor = const Color(0xFFC5FF2D),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF14161A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
