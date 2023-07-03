// ignore_for_file: unnecessary_overrides, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weightcue_mobile/models/user.dart';
import 'package:weightcue_mobile/services/service_preference.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? dataUser;
  var isLoading = true.obs;
  @override
  void onInit() async {
    onGetDataUser();
    permissionsRequest();
    super.onInit();
  }

  permissionsRequest() async {
    // You can request multiple permissions at once.

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.notification,
      Permission.photos,
    ].request();
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
    }).onError((error, stackTrace) {
      Get.snackbar("Terjadi Kesalahan", "Periksa koneksi internet anda!");
    });

    isLoading.value = false;
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
