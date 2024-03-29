// ignore_for_file: avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/models/article_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:weightcue_mobile/services/service_preference.dart';

class ArticleController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference article =
      FirebaseFirestore.instance.collection('artikel');

  var listArticle = <ArticleModel>[].obs;
  var isLoading = true.obs;

  bool isAhli = PreferenceService.getTypeUser() == 1;

  @override
  void onInit() {
    onGetDataArticle();
    super.onInit();
  }

  Future<void> onGetDataArticle() async {
    isLoading.value = true;
    listArticle.isNotEmpty ? listArticle.clear() : null;
    await article
        .orderBy("date", descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        listArticle.add(ArticleModel(
          idArtikel: data["idArtikel"],
          judul: data["judul"],
          materi: data["materi"],
          imageUrl: data["imageUrl"],
          date: data["date"],
          link: data["link"] ?? '',
        ));
      });
    }).onError((error, stackTrace) {
      log(error.toString());
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });

    isLoading.value = false;
  }

  onDeletePost(String idArticle) async {
    DialogHelper.showLoading();
    article.doc(idArticle).get().then((value) async {
      var fileUrl = Uri.decodeFull(path.basename(value['imageUrl'].toString()))
          .replaceAll(RegExp(r'(\?alt).*'), '');
      if (value['imageUrl'] != "") {
        final firebase_storage.Reference firebaseStorageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(fileUrl);
        await firebaseStorageRef.delete();
      }
    }).then((_) async {
      await article.doc(idArticle).delete().then((_) {
        onGetDataArticle();
        Get.back();
        Get.back();
      });
    }).onError((error, stackTrace) {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    }).onError((error, stackTrace) {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });
  }

  void onConfirmDelete(String idArticle) {
    Get.back();
    DialogHelper.showConfirm(
        title: "Hapus Artikel",
        description: "Anda yakin akan menghapus artikel ini?",
        titlePrimary: "Hapus",
        titleSecondary: "Batal",
        action: () {
          Get.back();
          onDeletePost(idArticle);
        });
  }

  Future<void> onLaunchUrl(String url) async {
    if (!url.contains('http')) {
      url = 'https://' + url;
    }
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
