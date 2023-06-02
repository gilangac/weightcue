// ignore_for_file: must_be_immutable, unnecessary_null_comparison, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/ahli/diagnosis/edit_diagnosis_controller.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:weightcue_mobile/widgets/general/form_input.dart';

import '../../../models/question_model.dart';

class DetailEditDiagnosisPage extends StatelessWidget {
  EditDiagnosisController controller = Get.find();
  DetailEditDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Edit Artikel"),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    QuestionModel data = Get.arguments;
    controller.keyFC.text = data.key ?? '';
    controller.questionFC.text = data.question ?? '';

    return Obx(() => SizedBox(
        height: Get.height,
        width: Get.width,
        child: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              formInput(
                                  title: "Kode",
                                  placeholder: "Kode",
                                  enabled: false,
                                  controller: controller.keyFC,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.next,
                                  validator: (val) {}),
                              const SizedBox(
                                height: 20,
                              ),
                              formInput(
                                  title: "Diagnosis / Pertanyaan",
                                  placeholder: "Diagnosis / Pertanyaan",
                                  controller: controller.questionFC,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.done,
                                  maxLines: 6,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Masukkan pertanyaan terlebih dahulu';
                                    }
                                  }),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _btnAddArticle()
                ],
              )));
  }

  Widget _btnAddArticle() {
    QuestionModel data = Get.arguments;
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Get.width * 0.1, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor, elevation: 0.1),
          onPressed: () {
            controller.onEditQuestion(data.key ?? '');
          },
          child: Text(
            'Simpan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
