class PaymentIncomeSummary {
  final double totalIncome;
  final int totalPayments;

  PaymentIncomeSummary({
    required this.totalIncome,
    required this.totalPayments,
  });

  factory PaymentIncomeSummary.fromJson(Map<String, dynamic> json) {
    return PaymentIncomeSummary(
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0,
      totalPayments: json['totalPayments'] as int? ?? 0,
    );
  }
}

class PaymentIncomeDayItem {
  final double income;
  final int totalPayments;
  final DateTime day;

  PaymentIncomeDayItem({
    required this.income,
    required this.totalPayments,
    required this.day,
  });

  factory PaymentIncomeDayItem.fromJson(Map<String, dynamic> json) {
    return PaymentIncomeDayItem(
      income: (json['income'] as num?)?.toDouble() ?? 0,
      totalPayments: json['totalPayments'] as int? ?? 0,
      day: DateTime.tryParse(json['day']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class PaymentIncomeMonthItem {
  final double income;
  final int totalPayments;
  final String month;

  PaymentIncomeMonthItem({
    required this.income,
    required this.totalPayments,
    required this.month,
  });

  DateTime get monthDate => DateTime.tryParse('$month-01') ?? DateTime.now();

  factory PaymentIncomeMonthItem.fromJson(Map<String, dynamic> json) {
    return PaymentIncomeMonthItem(
      income: (json['income'] as num?)?.toDouble() ?? 0,
      totalPayments: json['totalPayments'] as int? ?? 0,
      month: json['month']?.toString() ?? '',
    );
  }
}

class PaymentIncomeResponse {
  final PaymentIncomeSummary summary;
  final List<PaymentIncomeDayItem> dayWise;
  final List<PaymentIncomeMonthItem> monthWise;

  PaymentIncomeResponse({
    required this.summary,
    required this.dayWise,
    required this.monthWise,
  });

  factory PaymentIncomeResponse.fromJson(Map<String, dynamic> json) {
    return PaymentIncomeResponse(
      summary: PaymentIncomeSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      dayWise: (json['dayWise'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => PaymentIncomeDayItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      monthWise: (json['monthWise'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (e) => PaymentIncomeMonthItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PaymentCategoryItem {
  final String category;
  final double income;
  final int totalPayments;
  final double percentageByAmount;
  final double percentageByCount;

  PaymentCategoryItem({
    required this.category,
    required this.income,
    required this.totalPayments,
    required this.percentageByAmount,
    required this.percentageByCount,
  });

  factory PaymentCategoryItem.fromJson(Map<String, dynamic> json) {
    return PaymentCategoryItem(
      category: json['category']?.toString() ?? '',
      income: (json['income'] as num?)?.toDouble() ?? 0,
      totalPayments: json['totalPayments'] as int? ?? 0,
      percentageByAmount: (json['percentageByAmount'] as num?)?.toDouble() ?? 0,
      percentageByCount: (json['percentageByCount'] as num?)?.toDouble() ?? 0,
    );
  }
}

class PaymentCategoryMonthItem {
  final String month;
  final double totalIncome;
  final int totalPayments;
  final List<PaymentCategoryItem> categories;

  PaymentCategoryMonthItem({
    required this.month,
    required this.totalIncome,
    required this.totalPayments,
    required this.categories,
  });

  factory PaymentCategoryMonthItem.fromJson(Map<String, dynamic> json) {
    return PaymentCategoryMonthItem(
      month: json['month']?.toString() ?? '',
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0,
      totalPayments: json['totalPayments'] as int? ?? 0,
      categories: (json['categories'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => PaymentCategoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PaymentIncomeCategoryWiseResponse {
  final PaymentIncomeSummary summary;
  final List<PaymentCategoryItem> overallCategoryWise;
  final List<PaymentCategoryMonthItem> monthWise;

  PaymentIncomeCategoryWiseResponse({
    required this.summary,
    required this.overallCategoryWise,
    required this.monthWise,
  });

  factory PaymentIncomeCategoryWiseResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentIncomeCategoryWiseResponse(
      summary: PaymentIncomeSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      overallCategoryWise:
          (json['overallCategoryWise'] as List<dynamic>? ?? <dynamic>[])
              .map(
                (e) => PaymentCategoryItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      monthWise: (json['monthWise'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (e) => PaymentCategoryMonthItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PaymentKpiBreakdown {
  final int activePrivateLeagues;
  final int activeAmericanoLeagues;

  PaymentKpiBreakdown({
    required this.activePrivateLeagues,
    required this.activeAmericanoLeagues,
  });

  factory PaymentKpiBreakdown.fromJson(Map<String, dynamic> json) {
    return PaymentKpiBreakdown(
      activePrivateLeagues: json['activePrivateLeagues'] as int? ?? 0,
      activeAmericanoLeagues: json['activeAmericanoLeagues'] as int? ?? 0,
    );
  }
}

class PaymentKpiResponse {
  final double totalMonthlyIncome;
  final int totalMonthlyPayments;
  final int activeEvents;
  final int activePublicLeagues;
  final int activePrivateAndAmericanoLeagues;
  final PaymentKpiBreakdown breakdown;

  PaymentKpiResponse({
    required this.totalMonthlyIncome,
    required this.totalMonthlyPayments,
    required this.activeEvents,
    required this.activePublicLeagues,
    required this.activePrivateAndAmericanoLeagues,
    required this.breakdown,
  });

  int get totalActiveLeagues =>
      activePublicLeagues +
      breakdown.activePrivateLeagues +
      breakdown.activeAmericanoLeagues;

  factory PaymentKpiResponse.fromJson(Map<String, dynamic> json) {
    return PaymentKpiResponse(
      totalMonthlyIncome: (json['totalMonthlyIncome'] as num?)?.toDouble() ?? 0,
      totalMonthlyPayments: json['totalMonthlyPayments'] as int? ?? 0,
      activeEvents: json['activeEvents'] as int? ?? 0,
      activePublicLeagues: json['activePublicLeagues'] as int? ?? 0,
      activePrivateAndAmericanoLeagues:
          json['activePrivateAndAmericanoLeagues'] as int? ?? 0,
      breakdown: PaymentKpiBreakdown.fromJson(
        json['breakdown'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}
