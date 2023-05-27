// ignore_for_file: avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/constant/code_diagnosis.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/models/question_model.dart';
import 'package:weightcue_mobile/models/riwayat_diagnosis_model.dart';

class RiwayatDiagnosisController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference riwayatDiagnosis =
      FirebaseFirestore.instance.collection('riwayat_diagnosis');
  CollectionReference question =
      FirebaseFirestore.instance.collection('gejala_obesitas');

  var listDiagnosis = <RiwayatDiagnosisModel>[].obs;
  var listQuestion = <QuestionModel>[].obs;
  var listQuestionFilter = <QuestionModel>[].obs;
  var answerGroup = <RxInt>[].obs;
  var isLoading = true.obs;
  var listDetail = [].obs;
  var rawResult = [].obs;
  var descriptionResultDiagnosis = '';

  @override
  void onInit() async {
    await onGetDataQuestion();
    await onGetDataDiagnosis();
    super.onInit();
  }

  Future<void> onGetDataQuestion() async {
    listQuestion.isNotEmpty ? listQuestion.clear() : null;
    await question.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        listQuestion.add(QuestionModel(
          key: data["key"],
          question: data["question"],
        ));
      });
    }).onError((error, stackTrace) {});

    List.generate(listQuestion.length, (index) {
      answerGroup.addAll([2.obs]);
    });
  }

  void filterQuestion() {
    listQuestionFilter.clear();
    listDetail.forEach((element) {
      listQuestionFilter
          .add(listQuestion.where((p0) => p0.key == element).first);
    });
  }

  onGetDetail(RiwayatDiagnosisModel dataModel) {
    rawResult.clear();
    listDetail.clear();
    listQuestionFilter.clear();

    getResultDiagnosis(dataModel.result ?? '');
    rawResult.value = json.decode(dataModel.data ?? '');
    rawResult.forEach((element) {
      listDetail.add(element['key']);
    });
    filterQuestion();
  }

  Future<void> onGetDataDiagnosis() async {
    isLoading.value = true;
    listDiagnosis.isNotEmpty ? listDiagnosis.clear() : null;
    await riwayatDiagnosis
        .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        listDiagnosis.add(RiwayatDiagnosisModel(
          idDiagnosis: data["idDiagnosis"],
          data: data["data"],
          idUser: data["idUser"],
          result: data["result"],
          date: data["date"],
        ));
      });
    }).onError((error, stackTrace) {
      log(error.toString());
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });

    isLoading.value = false;
  }

  Future<void> onDeletePost(String idDiagnosis, {bool? isDetail}) async {
    DialogHelper.showLoading();
    riwayatDiagnosis.doc(idDiagnosis).get().then((value) async {
      await riwayatDiagnosis.doc(idDiagnosis).delete().then((_) {
        onGetDataDiagnosis();
        Get.back();
        if (isDetail == true) Get.back();
      });
    }).onError((error, stackTrace) {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  Future<void> onConfirmDelete(String idDiagnosis, {bool? isDetail}) async {
    await DialogHelper.showConfirm(
        title: "Hapus Riwayat Diagnosis",
        description: "Anda yakin akan menghapus riwayat Diagnosis ini?",
        titlePrimary: "Hapus",
        titleSecondary: "Batal",
        action: () async {
          Get.back();
          await onDeletePost(idDiagnosis, isDetail: isDetail);
        });
  }

  getResultDiagnosis(String resultDiagnosis) {
    switch (resultDiagnosis) {
      case TIDAK_OBESITAS:
        descriptionResultDiagnosis =
            'Pengguna saat ini tidak mengalami Obesitas, Sebaiknya Pengguna tetap menjaga berat badan ideal agar terhindar dari berbagai macam penyakit degeneratif yang berbahaya';
        break;
      case APEL:
        descriptionResultDiagnosis =
            'Pengguna mengalami obesitas tipe Apel. Jika Pengguna khawatir tentang berat badan atau risiko kesehatan Pengguna, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case GENOID:
        descriptionResultDiagnosis =
            'Pengguna mengalami obesitas tipe Genoid. Jika Pengguna khawatir tentang berat badan atau risiko kesehatan Pengguna, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case HYPERTROPIC:
        descriptionResultDiagnosis =
            'Pengguna mengalami obesitas tipe Hypertropic. Jika Pengguna khawatir tentang berat badan atau risiko kesehatan Pengguna, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case HYPERPLASTIC:
        descriptionResultDiagnosis =
            'Pengguna mengalami obesitas tipe Hyperplastic. Jika Pengguna khawatir tentang berat badan atau risiko kesehatan Pengguna, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      default:
        descriptionResultDiagnosis = '';
        break;
    }
  }
}
