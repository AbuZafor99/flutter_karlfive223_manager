

import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/notification_repo.dart';
import '../model/mark_all_as_read_response_model.dart';
import '../model/notification_list_response_model.dart';
import '../model/notification_request_model.dart';
import '../model/notification_response_model.dart';

class NotificationRepoImpl implements NotificationRepo {
  final ApiClient _apiClient;

  NotificationRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<NotificationResponseModel> getnotifications(
    NotificationRequestModel request,
  ) {
    return _apiClient.get<NotificationResponseModel>(
      ApiConstants.notification.getnotifications,
      queryParameters: request.toJson(),
      fromJsonT: (json) => NotificationResponseModel.fromJson(json),
      // isFormData: true
    );
  }

  @override
  NetworkResult<NotificationResponseModel> markAsRead(
    NotificationRequestModel request,
  ) {
    return _apiClient.get<NotificationResponseModel>(
      ApiConstants.notification.getnotifications,
      queryParameters: request.toJson(),
      fromJsonT: (json) => NotificationResponseModel.fromJson(json),
      // isFormData: true
    );
  }

  @override
  NetworkResult<List<NotificationResponseModel>> getNotificationsByUserId(String userId) {
    return _apiClient.get<List<NotificationResponseModel>>(
      ApiConstants.notification.getNotificationsByUserId(userId),
      fromJsonT: (json) {
        // json is already the 'data' array from the BaseResponse
        final dataList = json as List<dynamic>? ?? [];
        return dataList
            .map((item) => NotificationResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  NetworkResult<NotificationListResponseModel> getNotificationListByUserId(String userId) {
    return _apiClient.get<NotificationListResponseModel>(
      ApiConstants.notification.getNotificationsByUserId(userId),
      fromJsonT: (json) => NotificationListResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<MarkAllAsReadResponseModel>>> markAllAsRead() {
    return _apiClient.post<MarkAllAsReadResponseModel>(
      ApiConstants.notification.markAllAsRead,
      fromJsonT: (json) => MarkAllAsReadResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
