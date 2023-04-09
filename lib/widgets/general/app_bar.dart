// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/constant/colors.dart';

PreferredSizeWidget appBar(
    {required String title,
    bool canBack = true,
    Widget? customLeading,
    bool enableLeading = true,
    List<Widget>? actions,
    PreferredSizeWidget? bottom}) {
  return AppBar(
    backgroundColor: AppColors.primaryColor,
    centerTitle: GetPlatform.isAndroid ? false : true,
    elevation: 0.4,
    title: Text(title,
        style: GoogleFonts.poppins(
            color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600)),
    leading: canBack
        ? customLeading ??
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: GetPlatform.isAndroid
                  ? const Icon(
                      Feather.arrow_left,
                      color: AppColors.white,
                      size: 26,
                    )
                  : const Icon(Feather.chevron_left,
                      color: AppColors.white, size: 26),
            )
        : null,
    automaticallyImplyLeading: enableLeading ? true : false,
    actions: actions,
    bottom: bottom,
  );
}
