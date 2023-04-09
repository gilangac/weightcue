import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';

abstract class BottomSheetHelper {
  static showError(
      {required String title,
      required String description,
      String? textAction,
      void Function()? onAction}) {
    _bottomSheetContent(
        title, description, textAction, Category.error, onAction);
  }

  static showSuccess(
      {required String title,
      required String description,
      String? textAction,
      void Function()? onAction}) {
    _bottomSheetContent(
        title, description, textAction, Category.success, onAction);
  }

  static showStatusMessage(
      {required String title,
      required String description,
      String? textAction,
      void Function()? onAction}) {
    _bottomSheetContent(
        title, description, textAction, Category.statusMessage, onAction);
  }
}

void _bottomSheetContent(
    String title, String description, String? textAction, Category category,
    [void Function()? onAction]) {
  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Get.textTheme.headline5,
            ),
            const SizedBox(height: 40),
            (category == Category.statusMessage)
                ? SizedBox(
                    height: Get.height * 0.2,
                    child: Center(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Text(
                            description,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: AppColors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Image.asset(
                        (category == Category.success)
                            ? 'assets/images/notification_success.png'
                            : 'assets/images/notification_failed.png',
                        height: 90,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
            const SizedBox(height: 45),
            SizedBox(
              width: double.infinity,
              child: GetPlatform.isIOS
                  ? CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(12),
                      onPressed: onAction ?? _onPressCTA,
                      child: Text(textAction ?? 'Oke'),
                    )
                  : ElevatedButton(
                      onPressed: onAction ?? _onPressCTA,
                      child: Text(textAction ?? 'Oke'),
                    ),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
  );
}

_onPressCTA() {
  if (Get.isBottomSheetOpen!) Get.back();
  Get.back();
}

enum Category { success, error, statusMessage }
