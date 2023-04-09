import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';

class CalculatorBmiController extends GetxController {
  var isMaleType = true.obs;
  final weightFc = TextEditingController();
  final tallFc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var dataIdeal = [
    "Anda kekurangan berat badan.",
    "Anda memiliki berat badan ideal.",
    "Anda memiliki berat badan berlebih.",
    "Anda berada dalam kategori obesitas."
  ];

  void onCalculateBmi() {
    if (formKey.currentState!.validate()) {
      var weight = double.parse(weightFc.text);
      var tall = double.parse(tallFc.text) / 100;

      var bmi = weight / (tall * tall);
      var descriptionBmi = '';

      if (isMaleType.value) {
        if (bmi < 18.5) {
          descriptionBmi = dataIdeal[0];
        } else if (bmi >= 18.5 && bmi <= 25) {
          descriptionBmi = dataIdeal[1];
        } else if (bmi > 25 && bmi <= 30) {
          descriptionBmi = dataIdeal[2];
        } else if (bmi > 30) {
          descriptionBmi = dataIdeal[3];
        }
      } else {
        if (bmi < 17) {
          descriptionBmi = dataIdeal[0];
        } else if (bmi >= 17 && bmi <= 23) {
          descriptionBmi = dataIdeal[1];
        } else if (bmi > 23 && bmi <= 30) {
          descriptionBmi = dataIdeal[2];
        } else if (bmi > 30) {
          descriptionBmi = dataIdeal[3];
        }
      }

      DialogHelper.showResultBmi(
          title: bmi.toStringAsFixed(1), description: descriptionBmi);
    }
  }

  get isMale => isMaleType.value;
}
