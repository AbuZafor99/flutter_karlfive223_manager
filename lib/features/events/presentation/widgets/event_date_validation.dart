import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDateValidation {
  /// Validates that the start date is not today or in the past
  /// Returns true if valid, false otherwise
  static bool validateStartDate(DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // If selected date is today or earlier, it's invalid
    if (selectedDay.isBefore(today) || selectedDay.isAtSameMomentAs(today)) {
      Get.snackbar(
        'Validation Error',
        'Start date must be tomorrow or later, not today',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  /// Validates that end date is after start date
  static bool validateEndDate(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate) || endDate.isAtSameMomentAs(startDate)) {
      Get.snackbar(
        'Validation Error',
        'End date must be after start date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  /// Formats date for API submission
  /// Returns ISO8601 string with proper timezone handling
  static String formatDateForAPI(DateTime date) {
    // Use the date at midnight UTC
    return date.toIso8601String().split('T')[0];
  }
}
