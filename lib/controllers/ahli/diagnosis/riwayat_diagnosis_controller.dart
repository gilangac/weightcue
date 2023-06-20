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
  var resultDiagnosis = ''.obs;

  RxMap<String, double> mapDiagnosis = {
    'Apel': 0.0,
    'Genoid': 0.0,
    'Hypertropic': 0.0,
    'Hyperplastic': 0.0,
  }.obs;

  var qApel = [
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
  var qGenoid = [
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
  var qHypertropic = [
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
  var qHyperplastik = [KG1, KG15, KG16, KG43, KG18, KG28, KG6, KG8, KG26];

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
    resultDiagnosis.value = dataModel.result ?? '';

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

  generateChart() {
    double apel = 0;
    double genoid = 0;
    double hypertropic = 0;
    double hyperplastic = 0;

    rawResult.forEach(
      (element) {
        if (element['answer'] == 1) {
          if (qApel.any((data) => data == element['key'])) {
            apel;
          }

          if (qGenoid.any((data) => data == element['key'])) {
            genoid++;
          }

          if (qHypertropic.any((data) => data == element['key'])) {
            hypertropic++;
          }

          if (qHyperplastik.any((data) => data == element['key'])) {
            hyperplastic++;
          }
        }
      },
    );

    mapDiagnosis['Apel'] = apel;
    mapDiagnosis['Genoid'] = genoid;
    mapDiagnosis['Hypertropic'] = hypertropic;
    mapDiagnosis['Hyperplastic'] = hyperplastic;
  }

  getResultDiagnosis(String resultDiagnosis) {
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
}
