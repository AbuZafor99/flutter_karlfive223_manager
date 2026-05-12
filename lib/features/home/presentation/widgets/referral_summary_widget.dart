import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../controller/home_controller.dart';
import '../screens/referral_stats_screen.dart';

class ReferralSummaryWidget extends StatelessWidget {
  const ReferralSummaryWidget({super.key});

  Future<void> _showAddReferralPopup(BuildContext context) async {
    final controller = Get.find<HomeController>();
    final nameController = TextEditingController();
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.leagueBackgroundGrey,
              title: const Text(
                'Add Referral Person',
                style: TextStyle(color: Colors.white),
              ),
              content: TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Referral person name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryGreen),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          if (name.isEmpty) {
                            Get.snackbar(
                              'Validation',
                              'Please enter referral person name',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          setState(() {
                            isSubmitting = true;
                          });

                          final created = await controller.createReferralPerson(
                            name,
                          );

                          if (dialogContext.mounted) {
                            if (created) {
                              Navigator.of(dialogContext).pop();
                            } else {
                              setState(() {
                                isSubmitting = false;
                              });
                              Get.snackbar(
                                'Failed',
                                'Could not add referral person',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.black,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add as referral'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final bool isSmallScreen = MediaQuery.of(context).size.width < 350;

    return Obx(() {
      if (controller.referralSummaries.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            'No referral info available',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 24),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Referral Summary',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showAddReferralPopup(context),
                  child: const Text(
                    'Add Person',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 24),
            color: Colors.grey[900],
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: isSmallScreen ? 10 : 14,
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Person Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Invited',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(controller.referralSummaries.length, (index) {
            final item = controller.referralSummaries[index];
            final bool isEvenRow = index % 2 == 0;
            final Color bgColor = isEvenRow
                ? AppColors.primaryBackground
                : AppColors.gray;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (dialogContext) => ReferralStatsScreen(
                      referralId: item.id,
                      referralName: item.name,
                      asPopup: true,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 24,
                  ),
                  color: bgColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: isSmallScreen ? 10 : 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.joinedCount.toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}
