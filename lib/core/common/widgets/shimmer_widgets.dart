import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Base shimmer effect widget
class ShimmerEffect extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[850]!,
      highlightColor: highlightColor ?? Colors.grey[700]!,
      child: child,
    );
  }
}

/// Shimmer box for rectangular areas
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Shimmer text line
class ShimmerTextLine extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerTextLine({
    super.key,
    this.width = double.infinity,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Shimmer circle avatar
class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Shimmer for game reminder widget
class GameReminderShimmer extends StatelessWidget {
  const GameReminderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth < 400 ? 12.0 : 24.0,
        vertical: 8.0,
      ),
      child: ShimmerBox(
        width: double.infinity,
        height: 90,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Shimmer for league update section
class LeagueUpdateShimmer extends StatelessWidget {
  const LeagueUpdateShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextLine(width: 150, height: 18),
          SizedBox(height: screenWidth < 350 ? 8 : 12),
          const ShimmerTextLine(width: 200, height: 14),
          const SizedBox(height: 8),
          const ShimmerTextLine(width: 250, height: 14),
          const SizedBox(height: 8),
          const ShimmerTextLine(width: 120, height: 14),
        ],
      ),
    );
  }
}

/// Shimmer for income graph section
class IncomeGraphShimmer extends StatelessWidget {
  const IncomeGraphShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextLine(width: 160, height: 22),
          const SizedBox(height: 12),
          ShimmerBox(
            width: double.infinity,
            height: 300,
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for category-wise subscription breakdown card
class IncomeCategoryBreakdownShimmer extends StatelessWidget {
  const IncomeCategoryBreakdownShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextLine(width: 220, height: 20),
          const SizedBox(height: 12),
          ShimmerBox(
            width: double.infinity,
            height: 430,
            borderRadius: BorderRadius.circular(18),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for Home KPI cards grid
class HomeKpiCardsShimmer extends StatelessWidget {
  const HomeKpiCardsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 24),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.45,
        children: List.generate(
          4,
          (_) => ShimmerBox(
            width: double.infinity,
            height: 130,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for next match widget
class NextMatchShimmer extends StatelessWidget {
  const NextMatchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextLine(width: 150, height: 18),
          const SizedBox(height: 12),
          ShimmerBox(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for quick stats widget
class QuickStatsShimmer extends StatelessWidget {
  const QuickStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 350 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextLine(width: 120, height: 18),
          const SizedBox(height: 8),
          // Table header
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: screenWidth < 350 ? 8 : 12,
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: ShimmerTextLine(width: 60, height: 14),
                ),
                Expanded(child: ShimmerTextLine(width: 30, height: 14)),
                Expanded(child: ShimmerTextLine(width: 30, height: 14)),
                Expanded(child: ShimmerTextLine(width: 30, height: 14)),
                Expanded(child: ShimmerTextLine(width: 30, height: 14)),
                Expanded(child: ShimmerTextLine(width: 30, height: 14)),
              ],
            ),
          ),
          // Table rows
          ...List.generate(
            2,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: const [
                        ShimmerTextLine(width: 30, height: 12),
                        SizedBox(width: 8),
                        ShimmerCircle(size: 24),
                        SizedBox(width: 4),
                        ShimmerCircle(size: 24),
                        SizedBox(width: 8),
                        Expanded(child: ShimmerTextLine(height: 12)),
                      ],
                    ),
                  ),
                  const Expanded(child: ShimmerTextLine(width: 20, height: 12)),
                  const Expanded(child: ShimmerTextLine(width: 20, height: 12)),
                  const Expanded(child: ShimmerTextLine(width: 20, height: 12)),
                  const Expanded(child: ShimmerTextLine(width: 20, height: 12)),
                  const Expanded(child: ShimmerTextLine(width: 20, height: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for fixtures widget
class FixturesShimmer extends StatelessWidget {
  const FixturesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextLine(width: 120, height: 18),
          const SizedBox(height: 12),
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ShimmerBox(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for referral summary list
class ReferralSummaryShimmer extends StatelessWidget {
  const ReferralSummaryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth < 400 ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextLine(width: 150, height: 18),
          const SizedBox(height: 12),
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ShimmerBox(
                width: double.infinity,
                height: 44,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for league list (leagues screen)
class LeagueListShimmer extends StatelessWidget {
  const LeagueListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ShimmerBox(
          width: double.infinity,
          height: 100,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shimmer for team details screen
class TeamDetailsShimmer extends StatelessWidget {
  const TeamDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team header
          Row(
            children: [
              const ShimmerCircle(size: 60),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerTextLine(width: 150, height: 20),
                    SizedBox(height: 8),
                    ShimmerTextLine(width: 100, height: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Stats section
          const ShimmerTextLine(width: 120, height: 18),
          const SizedBox(height: 12),
          ShimmerBox(
            width: double.infinity,
            height: 200,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}

/// Shimmer for profile info screen
class ProfileInfoShimmer extends StatelessWidget {
  const ProfileInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile Image
          const ShimmerCircle(size: 100),
          const SizedBox(height: 14),
          // Name
          const ShimmerTextLine(width: 150, height: 16),
          const SizedBox(height: 33),
          // Phone and Email Card
          ShimmerBox(
            width: double.infinity,
            height: 120,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          // Language Card
          ShimmerBox(
            width: double.infinity,
            height: 60,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          // Contact/Privacy/Report Card
          ShimmerBox(
            width: double.infinity,
            height: 160,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 27),
          // Logout Card
          ShimmerBox(
            width: double.infinity,
            height: 50,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
