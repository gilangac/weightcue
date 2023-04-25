// ignore_for_file: prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:weightcue_mobile/services/service_preference.dart';

class FirebaseAuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  List dataUser = [];
  List listFcmToken = [];

  Stream<User?> authStatus() {
    return auth.authStateChanges();
  }

  Future<UserCredential> signInWithGoogle() async {
    DialogHelper.showLoading();
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    try {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
      Get.back();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _googleSignIn.signOut();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    // Once signed in, return the UserCredential
  }

  onGetUser() async {
    final email = auth.currentUser?.email;
    user
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.size == 1) {
        PreferenceService.setTypeUser(snapshot.docs.first['type'] ?? 0);
        if (snapshot.docs.first['type'] == 0) {
          Get.offNamed(AppPages.HOME);
        } else if (snapshot.docs.first['type'] == 1) {
          Get.offNamed(AppPages.HOME_AHLI);
        }
      } else {
        await user.doc(auth.currentUser?.uid).set({
          "email": auth.currentUser?.email,
          "photo": auth.currentUser?.photoURL,
          "idUser": auth.currentUser?.uid,
          "name": auth.currentUser?.displayName,
          "date": DateTime.now(),
          "type": 0
        });
        Get.offNamed(AppPages.HOME);
      }
    });
  }

  void logout() async {
    Get.back();
    DialogHelper.showLoading();
    user.doc(auth.currentUser?.uid).get().then((value) async {
      await auth.signOut();
      PreferenceService.clear();
      await _googleSignIn.signOut().then((value) {
        Get.offAllNamed(AppPages.LOGIN);
      });
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
