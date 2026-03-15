import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../models/event_model.dart';

abstract class EventRepository {
  Future<Either<NetworkFailure, NetworkSuccess<List<EventModel>>>> fetchAllEvents();
  Future<Either<NetworkFailure, NetworkSuccess<List<EventModel>>>> fetchEventsByStatus(String status);
  Future<Either<NetworkFailure, NetworkSuccess<EventModel>>> acceptEvent(String eventId);
  Future<Either<NetworkFailure, NetworkSuccess<EventModel>>> rejectEvent(String eventId);
}

class EventRepositoryImpl implements EventRepository {
  final ApiClient apiClient;

  EventRepositoryImpl({required this.apiClient});

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<EventModel>>>> fetchAllEvents() async {
    return await apiClient.get<List<EventModel>>(
      ApiConstants.event.getAllEvents,
      fromJsonT: (json) {
        final dataList = json as List<dynamic>? ?? [];
        return dataList
            .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<List<EventModel>>>> fetchEventsByStatus(
    String status,
  ) async {
    return await apiClient.get<List<EventModel>>(
      ApiConstants.event.getAllEvents,
      queryParameters: {'status': status},
      fromJsonT: (json) {
        final dataList = json as List<dynamic>? ?? [];
        return dataList
            .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<EventModel>>> acceptEvent(String eventId) async {
    return await apiClient.patch<EventModel>(
      ApiConstants.event.approveEvent(eventId),
      fromJsonT: (json) => EventModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Either<NetworkFailure, NetworkSuccess<EventModel>>> rejectEvent(String eventId) async {
    return await apiClient.patch<EventModel>(
      ApiConstants.event.rejectEvent(eventId),
      fromJsonT: (json) => EventModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
