import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import '../../league/models/league_model.dart' as league_model;
import '../../league/models/match_model.dart' as league_match;
import '../../league/models/standing_model.dart' as league_standing;
import '../models/payment_income_model.dart';
import '../models/referral_stats_model.dart';
import '../models/referral_summary_model.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient apiClient;

  HomeRepositoryImpl({required this.apiClient});

  @override
  NetworkResult<List<league_match.Match>> getAllMatches() {
    final endpoint = '${ApiConstants.baseUrl}/match/all-match';
    return apiClient.get<List<league_match.Match>>(
      endpoint,
      fromJsonT: (json) {
        return (json as List)
            .map((e) => league_match.Match.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  NetworkResult<List<league_standing.Standing>> getAllStandings() {
    final endpoint = '${ApiConstants.baseUrl}/standing/all';
    return apiClient.get<List<league_standing.Standing>>(
      endpoint,
      fromJsonT: (json) {
        return (json as List)
            .map(
              (e) =>
                  league_standing.Standing.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      },
    );
  }

  @override
  NetworkResult<List<league_model.League>> getAllLeagues() {
    final endpoint = '${ApiConstants.baseUrl}/league/all-league';
    return apiClient.get<List<league_model.League>>(
      endpoint,
      fromJsonT: (json) =>
          (json as List).map((e) => league_model.League.fromJson(e)).toList(),
    );
  }

  @override
  NetworkResult<List<ReferralSummary>> getReferralSummaries() {
    final endpoint = '${ApiConstants.baseUrl}/referral/summary';
    return apiClient.get<List<ReferralSummary>>(
      endpoint,
      fromJsonT: (json) {
        return (json as List)
            .map((e) => ReferralSummary.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  NetworkResult<PaymentIncomeResponse> getIncomeDayMonth() {
    final endpoint = '${ApiConstants.baseUrl}/payment/income/day-month';
    return apiClient.get<PaymentIncomeResponse>(
      endpoint,
      fromJsonT: (json) {
        return PaymentIncomeResponse.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  NetworkResult<PaymentIncomeCategoryWiseResponse> getIncomeCategoryWise() {
    final endpoint = '${ApiConstants.baseUrl}/payment/income/category-wise';
    return apiClient.get<PaymentIncomeCategoryWiseResponse>(
      endpoint,
      fromJsonT: (json) {
        return PaymentIncomeCategoryWiseResponse.fromJson(
          json as Map<String, dynamic>,
        );
      },
    );
  }

  @override
  NetworkResult<PaymentKpiResponse> getPaymentKpi() {
    final endpoint = '${ApiConstants.baseUrl}/payment/kpi';
    return apiClient.get<PaymentKpiResponse>(
      endpoint,
      fromJsonT: (json) {
        return PaymentKpiResponse.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  NetworkResult<ReferralStatsResponse> getReferralStats(String referralId) {
    final endpoint = '${ApiConstants.baseUrl}/referral/stats/$referralId';
    return apiClient.get<ReferralStatsResponse>(
      endpoint,
      fromJsonT: (json) {
        return ReferralStatsResponse.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  NetworkResult<Map<String, dynamic>> createReferralPerson(String name) {
    final endpoint = '${ApiConstants.baseUrl}/referral/create';
    return apiClient.post<Map<String, dynamic>>(
      endpoint,
      data: {'name': name},
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return <String, dynamic>{};
      },
    );
  }

  @override
  NetworkResult<Map<String, dynamic>> deleteMatch(String matchId) {
    final endpoint = '${ApiConstants.baseUrl}/match/$matchId';
    return apiClient.delete<Map<String, dynamic>>(
      endpoint,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }
}
