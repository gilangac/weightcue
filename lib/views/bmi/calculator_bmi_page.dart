// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/bmi/calculator_bmi_controller.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:weightcue_mobile/widgets/general/form_input.dart';

class CalculatorBmiPage extends StatelessWidget {
  CalculatorBmiPage({Key? key}) : super(key: key);
  CalculatorBmiController controller = Get.put(CalculatorBmiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Kalkulator BMI"),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    return SizedBox(
        height: Get.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                _gender(),
                SizedBox(
                  height: 20,
                ),
                formInput(
                    title: "Berat Badan (Kg)",
                    placeholder: "Kg",
                    controller: controller.weightFc,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    inputFormater: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      RegExp _numeric = RegExp(r'^-?[0-9]+$');

                      if (value == "") {
                        return 'Berat badan tidak boleh kosong';
                      } else if (!_numeric.hasMatch(value)) {
                        return 'TIdak boleh berisi selain angka';
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                formInput(
                    title: "Tinggi Badan (cm)",
                    placeholder: "cm",
                    controller: controller.tallFc,
                    inputType: TextInputType.number,
                    inputAction: TextInputAction.next,
                    inputFormater: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      RegExp _numeric = RegExp(r'^-?[0-9]+$');

                      if (value == "") {
                        return 'Tinggi badan tidak boleh kosong';
                      } else if (!_numeric.hasMatch(value)) {
                        return 'TIdak boleh berisi selain angka';
                      }
                    }),
                SizedBox(
                  height: 25,
                ),
                _btnCalculate()
              ],
            ),
          ),
        ));
  }

  Widget _gender() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.isMaleType.value = true,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: controller.isMale
                              ? AppColors.primaryColor
                              : AppColors.white),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white),
                  child: Center(
                    child: Opacity(
                      opacity: controller.isMale ? 1 : 0.2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4, color: AppColors.backgroundColor),
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.backgroundColor),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "assets/images/male.png",
                                ),
                              ),
                            ),
                          ),
                          Text("Pria",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                height: 1.5,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.isMaleType.value = false,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 4,
                          color: !controller.isMale
                              ? AppColors.primaryColor
                              : AppColors.white),
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white),
                  child: Center(
                    child: Opacity(
                      opacity: !controller.isMale ? 1 : 0.2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4, color: AppColors.backgroundColor),
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.backgroundColor),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "assets/images/female.png",
                                ),
                              ),
                            ),
                          ),
                          Text("Wanita",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                height: 1.5,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _btnCalculate() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: AppColors.primaryColor, elevation: 0.1),
        onPressed: () {
          controller.onCalculateBmi();
        },
        child: Text(
          'Hitung BMI',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
