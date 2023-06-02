// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class SnackBarHelper {
  static showError({required String description}) {
    Get.showSnackbar(
      GetBar(
        icon: const Icon(Feather.alert_circle, color: Colors.white),
        message: description,
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        borderRadius: 12,
      ),
    );
  }

  static showSucces({required String description, SnackPosition? position}) {
    Get.showSnackbar(
      GetBar(
        icon: const Icon(Feather.check_circle, color: Colors.white),
        backgroundColor: Colors.green.shade400,
        message: description,
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: position ?? SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        borderRadius: 12,
      ),
    );
  }
}
