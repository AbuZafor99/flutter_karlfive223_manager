import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/model/notification_list_response_model.dart';
import '../../domain/repo/notification_repo.dart';

class NotificationController extends BaseController {
  final NotificationRepo _notificationRepo;
  final AuthStorageService _authStorageService;
  
  var unreadNotifications = <NotificationItemModel>[].obs;
  var readNotifications = <NotificationItemModel>[].obs;
  var unreadCount = 0.obs;
  var isLoadingNotifications = false.obs;
  var isEmpty = false.obs;

  NotificationController({
    required NotificationRepo notificationRepo,
    required AuthStorageService authStorageService,
  })  : _notificationRepo = notificationRepo,
        _authStorageService = authStorageService;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoadingNotifications.value = true;
      isEmpty.value = false;
      
      // Get userId from storage
      final userId = await _authStorageService.getUserId() ?? '68d117a5d487a29db7269e1d';
      
      final result = await _notificationRepo.getNotificationListByUserId(userId);
      
      result.fold(
        (failure) {
          isLoadingNotifications.value = false;
          isEmpty.value = true;
          unreadNotifications.value = [];
          readNotifications.value = [];
          unreadCount.value = 0;
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (success) {
          final notificationList = success.data;
          
          // Separate unread and read
          unreadNotifications.value = notificationList.unread;
          readNotifications.value = notificationList.read;
          unreadCount.value = notificationList.unreadCount;
          
          // Check if completely empty
          if (unreadNotifications.isEmpty && readNotifications.isEmpty) {
            isEmpty.value = true;
          } else {
            isEmpty.value = false;
          }
          
          isLoadingNotifications.value = false;
        },
      );
    } catch (e) {
      isLoadingNotifications.value = false;
      isEmpty.value = true;
      unreadNotifications.value = [];
      readNotifications.value = [];
      unreadCount.value = 0;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // Call the API endpoint
      final result = await _notificationRepo.markAllAsRead();
      
      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
        (success) {
          // Show the success message from the API response
          Get.snackbar(
            'Success',
            success.data.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          
          // Move all unread to read
          readNotifications.addAll(unreadNotifications);
          unreadNotifications.clear();
          unreadCount.value = 0;
          
          // Auto-refresh the notification list after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            loadNotifications();
          });
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to mark notifications as read',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
