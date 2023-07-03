// ignore_for_file: avoid_print, unnecessary_overrides

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:weightcue_mobile/controllers/article/article_controller.dart';
import 'package:weightcue_mobile/controllers/home/home_controller.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/helpers/snackbar_helper.dart';
import 'package:weightcue_mobile/models/user.dart';
import 'package:weightcue_mobile/services/service_preference.dart';
import 'package:weightcue_mobile/services/service_utils.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;

  File? fileResult;
  bool isEdit = false;
  var progress = 0.0.obs;
  var isLoading = false.obs;
  var urlImage = ''.obs;
  var selectedImagePath = ''.obs;
  late UserModel dataUser;

  final emailFC = TextEditingController();
  final nameFC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    onGetDataUser();
    super.onInit();
  }

  Future<void> onGetDataUser() async {
    isLoading.value = true;
    await user
        .where('idUser', isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        dataUser = UserModel(
          idUser: data["idUser"],
          email: data["email"],
          name: data["name"],
          photo: data["photo"],
          type: data["type"],
          date: data["date"],
        );
        PreferenceService.setTypeUser(data['type']);
      });
      onInitEdit();
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });

    isLoading.value = false;
  }

  onInitEdit() {
    emailFC.text = dataUser.email ?? '';
    nameFC.text = dataUser.name ?? '';
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
            // onCreateArticleData(idArtikel);
          });
        });
      }
    }
  }

  onEditPost() async {
    DocumentReference editUser =
        firestore.collection("users").doc(dataUser.idUser);
    DialogHelper.showLoading();
    if (formKey.currentState!.validate()) {
      if (selectedImagePath.isNotEmpty || selectedImagePath.value != '') {
        String fileName = 'photo-user/${dataUser.idUser ?? ""}';

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
              await editUser.update({
                "photo": urlImage.toString(),
                "name": nameFC.text,
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
          await editUser.update({
            "name": nameFC.text,
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
    HomeController articleController = Get.find();
    articleController.onGetDataUser();
    articleController.refresh();
    articleController.update();

    Get.back();
    Get.back();
  }
}
