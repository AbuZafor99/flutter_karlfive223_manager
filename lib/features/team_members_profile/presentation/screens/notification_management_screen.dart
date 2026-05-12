import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notification/data/model/notification_list_response_model.dart';
import '../../../notification/data/repo/notification_repo_impl.dart';
import '../../../notification/presentation/controller/notifi_dummy_controller.dart';

class NotificationManagementScreen extends StatefulWidget {
  const NotificationManagementScreen({super.key});

  @override
  State<NotificationManagementScreen> createState() =>
      _NotificationManagementScreenState();
}

class _NotificationManagementScreenState
    extends State<NotificationManagementScreen> {
  late NotificationController _controller;

  @override
  void initState() {
    super.initState();
    final apiClient = Get.find<ApiClient>();
    final authStorage = Get.find<AuthStorageService>();
    final notificationRepo = NotificationRepoImpl(apiClient: apiClient);

    if (Get.isRegistered<NotificationController>(
      tag: 'notification-management',
    )) {
      _controller = Get.find<NotificationController>(
        tag: 'notification-management',
      );
    } else {
      _controller = Get.put(
        NotificationController(
          notificationRepo: notificationRepo,
          authStorageService: authStorage,
        ),
        tag: 'notification-management',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      appBar: AppBar(
        backgroundColor: AppColors.leagueBackgroundGrey,
        elevation: 0,
        title: const Text(
          'Notification Management',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Recent notifications sent by manager to all users.',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _controller.markAllAsRead(),
                    child: const Text(
                      'Mark All',
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _controller.loadNotifications(),
                color: AppColors.primaryGreen,
                backgroundColor: Colors.grey.shade900,
                child: Obx(() {
                  if (_controller.isLoadingNotifications.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    );
                  }

                  final items =
                      <_RecentNotificationItem>[
                        ..._controller.unreadNotifications.map(
                          (notification) => _RecentNotificationItem(
                            notification: notification,
                            isRead: false,
                          ),
                        ),
                        ..._controller.readNotifications.map(
                          (notification) => _RecentNotificationItem(
                            notification: notification,
                            isRead: true,
                          ),
                        ),
                      ]..sort(
                        (left, right) => right.notification.createdAt.compareTo(
                          left.notification.createdAt,
                        ),
                      );

                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No notifications yet',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 15,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _RecentNotificationCard(
                        notification: item.notification,
                        isRead: item.isRead,
                      );
                    },
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
}

class _RecentNotificationItem {
  final NotificationItemModel notification;
  final bool isRead;

  _RecentNotificationItem({required this.notification, required this.isRead});
}

class _RecentNotificationCard extends StatelessWidget {
  final NotificationItemModel notification;
  final bool isRead;

  const _RecentNotificationCard({
    required this.notification,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey.shade900 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRead ? Colors.grey.shade800 : AppColors.primaryGreen,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRead ? Colors.grey : AppColors.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.message,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTimeAgo(notification.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }
}
