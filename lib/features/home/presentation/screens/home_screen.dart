import 'package:flutter/material.dart';
import 'package:flutter_karlfive223_manager/features/Create_league/presentation/screens/create_league_screen.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/app_images.dart';
import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/common/widgets/shimmer_widgets.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notification/data/repo/notification_repo_impl.dart';
import '../../../notification/presentation/controller/notifi_dummy_controller.dart';
import '../../../notification/presentation/screen/notification_screen.dart';
import '../../controller/home_controller.dart';
import '../widgets/home_kpi_cards_widget.dart';
import '../widgets/income_category_breakdown_widget.dart';
import '../widgets/income_graph_widget.dart';
import '../widgets/referral_summary_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(HomeController());
    final notificationController = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(
            NotificationController(
              notificationRepo: NotificationRepoImpl(
                apiClient: Get.find<ApiClient>(),
              ),
              authStorageService: Get.find<AuthStorageService>(),
            ),
          );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          backgroundColor: AppColors.leagueBackgroundGrey,
          elevation: 0,
          title: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // LEFT: greeting text with max width constraint
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.45,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            final name = controller.userName.value.isNotEmpty
                                ? controller.userName.value
                                : 'Guest';
                            return Text(
                              'Hello $name,',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          }),
                          const SizedBox(height: 4),
                          const Text(
                            "Welcome to \nThe Central Padel League App",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // CENTER: circular responsive logo
                  Align(
                    alignment: const Alignment(0.17, 0),
                    child: SizedBox(
                      height: kToolbarHeight * 0.85,
                      width: kToolbarHeight * 0.85,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        padding: const EdgeInsets.all(1),
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.homelogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            // Notification Icon
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.grey[850],
                child: IconButton(
                  onPressed: () {
                    // Navigate to notification screen
                    Get.to(
                      () => const NotificationScreen(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 50),
                    );
                  },
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        'assets/icons/notification.png',
                        width: 24,
                        height: 24,
                      ),
                      Obx(() {
                        final unread = notificationController.unreadCount.value;
                        if (unread <= 0) {
                          return const SizedBox.shrink();
                        }

                        return Positioned(
                          top: -6,
                          right: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            constraints: const BoxConstraints(minWidth: 16),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.leagueBackgroundGrey,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              unread > 99 ? '99+' : unread.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            // Create League Icon
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: Colors.grey[850],
                child: IconButton(
                  onPressed: () {
                    // TODO: button logic here
                    Get.to(() => CreateLeagueScreen());
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        color: AppColors.leagueBackgroundGrey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        HomeKpiCardsShimmer(),
                        SizedBox(height: 20),
                        IncomeGraphShimmer(),
                        SizedBox(height: 20),
                        IncomeCategoryBreakdownShimmer(),
                        SizedBox(height: 20),
                        ReferralSummaryShimmer(),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HomeKpiCardsWidget(),
                      SizedBox(height: 20),
                      IncomeGraphWidget(),
                      SizedBox(height: 20),
                      IncomeCategoryBreakdownWidget(),
                      SizedBox(height: 20),
                      ReferralSummaryWidget(),
                    ],
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
