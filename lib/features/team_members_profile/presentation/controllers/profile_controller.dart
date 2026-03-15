import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/services/auth_storage_service.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/repo/user_profile_repo.dart';

class ProfileController extends GetxController {
  final UserProfileRepo repository;
  final AuthStorageService authStorageService;

  ProfileController({
    required this.repository,
    required this.authStorageService,
  });

  final Rxn<UserProfileModel> profile = Rxn<UserProfileModel>();
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final result = await repository.getProfile();
      result.fold(
        (failure) {
          error.value = failure.message;
        },
        (success) {
          profile.value = success.data;
        },
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      error.value = null;

      // Get user ID from secure storage
      final userId = await authStorageService.getUserId();
      if (userId == null || userId.isEmpty) {
        Get.snackbar(
          'Error',
          'User ID not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      // Call delete account API
      final result = await repository.deleteAccount(userId);

      result.fold(
        (failure) {
          isLoading.value = false;
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (success) async {
          // Clear auth data first
          await authStorageService.clearAuthData();

          // Navigate to login and pass success flag
          Get.offAll(
            () => const LoginScreen(),
            predicate: (route) => false, // This removes all previous routes
          );

          // Show success message after a short delay
          await Future.delayed(const Duration(milliseconds: 300));
          Get.snackbar(
            'Success',
            'User deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
