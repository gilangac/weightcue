import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';

class ResultDiagnosisPage extends StatelessWidget {
  const ResultDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Hasil Diagnosis"),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Lottie.asset('assets/json/chechkup.json', width: Get.width * 0.8),
            Text(
                "Hasil Diagnosis sesuai dengan gejala yang telah terpilih adalah sebagai berikut :",
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(
              height: 10,
            ),
            Text(
                "Anda memiliki kelebihan berat badan yang berpotensi kearah obesitas, segera lakukan diet dengan olahraga secara teratur dan memakan makanan rendah karbohidrat",
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
      )),
    );
  }
}
