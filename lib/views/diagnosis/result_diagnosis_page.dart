// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:weightcue_mobile/constant/code_diagnosis.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/diagnosis/diagnosis_controller.dart';
import 'package:weightcue_mobile/controllers/home/home_controller.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';

class ResultDiagnosisPage extends StatelessWidget {
  ResultDiagnosisPage({Key? key}) : super(key: key);
  DiagnosisController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.getResultDiagnosis();
    return WillPopScope(
      onWillPop: () async {
        return await Get.offAllNamed(AppPages.HOME);
      },
      child: Scaffold(
        appBar: appBar(
            title: "Hasil Diagnosis",
            enableLeading: true,
            customLeading: GestureDetector(
                onTap: () => Get.offAllNamed(AppPages.HOME),
                child: const Icon(
                  Feather.arrow_left,
                  color: AppColors.white,
                  size: 26,
                ))),
        body: _body(),
        backgroundColor: AppColors.backgroundColor,
      ),
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
            GestureDetector(
                onTap: () {},
                child: Lottie.asset('assets/json/chechkup.json',
                    width: Get.width * 0.8)),
            Text(
                "Hasil Diagnosis sesuai dengan gejala yang telah anda pilih adalah sebagai berikut :",
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(
              height: 10,
            ),
            if (controller.resultDiagnosis != TIDAK_OBESITAS)
              Obx(() => SizedBox(
                    width: Get.width,
                    height: Get.height * 0.23,
                    child: PieChart(
                      dataMap: controller.mapDiagnosis.value,
                      animationDuration: const Duration(milliseconds: 1000),
                      chartLegendSpacing: 32,
                      colorList: const <Color>[
                        AppColors.red,
                        AppColors.green2,
                        AppColors.yellow,
                        AppColors.blue,
                      ],
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      ringStrokeWidth: 32,
                      centerText: "Diagnosis",
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        chartValueBackgroundColor: AppColors.white,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                        decimalPlaces: 0,
                      ),
                    ),
                  )),
            if (controller.resultDiagnosis == TIDAK_OBESITAS)
              Column(
                children: [
                  Text('Anda saat ini ',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w400,
                      )),
                  Text("Tidak Mengalami Obesitas",
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            if (controller.resultDiagnosis != TIDAK_OBESITAS)
              Column(
                children: [
                  Text('Anda saat ini mengalami : ',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w400,
                      )),
                  Text("Obesitas Tipe " + controller.resultDiagnosis,
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            const SizedBox(
              height: 10,
            ),
            Text(controller.descriptionResultDiagnosis,
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 20,
            ),
            _listAction2(
                icon: Icons.whatsapp,
                title: "Chat dengan ahli",
                path: AppPages.HOME,
                type: "about"),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }

  Widget _listAction2({
    IconData? icon,
    required String title,
    String? path,
    String? type,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: Get.width,
        child: Material(
          color: Colors.grey.shade300,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (path != null) {
                if (type != 'about') {
                  Get.toNamed(path);
                }
              }
              if (type == 'about') {
                HomeController homeController = Get.find();
                homeController
                    .onLaunchUrl("https://wa.me/+6285231169020?text=");
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                minLeadingWidth: 0,
                leading: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.green),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    color: AppColors.white,
                  ),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey),
                ),
                trailing: const Icon(Feather.chevron_right),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
