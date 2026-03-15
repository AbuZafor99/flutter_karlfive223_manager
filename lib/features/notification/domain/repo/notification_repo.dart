
import 'package:dartz/dartz.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../../../core/network/network_result.dart';
import '../../data/model/mark_all_as_read_response_model.dart';
import '../../data/model/notification_list_response_model.dart';
import '../../data/model/notification_request_model.dart';
import '../../data/model/notification_response_model.dart';

abstract class NotificationRepo {
  NetworkResult<NotificationResponseModel> getnotifications(
    NotificationRequestModel request,
  );

  NetworkResult<NotificationResponseModel> markAsRead(
    NotificationRequestModel request,
  );
  
  NetworkResult<List<NotificationResponseModel>> getNotificationsByUserId(String userId);
  
  NetworkResult<NotificationListResponseModel> getNotificationListByUserId(String userId);
  
  Future<Either<NetworkFailure, NetworkSuccess<MarkAllAsReadResponseModel>>> markAllAsRead();
}
