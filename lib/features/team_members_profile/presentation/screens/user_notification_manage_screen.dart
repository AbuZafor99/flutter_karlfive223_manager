import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/theme/app_colors.dart';
import 'running_campaign_screen.dart';
import 'send_notification_screen.dart';

class UserNotificationManageScreen extends StatefulWidget {
  const UserNotificationManageScreen({super.key});

  @override
  State<UserNotificationManageScreen> createState() =>
      _UserNotificationManageScreenState();
}

class _UserNotificationManageScreenState
    extends State<UserNotificationManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColors.leagueBackgroundGrey,
        elevation: 0,
        title: const Text(
          'Users',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const Text(
              'Choose a section to manage user notifications and campaigns.',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Send Notification',
              subtitle:
                  'Compose and send a custom notification to selected users.',
              icon: Icons.send_outlined,
              accentColor: Colors.blueAccent,
              onTap: () {
                Get.to(() => const SendNotificationScreen());
              },
            ),
            const SizedBox(height: 12),
            _buildSectionCard(
              title: 'Running Campaign',
              subtitle: 'View active campaigns and start a new one with dates.',
              icon: Icons.campaign_outlined,
              accentColor: Colors.orangeAccent,
              onTap: () {
                Get.to(() => const RunningCampaignScreen());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
