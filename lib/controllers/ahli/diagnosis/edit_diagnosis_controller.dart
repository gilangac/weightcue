import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/constant/code_diagnosis.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/helpers/snackbar_helper.dart';
import 'package:weightcue_mobile/models/question_model.dart';

class EditDiagnosisController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference question =
      FirebaseFirestore.instance.collection('gejala_obesitas');

  var listQuestion = <QuestionModel>[].obs;
  var listApel = <QuestionModel>[].obs;
  var listGenoid = <QuestionModel>[].obs;
  var listHypertropic = <QuestionModel>[].obs;
  var listHyperplastic = <QuestionModel>[].obs;
  final questionFC = TextEditingController();
  final keyFC = TextEditingController();

  var apel = [
    KG2,
    KG7,
    KG17,
    KG30,
    KG19,
    KG25,
    KG30,
    KG41,
    KG1,
    KG31,
    KG32,
    KG34,
    KG3,
    KG4,
    KG6,
    KG12
  ];
  var genoid = [
    KG9,
    KG11,
    KG20,
    KG10,
    KG18,
    KG33,
    KG35,
    KG37,
    KG43,
    KG28,
    KG3,
    KG12,
    KG8
  ];
  var hypertropic = [
    KG14,
    KG13,
    KG22,
    KG23,
    KG39,
    KG40,
    KG18,
    KG42,
    KG4,
    KG12,
    KG26
  ];
  var hyperplastik = [KG1, KG15, KG16, KG43, KG18, KG28, KG6, KG8, KG26];
  var isLoading = true.obs;

  @override
  void onInit() {
    onGetDataQuestion();
    super.onInit();
  }

  Future<void> onGetDataQuestion() async {
    listQuestion.isNotEmpty ? listQuestion.clear() : null;
    listApel.isNotEmpty ? listApel.clear() : null;
    listGenoid.isNotEmpty ? listGenoid.clear() : null;
    listHypertropic.isNotEmpty ? listHypertropic.clear() : null;
    listHyperplastic.isNotEmpty ? listHyperplastic.clear() : null;

    await question.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        listQuestion.add(QuestionModel(
          key: data["key"],
          question: data["question"],
        ));
      });
      isLoading.value = false;
    }).onError((error, stackTrace) {});

    apel.forEach((element) {
      listApel.add(listQuestion.where((p0) => p0.key == element).first);
    });
    genoid.forEach((element) {
      listGenoid.add(listQuestion.where((p0) => p0.key == element).first);
    });
    hypertropic.forEach((element) {
      listHypertropic.add(listQuestion.where((p0) => p0.key == element).first);
    });
    hyperplastik.forEach((element) {
      listHyperplastic.add(listQuestion.where((p0) => p0.key == element).first);
    });

    isLoading.value = false;
  }

  onEditQuestion(String code) async {
    if (questionFC.text.isNotEmpty) {
      DialogHelper.showLoading();
      question
          .where('key', isEqualTo: code)
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((element) {
          question
              .doc(element.id)
              .update({"question": questionFC.text}).then((value) async {
            await onGetDataQuestion();
            Get.back();
            Get.back();
            SnackBarHelper.showSucces(
                description: "berhasil mengupdate diagnosis");
          });
        });
      });
    } else {
      SnackBarHelper.showError(
          description: 'Masukkan pertanyaan terlebih dahulu!');
    }
  }
}
