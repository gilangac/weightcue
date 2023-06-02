// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

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
            'Sebaiknya anda tetap menjaga berat badan ideal agar terhindar dari berbagai macam penyakit degeneratif yang berbahaya';
        break;
      case APEL:
        descriptionResultDiagnosis =
            '''Obesitas tipe apel, juga dikenal sebagai obesitas sentral atau obesitas abdominal, mengacu pada penumpukan lemak terutama di area perut dan dada, menciptakan bentuk tubuh yang mirip dengan apel. Ini berbeda dengan obesitas tipe pir atau obesitas perifer, di mana lemak lebih terkonsentrasi di area pinggul, paha, dan pantat.
                \n*>Penyebab Obesitas Tipe Apel:
1.  Faktor Genetik: Beberapa orang memiliki kecenderungan genetik untuk mengembangkan obesitas tipe apel.
2.  Pola Makan Tidak Sehat: Konsumsi makanan tinggi lemak jenuh, gula, dan makanan olahan dapat menyebabkan peningkatan berat badan dan obesitas tipe apel.
3.  Kurangnya Aktivitas Fisik: Gaya hidup yang kurang aktif dan kebiasaan duduk yang berkepanjangan dapat berkontribusi pada penumpukan lemak di area perut.
4.  Stres: Stres kronis dapat menyebabkan pelepasan hormon kortisol yang dapat memengaruhi penimbunan lemak di area perut.
\n*>Solusi untuk Obesitas Tipe Apel:
1.  Pola Makan Sehat: Fokus pada pola makan yang seimbang dengan makanan yang rendah lemak jenuh, gula tambahan, dan tinggi serat. Sertakan banyak buah, sayuran, biji-bijian, dan protein rendah lemak dalam diet Anda.
2.  Aktivitas Fisik: Lakukan latihan aerobik seperti berjalan cepat, berlari, bersepeda, atau berenang secara teratur untuk membantu membakar lemak tubuh. Latihan kekuatan juga penting untuk membantu memperkuat otot dan meningkatkan metabolisme.
3.  Mengelola Stres: Temukan cara-cara yang efektif untuk mengurangi stres seperti meditasi, yoga, atau kegiatan yang menenangkan pikiran Anda. Ini dapat membantu mengurangi produksi kortisol dan mengurangi keinginan makan berlebihan.
4.  Tidur yang Cukup: Pastikan Anda mendapatkan tidur yang cukup setiap malam. Kurang tidur dapat mengganggu keseimbangan hormon dan berkontribusi pada peningkatan berat badan.
5.  Hindari Konsumsi Alkohol Berlebihan: Alkohol dapat menyebabkan penimbunan lemak di area perut. Batasi konsumsi alkohol Anda atau hindari sepenuhnya jika memungkinkan.
\nPenting untuk dicatat bahwa setiap upaya untuk mengatasi obesitas harus dilakukan dengan bimbingan medis dan disesuaikan dengan kebutuhan individu. Konsultasikan dengan dokter atau ahli gizi untuk mendapatkan rekomendasi yang tepat sesuai dengan kondisi anda. ''';
        break;
      case GENOID:
        descriptionResultDiagnosis =
            '''Pada obesitas tipe Genoid, lemak cenderung menumpuk di sekitar pinggul, paha, dan bokong. lemak pada bagian bawah tubuh dapat meningkatkan risiko gangguan muskuloskeletal, seperti osteoartritis pada pinggul dan lutut.
\n*>Penyebab obesitas tipe genoid
1.  Genetik: Faktor genetik dapat memainkan peran penting dalam kecenderungan seseorang untuk mengembangkan obesitas tipe pir. Ada bukti bahwa kecenderungan genetik dapat mempengaruhi distribusi lemak tubuh pada area pinggul, paha, dan bokong.
2.  Hormonal: Hormon seperti estrogen berperan dalam pengaturan penyebaran lemak tubuh pada wanita. Tingginya tingkat estrogen dalam tubuh wanita cenderung mempengaruhi akumulasi lemak di area pinggul, paha, dan bokong.
3.  Metabolisme dan resistensi insulin: Ketidakseimbangan metabolisme dan resistensi insulin juga dapat mempengaruhi penumpukan lemak pada area pinggul, paha, dan bokong. Resistensi insulin terkait dengan ketidakmampuan tubuh menggunakan insulin secara efisien, yang dapat memicu peningkatan produksi dan penumpukan lemak.
4.  Pola makan: Pola makan yang tidak seimbang, khususnya konsumsi makanan yang kaya lemak dan kalori tinggi, dapat berkontribusi pada perkembangan obesitas tipe pir. Mengonsumsi makanan olahan, makanan cepat saji, dan minuman manis secara berlebihan dapat menyebabkan peningkatan asupan kalori dan akumulasi lemak pada area pinggul, paha, dan bokong.
5.  Kurangnya aktivitas fisik: Gaya hidup yang tidak aktif atau kurangnya aktivitas fisik juga merupakan faktor yang berkontribusi pada obesitas tipe pir. Kurangnya latihan kardiovaskular dan kurangnya latihan yang melibatkan otot-otot pada area pinggul dan paha dapat menyebabkan penurunan kekuatan otot dan akumulasi lemak.
6.  Stres dan faktor psikologis: Stres kronis dan faktor psikologis tertentu juga dapat memengaruhi perkembangan obesitas tipe pir. Beberapa orang cenderung mengatasi stres dengan mengonsumsi makanan yang tidak sehat atau dalam jumlah yang berlebihan, yang dapat berkontribusi pada peningkatan berat badan dan penumpukan lemak pada area pinggul, paha, dan bokong.
\n*>Solusi untuk obesitas tipe genoid
1.  Diet Seimbang: Mengadopsi pola makan seimbang dengan memperhatikan asupan nutrisi yang tepat sangat penting. Fokus pada makanan tinggi serat, seperti buah-buahan, sayuran, biji-bijian, dan protein rendah lemak, seperti daging tanpa lemak, ikan, dan kacang-kacangan. Hindari makanan olahan, makanan cepat saji, makanan manis, dan makanan tinggi lemak jenuh.
2.  Kontrol Porsi Makan: Mengendalikan porsi makan juga penting dalam manajemen berat badan. Gunakan piring yang lebih kecil dan hindari makan berlebihan. Mengonsumsi makanan dalam porsi yang lebih kecil namun lebih sering dapat membantu menjaga asupan kalori yang seimbang.
3.  Olahraga Teratur: Aktivitas fisik adalah bagian penting dalam mengurangi lemak tubuh. Lakukan olahraga aerobik seperti berjalan kaki, berlari, bersepeda, atau berenang secara teratur untuk membakar kalori dan meningkatkan metabolisme. Latihan kekuatan juga dapat membantu membangun otot dan meningkatkan pembakaran lemak. Fokus pada latihan yang melibatkan area perut dan dada untuk membantu mengurangi penumpukan lemak di area tersebut.
4.  Pengelolaan Stres: Stres kronis dapat mempengaruhi berat badan dan pola makan. Temukan cara-cara yang efektif untuk mengelola stres, seperti meditasi, yoga, olahraga, atau kegiatan relaksasi lainnya. Hindari makan berlebihan sebagai respons terhadap stres.
5.  Tidur yang Cukup: Tidur yang cukup dan berkualitas sangat penting untuk keseimbangan hormon dan manajemen berat badan. Usahakan untuk mendapatkan 7-8 jam tidur setiap malam.
6.  Konsultasikan dengan Profesional Kesehatan: Jika Anda mengalami kesulitan dalam mengelola obesitas tipe genoid, konsultasikan dengan dokter atau ahli gizi. Mereka dapat memberikan panduan yang lebih spesifik sesuai dengan kebutuhan dan kondisi Anda. ''';
        break;
      case HYPERTROPIC:
        descriptionResultDiagnosis =
            '''Obesitas hypertropic, juga dikenal sebagai obesitas adiposit hypertropic, adalah bentuk obesitas di mana sel-sel lemak (adiposit) dalam tubuh membesar karena penumpukan lemak yang berlebihan.
\n*>Penyebab Obesitas Hypertropic:
1.  Asupan kalori berlebihan: Konsumsi makanan dengan kalori yang berlebihan dibandingkan dengan kebutuhan tubuh dapat menyebabkan peningkatan lemak dan perkembangan obesitas hipertrofik.
2.  Gaya hidup tidak aktif: Kurangnya aktivitas fisik dan gaya hidup yang tidak aktif dapat menyebabkan ketidakseimbangan energi, di mana asupan kalori lebih banyak daripada pembakaran kalori. Hal ini dapat menyebabkan penimbunan lemak dalam bentuk obesitas hipertrofik.
3.  Faktor genetik: Ada faktor genetik yang memengaruhi kecenderungan seseorang untuk mengembangkan obesitas. Beberapa individu mungkin memiliki kecenderungan genetik yang membuat mereka rentan terhadap perkembangan obesitas hipertrofik.
4.  Faktor hormonal: Ketidakseimbangan hormon tertentu, seperti resistensi insulin atau perubahan kadar hormon tiroid, dapat mempengaruhi metabolisme lemak dan berkontribusi pada obesitas hipertrofik.
\n*>Solusi untuk Obesitas Hypertropic:
1.  Pola makan sehat: Mengadopsi pola makan seimbang dengan fokus pada makanan nutrisi yang tinggi, seperti buah-buahan, sayuran, biji-bijian, protein tanpa lemak, dan lemak sehat. Hindari makanan olahan, makanan cepat saji, makanan tinggi gula, dan makanan tinggi lemak jenuh.
2.  Kontrol asupan kalori: Mengendalikan asupan kalori sangat penting dalam manajemen berat badan. Perhatikan porsi makan dan hindari makan berlebihan. Menggunakan metode seperti mengukur makanan dan mencatat asupan kalori dapat membantu mengontrol konsumsi kalori.
3.  Aktivitas fisik teratur: Melakukan latihan aerobik seperti berjalan kaki, jogging, bersepeda, atau berenang secara teratur untuk membakar kalori dan meningkatkan metabolisme. Latihan kekuatan juga penting untuk membangun massa otot, yang dapat membantu meningkatkan pembakaran lemak.
4.  Perubahan gaya hidup: Tingkatkan aktivitas fisik sehari-hari dengan memilih untuk berjalan kaki, naik tangga, atau menggunakan sepeda daripada kendaraan bermotor. Selain itu, sediakan waktu untuk beristirahat yang cukup dan mengelola stres.
5.  Pendampingan medis: Jika obesitas hipertrofik berhubungan dengan masalah kesehatan yang lebih serius, seperti resistensi insulin atau gangguan hormonal ''';
        break;
      case HYPERPLASTIC:
        descriptionResultDiagnosis =
            '''Obesitas hiperplastik adalah kondisi di mana jumlah sel lemak (adiposit) meningkat secara signifikan dalam tubuh. Perbedaan dengan obesitas hipertrofik adalah pada obesitas hiperplastik, terjadi peningkatan jumlah sel lemak, sedangkan pada obesitas hipertrofik, ukuran sel lemak yang ada membesar.
\n*>Penyebab Obesitas Hyperplastik:
1.  Faktor Genetik: Faktor genetik dapat memainkan peran penting dalam rentan seseorang terhadap obesitas hiperplastik. Beberapa individu mungkin memiliki kecenderungan genetik yang membuat mereka lebih rentan terhadap peningkatan jumlah sel lemak.
2.  Pola Makan yang Tidak Sehat: Konsumsi makanan yang kaya akan lemak, gula, dan kalori tinggi dapat menyebabkan peningkatan berat badan dan obesitas hiperplastik. Makan berlebihan dan asupan kalori yang berlebihan dapat memicu peningkatan jumlah sel lemak dalam tubuh.
3.  Kurangnya Aktivitas Fisik: Gaya hidup tidak aktif dan kurangnya aktivitas fisik dapat berkontribusi pada perkembangan obesitas hiperplastik. Ketika energi yang dikonsumsi melalui makanan tidak dibakar melalui aktivitas fisik, tubuh akan menyimpan kelebihan kalori dalam bentuk lemak, yang dapat mengarah pada peningkatan jumlah sel lemak.
\n*>Solusi untuk Obesitas Hyperplastik:
1.  Pola Makan Sehat: Mengadopsi pola makan seimbang dengan mengonsumsi makanan yang kaya akan serat, vitamin, mineral, dan nutrisi esensial lainnya. Fokus pada makanan alami, seperti buah-buahan, sayuran, biji-bijian, protein tanpa lemak, dan lemak sehat. Hindari makanan olahan, makanan cepat saji, makanan tinggi gula, dan makanan tinggi lemak jenuh.
2.  Aktivitas Fisik Teratur: Lakukan latihan aerobik, seperti berjalan kaki, berlari, bersepeda, atau berenang, secara teratur untuk membakar kalori dan meningkatkan metabolisme. Latihan kekuatan juga penting untuk membangun massa otot, yang dapat membantu meningkatkan pembakaran lemak.
3.  Pembatasan Kalori: Mengontrol asupan kalori menjadi penting untuk mengelola berat badan. Perhatikan porsi makan dan hindari makan berlebihan. Menggunakan metode seperti mengukur makanan dan mencatat asupan kalori dapat membantu mengontrol konsumsi kalori.
4.  Pendampingan Medis: Jika obesitas hiperplastik terkait dengan masalah kesehatan yang lebih serius, seperti masalah hormon atau gangguan metabolisme, konsultasikan dengan dokter atau ahli gizi yang kompeten untuk penanganan yang tepat. ''';
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
