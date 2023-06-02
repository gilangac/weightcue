import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tidak ada data',
          style: GoogleFonts.poppins(
            fontSize: 16,
            height: 1.5,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
