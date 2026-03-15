import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/models/event_model.dart';
import '../../data/repo/event_repo.dart';

class EventsController extends GetxController {
  final repository = EventRepositoryImpl(apiClient: Get.find<ApiClient>());

  final events = <EventModel>[].obs;
  final filteredEvents = <EventModel>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'all'.obs; // 'all', 'pending', 'approved'

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final result = await repository.fetchAllEvents();

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (success) {
          events.value = success.data;
          applyFilter('all');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch events: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;

    if (filter == 'all') {
      filteredEvents.value = events;
    } else if (filter == 'pending') {
      filteredEvents.value = events.where((event) => event.status == 'pending').toList();
    } else if (filter == 'approved') {
      filteredEvents.value = events.where((event) => event.status == 'approved').toList();
    }
  }

  void resetFilter() {
    applyFilter('all');
  }

  Future<void> acceptEvent(String eventId) async {
    try {
      isLoading.value = true;
      final result = await repository.acceptEvent(eventId);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Update the events list
          final index = events.indexWhere((e) => e.id == eventId);
          if (index != -1) {
            events[index] = success.data;
            events.refresh();
          }

          applyFilter(selectedFilter.value);
          Get.snackbar('Success', 'Event approved successfully');
          
          // Refresh data from API after success
          fetchEvents();
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve event: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectEvent(String eventId) async {
    try {
      isLoading.value = true;
      final result = await repository.rejectEvent(eventId);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (success) {
          // Remove the event from the list
          events.removeWhere((e) => e.id == eventId);
          events.refresh();

          applyFilter(selectedFilter.value);
          Get.snackbar('Success', 'Event rejected successfully');
          
          // Refresh data from API after success
          fetchEvents();
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject event: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
