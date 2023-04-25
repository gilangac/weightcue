// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/models/question_model.dart';

class DiagnosisController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference question =
      FirebaseFirestore.instance.collection('gejala_obesitas');

  var listQuestion = <QuestionModel>[].obs;
  var answerGroup = <RxInt>[].obs;
  var isLoading = true.obs;

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

    isLoading.value = false;
  }

  openDialog() {
    DialogHelper.showAlertDiagnosis(
        description:
            "Berikan jawaban gejala yang sesuai dengan keadaan anda !");
  }

  onSaveAnswer() {
    print(answerGroup.value);
  }
}
