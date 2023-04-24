// ignore_for_file: avoid_print, unnecessary_overrides

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:weightcue_mobile/controllers/article/article_controller.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/helpers/snackbar_helper.dart';
import 'package:weightcue_mobile/models/article_model.dart';
import 'package:weightcue_mobile/services/service_utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddArticleController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference article =
      FirebaseFirestore.instance.collection('artikel');

  File? fileResult;
  bool isEdit = false;
  var progress = 0.0.obs;
  var urlImage = ''.obs;
  var selectedImagePath = ''.obs;
  late ArticleModel data;

  final titleArticleFC = TextEditingController();
  final linkArticleFC = TextEditingController();
  final descriptionArticleFC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    if (Get.arguments != null) {
      isEdit = true;
      data = Get.arguments;
      onInitEdit();
    }
    super.onInit();
  }

  onInitEdit() {
    titleArticleFC.text = data.judul ?? '';
    linkArticleFC.text = data.link ?? '';
    descriptionArticleFC.text = data.materi ?? '';
  }

  getImage() async {
    final ImagePicker _picker = ImagePicker();

    await _picker
        .pickImage(
      preferredCameraDevice: CameraDevice.front,
      source: ImageSource.camera,
      imageQuality: 20,
    )
        .then((XFile? fileRaw) async {
      File file = File(fileRaw!.path);

      if (file == null) {
        return;
      } else {
        selectedImagePath.value = file.path;
        fileResult = file;
      }
    }).onError((error, stackTrace) {
      print('Belum ada foto yang diambil');
    });
  }

  void pickImage(String source) async {
    source == 'camera'
        ? ImagesPicker.openCamera(
            language: Language.English,
            maxSize: 20,
            pickType: PickType.image,
            quality: 0.3,
            cropOpt: CropOption(
              aspectRatio: CropAspectRatio.custom,
              cropType: CropType.rect,
            )).then((value) {
            if (value != null) {
              fileResult = File(value.first.path);
              selectedImagePath.value = value.first.path;
            }
          })
        : ImagesPicker.pick(
            count: 1,
            language: Language.English,
            pickType: PickType.image,
            quality: 0.3,
            maxSize: 20,
            cropOpt: CropOption(
              aspectRatio: CropAspectRatio.custom,
              cropType: CropType.rect,
            ),
          ).then((value) {
            if (value != null) {
              fileResult = File(value.first.path);
              selectedImagePath.value = value.first.path;
            }
          });
  }

  onCreateArticle() {
    if (selectedImagePath.isEmpty || selectedImagePath.value == '') {
      SnackBarHelper.showError(description: "Pilih gambar terlebih dahulu");
    } else {
      if (formKey.currentState!.validate()) {
        DialogHelper.showLoading();
        String idArtikel = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
            ServiceUtils.randomString(4);

        String fileName = 'photo-article/$idArtikel';

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        firebase_storage.UploadTask task = ref.putFile(fileResult!);
        task.snapshotEvents.listen((event) {
          progress.value =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          print(progress.toString());
        });
        task.then((_) {
          ref.getDownloadURL().then((url) {
            urlImage.value = url;
            onCreateArticleData(idArtikel);
          });
        });
      }
    }
  }

  onCreateArticleData(String idArticle) async {
    final dateNow = DateTime.now();
    try {
      await article.doc(idArticle).set({
        "idArtikel": idArticle,
        "imageUrl": urlImage.toString(),
        "judul": titleArticleFC.text,
        "materi": descriptionArticleFC.text,
        "link": linkArticleFC.text,
        "date": dateNow,
      });
      onRefreshArticle();
    } catch (e) {
      print(e);
    }
  }

  onEditPost() async {
    DocumentReference editArticle =
        firestore.collection("artikel").doc(data.idArtikel);
    DialogHelper.showLoading();
    if (formKey.currentState!.validate()) {
      if (selectedImagePath.isNotEmpty || selectedImagePath.value != '') {
        String fileName = 'photo-article/${data.idArtikel ?? ""}';

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        firebase_storage.UploadTask task = ref.putFile(fileResult!);
        task.snapshotEvents.listen((event) {
          progress.value =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          print(progress.toString());
        });
        task.then((_) {
          ref.getDownloadURL().then((url) async {
            urlImage.value = url;
            try {
              await editArticle.update({
                "imageUrl": urlImage.toString(),
                "judul": titleArticleFC.text,
                "materi": descriptionArticleFC.text,
                "link": linkArticleFC.text,
              }).then((value) {
                onRefreshArticle();
                Get.back();
              });
            } catch (e) {
              print(e);
            }
          });
        });
      } else {
        try {
          await editArticle.update({
            "judul": titleArticleFC.text,
            "materi": descriptionArticleFC.text,
            "link": linkArticleFC.text,
          }).then((value) {
            onRefreshArticle();
            Get.back();
          });
        } catch (e) {
          print(e);
        }
      }
    }
  }

  onRefreshArticle() {
    ArticleController articleController = Get.find();
    articleController.onGetDataArticle();
    articleController.refresh();
    articleController.update();

    Get.back();
    Get.back();
  }
}
