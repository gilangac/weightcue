// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/auth/firebase_auth_controller.dart';
import 'package:weightcue_mobile/helpers/snackbar_helper.dart';
import 'package:weightcue_mobile/widgets/general/weightcue_logo.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initFirebase = Firebase.initializeApp();
    return FutureBuilder(
      future: _initFirebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(),
                  FadeInDown(child: weightCueLogo(size: 28)),
                  _illustration(),
                  SizedBox(),
                  _textContent(),
                  _btnStart(),
                  SizedBox()
                ],
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget _illustration() {
    return FadeInDown(
      child: Image.asset(
        "assets/images/illustration1.png",
        width: Get.width * 0.8,
      ),
    );
  }

  Widget _textContent() {
    return FadeInDown(
      child: Column(
        children: [
          Text(
            "Worry less.. Live healthier..",
            style: GoogleFonts.poppins(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Selamat Datang di Weight",
                style: GoogleFonts.poppins(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
              TextSpan(
                text: "Cue",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: " !",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _btnStart() {
    FirebaseAuthController firebaseAuthC = Get.find();
    return FadeInDown(
      child: SizedBox(
        width: Get.width / 1,
        height: 50,
        child: GetPlatform.isIOS
            ? CupertinoButton.filled(
                borderRadius: BorderRadius.circular(12),
                onPressed: () {
                  firebaseAuthC.signInWithGoogle().then((_) {
                    Get.back();
                    firebaseAuthC.onGetUser();
                  }).catchError((error) {
                    SnackBarHelper.showError(
                        description: "Gagal melakukan login");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/google_icon.svg"),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Masuk dengan Google',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF5F5F5), elevation: 0.5),
                onPressed: () {
                  firebaseAuthC.signInWithGoogle().then((_) {
                    Get.back();
                    firebaseAuthC.onGetUser();
                  }).catchError((error) {
                    SnackBarHelper.showError(
                        description: "Gagal melakukan login");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/google_icon.svg"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Masuk dengan Google',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
