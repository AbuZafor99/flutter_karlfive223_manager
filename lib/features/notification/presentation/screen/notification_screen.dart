import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/model/notification_list_response_model.dart';
import '../../data/repo/notification_repo_impl.dart';
import '../controller/notifi_dummy_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize dependencies and controller once in initState
    final apiClient = Get.find<ApiClient>();
    final authStorage = Get.find<AuthStorageService>();
    final notificationRepo = NotificationRepoImpl(apiClient: apiClient);
    
    // Use Get.put with tag or Get.find if already registered
    if (Get.isRegistered<NotificationController>()) {
      _controller = Get.find<NotificationController>();
    } else {
      _controller = Get.put(
        NotificationController(
          notificationRepo: notificationRepo,
          authStorageService: authStorage,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Notification",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.notificationColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _controller.unreadCount.value.toString(),
                            style: const TextStyle(
                              color: AppColors.buttonText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _controller.markAllAsRead(),
                    child: const Text(
                      "Mark All",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notification List with RefreshIndicator
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _controller.loadNotifications(),
                color: AppColors.primaryGreen,
                backgroundColor: Colors.grey.shade900,
                child: Obx(() {
                  // Show loading spinner
                  if (_controller.isLoadingNotifications.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    );
                  }

                  // Show empty state
                  if (_controller.isEmpty.value) {
                    return const Center(
                      child: Text(
                        'No notifications',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  // Show notifications with sections
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      // UNREAD SECTION
                      if (_controller.unreadNotifications.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Unread',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ..._controller.unreadNotifications.map((notification) {
                          return _buildNotificationCard(notification, true);
                        }).toList(),
                        const SizedBox(height: 16),
                      ],

                      // READ SECTION
                      if (_controller.readNotifications.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Read',
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ..._controller.readNotifications.map((notification) {
                          return _buildNotificationCard(notification, false);
                        }).toList(),
                      ],
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildNotificationCard(NotificationItemModel notification, bool isUnread) {
    String formatTimeAgo(DateTime dateTime) {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 30) {
        return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUnread ? Colors.grey.shade300 : Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4, right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnread ? Colors.green : Colors.grey[600],
            ),
          ),
          // Content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification.title.isNotEmpty)
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isUnread ? Colors.black : AppColors.primaryText,
                      fontSize: 13,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    color: isUnread ? Colors.black87 : Colors.grey[400],
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  formatTimeAgo(notification.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: isUnread ? Colors.grey[600] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
