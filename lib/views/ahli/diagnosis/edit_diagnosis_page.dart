// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/ahli/diagnosis/edit_diagnosis_controller.dart';
import 'package:weightcue_mobile/models/question_model.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';

class EditDiagnosisPage extends StatelessWidget {
  EditDiagnosisController controller = Get.put(EditDiagnosisController());
  EditDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Edit Diagnosis",
      ),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    return Obx(() => SizedBox(
          height: Get.height,
          width: Get.width,
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  itemCount: controller.listQuestion.length,
                  itemBuilder: (context, index) {
                    return _cardArticle(index);
                  }),
        ));
  }

  Widget _cardArticle(int index) {
    QuestionModel data = controller.listQuestion[index];
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            Get.toNamed(AppPages.DETAIL_EDIT_DIAGNOSIS, arguments: data);
          },
          child: Container(
            width: Get.width,
            margin: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(width: 4, color: AppColors.backgroundColor),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
                color: AppColors.white),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
            child: Text('${data.question}',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ),
        Positioned(
            top: 18,
            right: 18,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppPages.DETAIL_EDIT_DIAGNOSIS, arguments: data);
              },
              child: const Icon(
                Icons.edit,
                size: 20,
                color: AppColors.primaryColor,
              ),
            ))
      ],
    );
  }
}
