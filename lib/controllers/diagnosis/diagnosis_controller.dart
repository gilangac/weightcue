import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/constant/code_diagnosis.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/models/question_model.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:intl/intl.dart';
import 'package:weightcue_mobile/services/service_utils.dart';

class DiagnosisController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference question =
      FirebaseFirestore.instance.collection('gejala_obesitas');
  CollectionReference riwayatDiagnosis =
      FirebaseFirestore.instance.collection('riwayat_diagnosis');
  FirebaseAuth auth = FirebaseAuth.instance;

  var initialCode = KG0.obs;
  var listQuestion = <QuestionModel>[].obs;
  var listQuestionFilter = <QuestionModel>[].obs;
  var listRoomQuestion = <QuestionModel>[].obs;
  var answerGroup = <RxInt>[].obs;
  var answerGroupRoom = <RxInt>[].obs;
  var isLoading = true.obs;
  var resultDiagnosis = '';
  var descriptionResultDiagnosis = '';
  var roomDiagnosis = 0;
  var mapQuestion = [];

  var listRoom1 = [KG2, KG7, KG17, KG9, KG11, KG20];
  var listRoom2 = [KG19, KG25, KG30, KG14, KG22, KG13];
  var listRoom3 = [KG31, KG32, KG34, KG1, KG15, KG16];
  var listRoom4 = [KG10, KG18, KG33, KG22, KG23, KG39];
  var listRoom5 = [KG35, KG36, KG37, KG43, KG18, KG28];
  var listRoom6 = [KG39, KG40, KG18, KG1, KG15, KG43];

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
    listRoomQuestion.clear();

    if (initialCode.value == KG0) {
      mapQuestion.add({'key': KG0, 'answer': value});
      switch (value) {
        case 1:
          initialCode.value = KG3;
          answerGroup[0].value = 2;
          break;
        default:
          resultDiagnosis = TIDAK_OBESITAS;
          Get.toNamed(AppPages.RESULT_DIAGNOSIS);
          onSendDataDiagnosis();
          break;
      }
    } else if (initialCode.value == KG3) {
      mapQuestion.add({'key': KG3, 'answer': value});
      switch (value) {
        case 1:
          answerGroup[0].value = 2;
          listRoom1.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 1;
          Get.toNamed(AppPages.ROOM_DIAGNOSIS);
          break;
        default:
          initialCode.value = KG4;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG4) {
      mapQuestion.add({'key': KG4, 'answer': value});
      switch (value) {
        case 1:
          log('masuk room 2');
          listRoom2.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 2;
          Get.toNamed(AppPages.ROOM_DIAGNOSIS);
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG6;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG6) {
      mapQuestion.add({'key': KG6, 'answer': value});
      switch (value) {
        case 1:
          log('masuk room 3');
          listRoom3.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 3;
          Get.toNamed(AppPages.ROOM_DIAGNOSIS);
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG12;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG12) {
      mapQuestion.add({'key': KG12, 'answer': value});
      switch (value) {
        case 1:
          log('masuk room 4');
          listRoom4.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 4;
          Get.toNamed(AppPages.ROOM_DIAGNOSIS);
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG8;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG8) {
      mapQuestion.add({'key': KG8, 'answer': value});
      switch (value) {
        case 1:
          log('masuk room 5');
          roomDiagnosis = 5;
          listRoom5.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          Get.toNamed(AppPages.ROOM_DIAGNOSIS);
          answerGroup[0].value = 2;
          break;
        default:
          initialCode.value = KG26;
          answerGroup[0].value = 2;
          break;
      }
    } else if (initialCode.value == KG26) {
      mapQuestion.add({'key': KG26, 'answer': value});
      switch (value) {
        case 1:
          log('masuk room 6');
          roomDiagnosis = 6;
          listRoom6.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          Get.toNamed(AppPages.ROOM_DIAGNOSIS);
          answerGroup[0].value = 2;
          break;
        default:
          log('masuk room 1');
          listRoom1.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          Get.toNamed(AppPages.ROOM_DIAGNOSIS);
          answerGroup[0].value = 2;
          break;
      }
    }

    print(mapQuestion);
    filterQuestion();
    getResultDiagnosis();
  }

  openDialog() {
    DialogHelper.showAlertDiagnosis(
        description:
            "Berikan jawaban gejala yang sesuai dengan keadaan anda !");
  }

  clearAnswerRoom() {
    answerGroupRoom.clear();
    answerGroupRoom.add(2.obs);
  }

  onSaveAnswer() {
    for (int i = 0; i < answerGroupRoom.length; i++) {
      mapQuestion.add({
        'key': listRoomQuestion[i].key,
        'answer': answerGroupRoom[i].value,
      });
    }
    print(mapQuestion);

    var q1 = answerGroupRoom[0].value == 0 ? false : true;
    var q2 = answerGroupRoom[1].value == 0 ? false : true;
    var q3 = answerGroupRoom[2].value == 0 ? false : true;
    var q4 = answerGroupRoom[3].value == 0 ? false : true;
    var q5 = answerGroupRoom[4].value == 0 ? false : true;
    var q6 = answerGroupRoom[5].value == 0 ? false : true;

    if (q1 && q2 && q3 && q4 && q5 && q6) {
      //1
      actionNext();
    } else if (q1 && q2 && q3 && q4 && q5 && !q6) {
      //2
      actionResult1();
    } else if (q1 && q2 && q3 && q4 && !q5 && q6) {
      //3
      actionResult1();
    } else if (q1 && q2 && q3 && !q4 && q5 && q6) {
      //4
      actionResult1();
    } else if (q1 && !q2 && q3 && q4 && q5 && q6) {
      //5
      actionResult2();
    } else if (!q1 && q2 && q3 && q4 && q5 && q6) {
      //6
      actionResult2();
    } else if (q1 && q2 && q3 && q4 && !q5 && !q6) {
      //7
      actionResult1();
    } else if (q1 && q2 && q3 && !q4 && q5 && !q6) {
      //8
      actionResult1();
    } else if (q1 && q2 && !q3 && q4 && q5 && q6) {
      //9
      actionResult2();
    } else if (!q1 && q2 && q3 && q4 && q5 && !q6) {
      //10
      actionNext();
    } else if (q1 && q2 && q3 && !q4 && !q5 && q6) {
      //11
      actionResult1();
    } else if (q1 && q2 && !q3 && q4 && q5 && !q6) {
      //12
      actionNext();
    } else if (!q1 && q2 && q3 && q4 && !q5 && q6) {
      //13
      actionNext();
    } else if (q1 && !q2 && q3 && q4 && q5 && !q6) {
      //14
      actionNext();
    } else if (!q1 && q2 && q3 && !q4 && q5 && q6) {
      //15
      actionNext();
    } else if (q1 && q2 && !q3 && !q4 && q5 && q6) {
      //16
      actionNext();
    } else if (!q1 && q2 && !q3 && q4 && q5 && q6) {
      //17
      actionResult2();
    } else if (q1 && !q2 && q3 && q4 && !q5 && q6) {
      //18
      actionNext();
    } else if (!q1 && !q2 && q3 && q4 && q5 && q6) {
      //19
      actionResult2();
    } else if (q1 && !q2 && q3 && !q4 && q5 && q6) {
      //20
      actionNext();
    } else if (!q1 && !q2 && !q3 && q4 && q5 && q6) {
      //21
      actionResult2();
    } else if (q1 && !q2 && !q3 && q4 && q5 && q6) {
      //22
      actionResult2();
    } else if (!q1 && !q2 && q3 && q4 && q5 && !q6) {
      //23
      actionResult2();
    } else if (q1 && q2 && !q3 && q4 && !q5 && q6) {
      //24
      actionNext();
    } else if (!q1 && q2 && q3 && q4 && q5 && !q6) {
      //25
      actionNext();
    } else if (q1 && !q2 && q3 && !q4 && !q5 && q6) {
      //26
      actionResult1();
    } else if (!q1 && q2 && q3 && !q4 && q5 && !q6) {
      //27
      actionResult1();
    } else if (q1 && q2 && !q3 && q4 && !q5 && !q6) {
      //28
      actionResult1();
    } else if (!q1 && q2 && q3 && q4 && !q5 && !q6) {
      //29
      actionResult1();
    } else if (q1 && !q2 && !q3 && q4 && q5 && !q6) {
      //30
      actionResult2();
    } else if (!q1 && !q2 && q3 && !q4 && q5 && q6) {
      //31
      actionResult2();
    } else if (q1 && !q2 && !q3 && !q4 && q5 && q6) {
      //32
      actionResult2();
    } else if (!q1 && q2 && !q3 && q4 && !q5 && q6) {
      //33
      actionResult2();
    } else if (q1 && q2 && !q3 && !q4 && !q5 && q6) {
      //34
      actionResult1();
    } else if (!q1 && q2 && !q3 && !q4 && q5 && q6) {
      //35
      actionResult2();
    } else if (q1 && !q2 && !q3 && q4 && !q5 && q6) {
      //36
      actionResult2();
    } else if (!q1 && !q2 && !q3 && q4 && q5 && !q6) {
      //37
      actionResult2();
    } else if (q1 && !q2 && !q3 && !q4 && !q5 && q6) {
      //38
      actionNext();
    } else if (!q1 && q2 && !q3 && !q4 && !q5 && q6) {
      //39
      actionNext();
    } else if (q1 && !q2 && !q3 && !q4 && q5 && !q6) {
      //40
      actionNext();
    } else if (!q1 && !q2 && q3 && !q4 && !q5 && q6) {
      //41
      actionNext();
    } else if (!q1 && q2 && q3 && !q4 && !q5 && q6) {
      //42
      actionResult1();
    } else if (q1 && !q2 && !q3 && q4 && !q5 && !q6) {
      //43
      actionNext();
    } else if (!q1 && !q2 && !q3 && !q4 && q5 && q6) {
      //44
      actionResult2();
    } else if (q1 && !q2 && !q3 && !q4 && !q5 && !q6) {
      //45
      actionResult1();
    } else if (!q1 && q2 && !q3 && !q4 && q5 && q6) {
      //46
      actionResult2();
    } else if (q1 && q2 && !q3 && !q4 && !q5 && !q6) {
      //47
      actionResult1();
    } else if (!q1 && !q2 && !q3 && q4 && !q5 && q6) {
      //48
      actionResult2();
    } else if (q1 && !q2 && !q3 && q4 && q5 && !q6) {
      //49
      actionResult2();
    } else if (!q1 && q2 && !q3 && q4 && q5 && !q6) {
      //50
      actionResult2();
    } else if (!q1 && q2 && !q3 && !q4 && !q5 && !q6) {
      //51
      actionResult1();
    } else if (q1 && q2 && !q3 && !q4 && q5 && q6) {
      //52
      actionNext();
    } else if (!q1 && !q2 && q3 && !q4 && q5 && !q6) {
      //53
      actionNext();
    } else if (q1 && !q2 && !q3 && q4 && q5 && q6) {
      //54
      actionResult2();
    } else if (!q1 && !q2 && !q3 && q4 && q5 && q6) {
      //55
      actionResult2();
    } else if (q1 && !q2 && !q3 && q4 && !q5 && q6) {
      //56
      actionResult2();
    } else if (!q1 && q2 && q3 && q4 && !q5 && !q6) {
      //57
      actionResult1();
    } else if (!q1 && q2 && q3 && !q4 && q5 && !q6) {
      //58
      actionResult1();
    } else if (q1 && q2 && !q3 && q4 && q5 && !q6) {
      //59
      actionNext();
    } else if (!q1 && !q2 && q3 && q4 && !q5 && q6) {
      //60
      actionResult2();
    } else if (q1 && !q2 && !q3 && q4 && q5 && q6) {
      //61
      actionResult2();
    } else if (!q1 && !q2 && q3 && q4 && q5 && q6) {
      //62
      actionResult2();
    } else if (q1 && !q2 && !q3 && !q4 && !q5 && q6) {
      //63
      actionNext();
    } else if (!q1 && !q2 && !q3 && !q4 && !q5 && !q6) {
      listRoomQuestion.clear();
      answerGroupRoom.clear();
      switch (roomDiagnosis) {
        case 1:
          listRoom2.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 2;
          break;
        case 2:
          listRoom3.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 3;
          break;
        case 3:
          listRoom4.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 4;
          break;
        case 4:
          listRoom5.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 5;
          break;
        case 5:
          listRoom6.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 6;
          break;
        case 6:
          listRoom1.forEach((element) {
            listRoomQuestion
                .add(listQuestion.where((p0) => p0.key == element).first);
          });
          roomDiagnosis = 1;
          break;
        default:
          break;
      }
      List.generate(listRoomQuestion.length, (index) {
        answerGroupRoom.addAll([2.obs]);
      });
      Get.offNamed(AppPages.ROOM_DIAGNOSIS);
    }
  }

  actionNext() {
    clearAnswerRoom();
    listRoomQuestion.clear();
    switch (roomDiagnosis) {
      case 1:
        listRoomQuestion.add(listQuestion.where((p0) => p0.key == KG30).first);
        break;
      case 2:
        listRoomQuestion.add(listQuestion.where((p0) => p0.key == KG41).first);
        break;
      case 3:
        listRoomQuestion.add(listQuestion.where((p0) => p0.key == KG30).first);
        break;
      case 4:
        listRoomQuestion.add(listQuestion.where((p0) => p0.key == KG35).first);
        break;
      case 5:
        listRoomQuestion.add(listQuestion.where((p0) => p0.key == KG33).first);
        break;
      case 6:
        listRoomQuestion.add(listQuestion.where((p0) => p0.key == KG42).first);
        break;
      default:
        break;
    }
    Get.toNamed(AppPages.ROOM_DIAGNOSIS);
  }

  actionResult1() {
    switch (roomDiagnosis) {
      case 1:
        resultDiagnosis = APEL;
        break;
      case 2:
        resultDiagnosis = APEL;
        break;
      case 3:
        resultDiagnosis = APEL;
        break;
      case 4:
        resultDiagnosis = GENOID;
        break;
      case 5:
        resultDiagnosis = GENOID;
        break;
      case 6:
        resultDiagnosis = HYPERPLASTIC;
        break;
      default:
        break;
    }
    Get.toNamed(AppPages.RESULT_DIAGNOSIS);
    onSendDataDiagnosis();
  }

  actionResult2() {
    switch (roomDiagnosis) {
      case 1:
        resultDiagnosis = GENOID;
        break;
      case 2:
        resultDiagnosis = HYPERTROPIC;
        break;
      case 3:
        resultDiagnosis = HYPERPLASTIC;
        break;
      case 4:
        resultDiagnosis = HYPERTROPIC;
        break;
      case 5:
        resultDiagnosis = HYPERPLASTIC;
        break;
      case 6:
        resultDiagnosis = HYPERPLASTIC;
        break;
      default:
        break;
    }
    Get.toNamed(AppPages.RESULT_DIAGNOSIS);
    onSendDataDiagnosis();
  }

  onCheckNext() {
    switch (listRoomQuestion[0].key) {
      case KG30:
        onAddToMap(KG30, answerGroupRoom[0].value);
        if (answerGroupRoom[0].value == 0) {
          resultDiagnosis = roomDiagnosis == 1 ? GENOID : HYPERPLASTIC;
        } else {
          resultDiagnosis = APEL;
        }
        Get.offNamed(AppPages.RESULT_DIAGNOSIS);
        break;
      case KG41:
        onAddToMap(KG41, answerGroupRoom[0].value);
        if (answerGroupRoom[0].value == 0) {
          resultDiagnosis = HYPERPLASTIC;
        } else {
          resultDiagnosis = APEL;
        }
        Get.offNamed(AppPages.RESULT_DIAGNOSIS);
        break;
      case KG35:
        onAddToMap(KG35, answerGroupRoom[0].value);
        if (answerGroupRoom[0].value == 0) {
          resultDiagnosis = HYPERTROPIC;
        } else {
          resultDiagnosis = GENOID;
        }
        Get.offNamed(AppPages.RESULT_DIAGNOSIS);
        break;
      case KG33:
        onAddToMap(KG33, answerGroupRoom[0].value);
        if (answerGroupRoom[0].value == 0) {
          resultDiagnosis = HYPERPLASTIC;
        } else {
          resultDiagnosis = GENOID;
        }
        Get.offNamed(AppPages.RESULT_DIAGNOSIS);
        break;
      case KG42:
        onAddToMap(KG42, answerGroupRoom[0].value);
        if (answerGroupRoom[0].value == 0) {
          resultDiagnosis = HYPERPLASTIC;
        } else {
          resultDiagnosis = HYPERTROPIC;
        }
        Get.offNamed(AppPages.RESULT_DIAGNOSIS);
        break;
      default:
    }
    getResultDiagnosis();
    onSendDataDiagnosis();
  }

  onAddToMap(String key, int value) {
    mapQuestion.add({
      'key': key,
      'answer': value,
    });

    print(mapQuestion);
  }

  getResultDiagnosis() {
    switch (resultDiagnosis) {
      case TIDAK_OBESITAS:
        descriptionResultDiagnosis =
            'Anda saat ini tidak mengalami Obesitas, Sebaiknya anda tetap menjaga berat badan ideal agar terhindar dari berbagai macam penyakit degeneratif yang berbahaya';
        break;
      case APEL:
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Apel. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case GENOID:
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Genoid. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case HYPERTROPIC:
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Hypertropic. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      case HYPERPLASTIC:
        descriptionResultDiagnosis =
            'Anda mengalami obesitas tipe Hyperplastic. Jika Anda khawatir tentang berat badan atau risiko kesehatan Anda, sebaiknya berkonsultasi dengan dokter atau ahli gizi untuk mendapatkan saran yang tepat.';
        break;
      default:
        descriptionResultDiagnosis = '';
        break;
    }
  }

  onSendDataDiagnosis() async {
    print("DATA SENDED");
    String idDiagnosis = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        ServiceUtils.randomString(4);
    final dateNow = DateTime.now();
    try {
      var mapQuestionEncoded = jsonEncode(mapQuestion);
      inspect(mapQuestionEncoded);
      print("==========================");
      inspect(jsonDecode(mapQuestionEncoded));
      var body = {
        "idDiagnosis": idDiagnosis,
        "idUser": auth.currentUser?.uid,
        "result": resultDiagnosis,
        "data": mapQuestionEncoded,
        "date": dateNow,
      };
      print(body);
      await riwayatDiagnosis.doc(idDiagnosis).set({
        "idDiagnosis": idDiagnosis,
        "idUser": auth.currentUser?.uid,
        "result": resultDiagnosis,
        "data": mapQuestionEncoded,
        "date": dateNow,
      });
    } catch (e) {
      print(e);
    }
  }
}
