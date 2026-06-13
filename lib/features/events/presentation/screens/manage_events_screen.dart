import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/app_bottom_navbar.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../controllers/events_controller.dart';
import '../widgets/event_card.dart';

class ManageEventsScreen extends StatelessWidget {
  const ManageEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventsController());

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
                  GestureDetector(
                    onTap: () {
                      // Navigate to HomeScreen instead of Get.back() since we used Get.offAll()
                      Get.offAll(
                        () => const HomeScreen(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 50),
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryText,
                      size: 24,
                    ),
                  ),
                  const Text(
                    'Manage Events',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Filter section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by Status',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildFilterButton(
                            'All',
                            'all',
                            controller,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterButton(
                            'Pending',
                            'pending',
                            controller,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildFilterButton(
                            'Approved',
                            'approved',
                            controller,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // GestureDetector(
                        //   onTap: () {
                        //     controller.resetFilter();
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 12,
                        //       vertical: 8,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey.shade800,
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(
                        //         color: Colors.grey.shade700,
                        //         width: 0.5,
                        //       ),
                        //     ),
                        //     child: const Icon(
                        //       Icons.refresh,
                        //       color: AppColors.primaryText,
                        //       size: 18,
                        //     ),
                        //   ),
                        // ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Events list with pull-to-refresh
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchEvents();
                },
                color: AppColors.primaryGreen,
                backgroundColor: Colors.grey.shade900,
                child: Obx(() {
                  if (controller.isLoading.value && controller.filteredEvents.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGreen,
                        ),
                      ),
                    );
                  }

                  if (controller.filteredEvents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.event_note,
                            size: 48,
                            color: AppColors.secondaryText,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No events found',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: controller.filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = controller.filteredEvents[index];
                      return EventCard(
                        event: event,
                        onAccept: () {
                          controller.acceptEvent(event.id);
                        },
                        onReject: () {
                          controller.rejectEvent(event.id);
                        },
                        isLoading: controller.isLoading.value,
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildFilterButton(
    String label,
    String filterValue,
    EventsController controller,
  ) {
    return GestureDetector(
      onTap: () {
        controller.applyFilter(filterValue);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: controller.selectedFilter.value == filterValue
              ? AppColors.primaryGreen
              : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.selectedFilter.value == filterValue
                ? AppColors.primaryGreen
                : Colors.grey.shade700,
            width: 0.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: controller.selectedFilter.value == filterValue
                ? AppColors.primaryText
                : AppColors.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
