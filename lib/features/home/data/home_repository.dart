import '../../../core/network/network_result.dart';
import '../../league/models/league_model.dart' as league_model;
import '../../league/models/match_model.dart' as league_match;
import '../../league/models/standing_model.dart' as league_standing;
import '../models/payment_income_model.dart';
import '../models/referral_stats_model.dart';
import '../models/referral_summary_model.dart';

/// Contracts for Home feature data access.
abstract class HomeRepository {
  NetworkResult<List<league_match.Match>> getAllMatches();

  NetworkResult<List<league_standing.Standing>> getAllStandings();

  NetworkResult<List<league_model.League>> getAllLeagues();

  NetworkResult<List<ReferralSummary>> getReferralSummaries();

  NetworkResult<PaymentIncomeResponse> getIncomeDayMonth();

  NetworkResult<PaymentIncomeCategoryWiseResponse> getIncomeCategoryWise();

  NetworkResult<PaymentKpiResponse> getPaymentKpi();

  NetworkResult<ReferralStatsResponse> getReferralStats(String referralId);

  NetworkResult<Map<String, dynamic>> createReferralPerson(String name);

  NetworkResult<Map<String, dynamic>> deleteMatch(String matchId);
}
