// ignore_for_file: avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/models/riwayat_bmi_model.dart';

class RiwayatDiagnosisController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference riwayatBmi =
      FirebaseFirestore.instance.collection('riwayat_diagnosis');

  var listBmi = <RiwayatBmiModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    onGetDataBmi();
    super.onInit();
  }

  Future<void> onGetDataBmi() async {
    isLoading.value = true;
    listBmi.isNotEmpty ? listBmi.clear() : null;
    await riwayatBmi
        .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        listBmi.add(RiwayatBmiModel(
          idBmi: data["idBmi"],
          bmi: data["bmi"],
          idUser: data["idUser"],
          keterangan: data["keterangan"],
          gender: data["gender"],
          date: data["date"],
        ));
      });
    }).onError((error, stackTrace) {
      log(error.toString());
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });

    isLoading.value = false;
  }

  onDeletePost(String idBmi) async {
    DialogHelper.showLoading();
    riwayatBmi.doc(idBmi).get().then((value) async {
      await riwayatBmi.doc(idBmi).delete().then((_) {
        onGetDataBmi();
        Get.back();
      });
    }).onError((error, stackTrace) {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  void onConfirmDelete(String idBmi) {
    DialogHelper.showConfirm(
        title: "Hapus Riwayat BMI",
        description: "Anda yakin akan menghapus riwayat BMI ini?",
        titlePrimary: "Hapus",
        titleSecondary: "Batal",
        action: () {
          Get.back();
          onDeletePost(idBmi);
        });
  }
}
