// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/constant/code_diagnosis.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/models/question_model.dart';
import 'package:weightcue_mobile/routes/pages.dart';

class DiagnosisController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference question =
      FirebaseFirestore.instance.collection('gejala_obesitas');

  var initialCode = KG0.obs;
  var listQuestion = <QuestionModel>[].obs;
  var listQuestionFilter = <QuestionModel>[].obs;
  var listRoomQuestion = <QuestionModel>[].obs;
  var answerGroup = <RxInt>[].obs;
  var isLoading = true.obs;
  var resultDiagnosis = '';
  var descriptionResultDiagnosis = '';
  var roomDiagnosis = '';

  var listRoom1 = [KG2, KG7, KG17, KG9, KG11, KG20];

  @override
  void onInit() async {
    await onGetDataQuestion();
    openDialog();
    super.onInit();
  }

  Future<void> onGetDataQuestion() async {
    isLoading.value = true;
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
    filterQuestion();
    isLoading.value = false;
  }

  void filterQuestion() {
    listQuestionFilter.value = listQuestion
        .where((data) => data.key == initialCode.value)
        .toSet()
        .toList();
  }

  void onCheck(int value) {
    if (initialCode.value == KG0) {
      switch (value) {
        case 1:
          initialCode.value = KG3;
          answerGroup[0].value = 2;
          break;
        default:
          resultDiagnosis = 'Tidak Obesitas';
          Get.offNamed(AppPages.RESULT_DIAGNOSIS);
          break;
      }
    } else if (initialCode.value == KG3) {
      switch (value) {
        case 1:
          answerGroup[0].value = 2;
          listRoom1.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          Get.offNamed(AppPages.ROOM_DIAGNOSIS);
          break;
        default:
          initialCode.value = KG4;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG4) {
      switch (value) {
        case 1:
          log('masuk room 2');
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG6;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG6) {
      switch (value) {
        case 1:
          log('masuk room 3');
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG12;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG12) {
      switch (value) {
        case 1:
          log('masuk room 4');
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG8;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG8) {
      switch (value) {
        case 1:
          log('masuk room 5');
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG26;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG26) {
      switch (value) {
        case 1:
          log('masuk room 6');
          answerGroup[0].value = 2;
          break;
        default:
          log('masuk room 1');
          answerGroup[0].value = 2;
          break;
      }
    }

    filterQuestion();
    getResultDiagnosis();
  }

  openDialog() {
    DialogHelper.showAlertDiagnosis(
        description:
            "Berikan jawaban gejala yang sesuai dengan keadaan anda !");
  }

  onSaveAnswer() {}

  getResultDiagnosis() {
    switch (resultDiagnosis) {
      case 'Tidak Obesitas':
        descriptionResultDiagnosis =
            'Anda saat ini tidak mengalami Obesitas , Sebaiknya anda tetap menjaga berat badan ideal agar terhindar dari berbagai macam penyakit degeneratif yang berbahaya';
        break;
      case 'Apel':
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Apel. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case 'Genoid':
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Genoid. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case 'Hypertropic':
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Hypertropic. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case 'Hyperplastic':
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Hyperplastic. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      default:
        descriptionResultDiagnosis = '';
        break;
    }
  }
}
