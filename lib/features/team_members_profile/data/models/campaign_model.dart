class CampaignResponse {
  final Summary summary;
  final Coupons coupons;

  CampaignResponse({
    required this.summary,
    required this.coupons,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    return CampaignResponse(
      summary: Summary.fromJson(json['summary']),
      coupons: Coupons.fromJson(json['coupons']),
    );
  }
}

class Summary {
  final int totalCoupons;
  final int scheduledCount;
  final int runningCount;
  final int expiredCount;

  Summary({
    required this.totalCoupons,
    required this.scheduledCount,
    required this.runningCount,
    required this.expiredCount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalCoupons: json['totalCoupons'] as int? ?? 0,
      scheduledCount: json['scheduledCount'] as int? ?? 0,
      runningCount: json['runningCount'] as int? ?? 0,
      expiredCount: json['expiredCount'] as int? ?? 0,
    );
  }
}

class Coupons {
  final List<Campaign> scheduled;
  final List<Campaign> running;
  final List<Campaign> expired;

  Coupons({
    required this.scheduled,
    required this.running,
    required this.expired,
  });

  factory Coupons.fromJson(Map<String, dynamic> json) {
    return Coupons(
      scheduled: (json['scheduled'] as List<dynamic>?)
              ?.map((e) => Campaign.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      running: (json['running'] as List<dynamic>?)
              ?.map((e) => Campaign.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      expired: (json['expired'] as List<dynamic>?)
              ?.map((e) => Campaign.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Campaign {
  final String id;
  final String code;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int rewardDays;
  final int redeemedCount;

  Campaign({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.rewardDays,
    required this.redeemedCount,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['_id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String? ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] as String? ?? DateTime.now().toIso8601String()),
      status: json['status'] as String? ?? '',
      rewardDays: json['rewardDays'] as int? ?? 0,
      redeemedCount: json['redeemedCount'] as int? ?? 0,
    );
  }
}
