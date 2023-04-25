// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:intl/intl.dart';
import 'package:weightcue_mobile/services/service_utils.dart';

class CalculatorBmiController extends GetxController {
  CollectionReference riwayatBmi =
      FirebaseFirestore.instance.collection('riwayat_bmi');
  FirebaseAuth auth = FirebaseAuth.instance;

  var isMaleType = true.obs;
  final weightFc = TextEditingController();
  final tallFc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var keterangan = '';
  var bmi = 0.0;
  var dataIdeal = [
    "Anda kekurangan berat badan.",
    "Anda memiliki berat badan ideal.",
    "Anda memiliki berat badan berlebih.",
    "Anda berada dalam kategori obesitas."
  ];
  var dataIdealKeterangan = [
    "Kekurangan Berat Badan",
    "Berat Badan Ideal",
    "Berat Badan Berlebih",
    "Obesitas"
  ];

  void onCalculateBmi() {
    if (formKey.currentState!.validate()) {
      var weight = double.parse(weightFc.text);
      var tall = double.parse(tallFc.text) / 100;

      bmi = weight / (tall * tall);
      var descriptionBmi = '';

      if (isMaleType.value) {
        if (bmi < 18.5) {
          descriptionBmi = dataIdeal[0];
          keterangan = dataIdealKeterangan[0];
        } else if (bmi >= 18.5 && bmi <= 25) {
          descriptionBmi = dataIdeal[1];
          keterangan = dataIdealKeterangan[1];
        } else if (bmi > 25 && bmi <= 30) {
          descriptionBmi = dataIdeal[2];
          keterangan = dataIdealKeterangan[2];
        } else if (bmi > 30) {
          descriptionBmi = dataIdeal[3];
          keterangan = dataIdealKeterangan[3];
        }
      } else {
        if (bmi < 17) {
          descriptionBmi = dataIdeal[0];
          keterangan = dataIdealKeterangan[0];
        } else if (bmi >= 17 && bmi <= 23) {
          descriptionBmi = dataIdeal[1];
          keterangan = dataIdealKeterangan[1];
        } else if (bmi > 23 && bmi <= 30) {
          descriptionBmi = dataIdeal[2];
          keterangan = dataIdealKeterangan[2];
        } else if (bmi > 30) {
          descriptionBmi = dataIdeal[3];
          keterangan = dataIdealKeterangan[3];
        }
      }

      DialogHelper.showResultBmi(
          title: bmi.toStringAsFixed(1), description: descriptionBmi);
      onSendDataBmi();
    }
  }

  onSendDataBmi() async {
    String idBmi = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        ServiceUtils.randomString(4);
    final dateNow = DateTime.now();
    try {
      await riwayatBmi.doc(idBmi).set({
        "idBmi": idBmi,
        "bmi": bmi.toStringAsFixed(1),
        "gender": isMaleType.value ? 'Laki - laki' : 'Perempuan',
        "idUser": auth.currentUser?.uid,
        "keterangan": keterangan,
        "date": dateNow,
      });
    } catch (e) {
      print(e);
    }
  }

  get isMale => isMaleType.value;
}
