// ignore_for_file: unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/models/user.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference article = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? dataUser;
  var isLoading = true.obs;
  @override
  void onInit() async {
    onGetDataUser();
    super.onInit();
  }

  Future<void> onGetDataUser() async {
    isLoading.value = true;
    await article
        .where('idUser', isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((data) {
        dataUser = UserModel(
          idUser: data["idUser"],
          email: data["email"],
          name: data["name"],
          type: data["type"],
          date: data["date"],
        );
      });
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });

    isLoading.value = false;
  }
}
