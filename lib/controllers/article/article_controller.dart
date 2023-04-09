// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/models/article_model.dart';

class ArticleController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference article =
      FirebaseFirestore.instance.collection('artikel');

  var listArticle = <ArticleModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    onGetDataArticle();
    super.onInit();
  }

  Future<void> onGetDataArticle() async {
    isLoading.value = true;
    listArticle.isNotEmpty ? listArticle.clear() : null;
    await article.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        listArticle.add(ArticleModel(
          idArtikel: data["idArtikel"],
          judul: data["judul"],
          materi: data["materi"],
          imageUrl: data["imageUrl"],
          date: data["date"],
        ));
      });
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });

    isLoading.value = false;
  }
}
