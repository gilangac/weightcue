import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/helpers/snackbar_helper.dart';
import 'package:weightcue_mobile/models/question_model.dart';

class EditDiagnosisController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference question =
      FirebaseFirestore.instance.collection('gejala_obesitas');

  var listQuestion = <QuestionModel>[].obs;
  final questionFC = TextEditingController();
  final keyFC = TextEditingController();
  var isLoading = true.obs;

  @override
  void onInit() {
    onGetDataQuestion();
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
      isLoading.value = false;
    }).onError((error, stackTrace) {});

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
