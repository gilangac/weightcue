import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';

Widget weightCueLogo({double? size}) {
  return Center(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Weight",
        style: GoogleFonts.poppins(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: size ?? 28),
      ),
      Text(
        "Cue",
        style: GoogleFonts.poppins(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.w600,
            fontSize: size ?? 28),
      ),
    ],
  ));
}
