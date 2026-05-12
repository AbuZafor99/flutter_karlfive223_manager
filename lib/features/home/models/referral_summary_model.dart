class ReferralSummary {
  final String id;
  final String name;
  final int joinedCount;

  ReferralSummary({
    required this.id,
    required this.name,
    required this.joinedCount,
  });

  factory ReferralSummary.fromJson(Map<String, dynamic> json) {
    return ReferralSummary(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      joinedCount: json['joinedCount'] is int
          ? json['joinedCount'] as int
          : int.tryParse(json['joinedCount']?.toString() ?? '0') ?? 0,
    );
  }
}
