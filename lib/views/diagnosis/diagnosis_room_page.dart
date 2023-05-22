import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/diagnosis/diagnosis_controller.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';

class DiagnosisRoomPage extends StatelessWidget {
  DiagnosisController diagnosisController = Get.find();
  DiagnosisRoomPage({Key? key}) : super(key: key);
  var isComplete = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Diagnosis Obesitas"),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    return Obx(() => SizedBox(
          height: Get.height,
          width: Get.width,
          child: diagnosisController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            itemCount:
                                diagnosisController.listRoomQuestion.length,
                            itemBuilder: (context, index) {
                              return _cardDiagnosis(index);
                            }),
                      ),
                    ),
                    _btnDiagnosis()
                  ],
                ),
        ));
  }

  Widget _cardDiagnosis(int index) {
    Rx<int> answer = 2.obs;
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(bottom: 10),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(diagnosisController.listRoomQuestion[index].question ?? '',
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w400,
              )),
          const SizedBox(
            height: 10,
          ),
          Obx(() => Column(
                children: [
                  RadioListTile(
                      title: Text("Ya",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                          )),
                      value: 1,
                      tileColor: AppColors.primaryColor,
                      activeColor: AppColors.primaryColor,
                      groupValue: diagnosisController.answerGroup[index].value,
                      onChanged: (value) {
                        diagnosisController.answerGroup[index].value =
                            int.parse(value.toString());
                        onValidationAnswer();
                      }),
                  RadioListTile(
                      title: Text("Tidak",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                          )),
                      value: 0,
                      tileColor: AppColors.primaryColor,
                      activeColor: AppColors.primaryColor,
                      groupValue: diagnosisController.answerGroup[index].value,
                      onChanged: (value) {
                        diagnosisController.answerGroup[index].value =
                            int.parse(value.toString());
                        onValidationAnswer();
                      }),
                ],
              ))
        ],
      ),
    );
  }

  void onValidationAnswer() {
    diagnosisController.answerGroup.forEach((value) {
      isComplete.value = true;
      if (value.value == 2) isComplete.value = false;
    });
  }

  Widget _btnDiagnosis() {
    return Container(
      width: Get.width,
      color: AppColors.backgroundColor,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Get.width * 0.1, vertical: 10),
        child: SizedBox(
          width: Get.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor, elevation: 0.1),
            onPressed: !isComplete.value
                ? null
                : () {
                    diagnosisController
                        .onCheck(diagnosisController.answerGroup[0].value);
                    // Get.offNamed(AppPages.RESULT_DIAGNOSIS);
                    // diagnosisController.onSaveAnswer();
                  },
            child: Text(
              'Lanjutkan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
