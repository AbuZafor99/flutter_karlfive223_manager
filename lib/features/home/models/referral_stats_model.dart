import 'referral_summary_model.dart';

class ReferralDailyStat {
  final int joinedCount;
  final DateTime date;

  ReferralDailyStat({required this.joinedCount, required this.date});

  factory ReferralDailyStat.fromJson(Map<String, dynamic> json) {
    return ReferralDailyStat(
      joinedCount: json['joinedCount'] is int
          ? json['joinedCount'] as int
          : int.tryParse(json['joinedCount']?.toString() ?? '0') ?? 0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class ReferralStatsResponse {
  final ReferralSummary referralPerson;
  final List<ReferralDailyStat> dailyStats;

  ReferralStatsResponse({
    required this.referralPerson,
    required this.dailyStats,
  });

  factory ReferralStatsResponse.fromJson(Map<String, dynamic> json) {
    return ReferralStatsResponse(
      referralPerson: ReferralSummary.fromJson(
        (json['referralPerson'] as Map<String, dynamic>? ?? {}),
      ),
      dailyStats: (json['dailyStats'] as List<dynamic>? ?? [])
          .map((e) => ReferralDailyStat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
