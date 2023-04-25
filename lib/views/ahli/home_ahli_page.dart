// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/auth/firebase_auth_controller.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/controllers/home/home_controller.dart';
import 'package:weightcue_mobile/helpers/dialog_helper.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:weightcue_mobile/widgets/general/circle_avatar.dart';

class HomeAhliPage extends StatelessWidget {
  HomeAhliPage({Key? key}) : super(key: key);
  FirebaseAuthController firebaseAuthC = Get.put(FirebaseAuthController());
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryColor,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Obx(
            () => homeController.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [_body()],
                  ),
          ),
        ));
  }

  Widget _body() {
    return Expanded(
        child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_header(), _illustration(), _menuContent()],
      ),
    ));
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            Container(
              width: Get.width,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  color: AppColors.primaryColor),
            ),
            SizedBox(
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("DASHBOARD AHLI",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              height: 1.5,
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                            (firebaseAuthC.auth.currentUser?.displayName ?? "")
                                .toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.white,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 25, 25),
                    child: GestureDetector(
                      onTap: () => _bottomSheetContentProfile(),
                      child: circleAvatar(
                          imageData:
                              firebaseAuthC.auth.currentUser?.photoURL ?? "a",
                          nameData:
                              (firebaseAuthC.auth.currentUser?.displayName ??
                                  "a"),
                          size: 25),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _illustration() {
    return FadeInDown(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        width: Get.width,
        // child: Center(
        //   child: Image.asset(
        //     "assets/images/illustration1.png",
        //     width: Get.width * 0.7,
        //   ),
        // ),
      ),
    );
  }

  Widget _menuContent() {
    return Container(
      padding: EdgeInsets.all(20),
      width: Get.width,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () => Get.toNamed(AppPages.DIAGNOSIS),
                    child: _cardMenu("Riwayat \nDiagnosis")),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: GestureDetector(
                    onTap: () => Get.toNamed(AppPages.ARTICLE),
                    child: _cardMenu("Artikel")),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () => Get.toNamed(AppPages.RIWAYAT_BMI),
                    child: _cardMenu("Riwayat\nBMI")),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      _bottomSheetContentProfile();
                    },
                    child: _cardMenu("Lainnya")),
              )
            ],
          ),
        ],
      ),
    );
  }

  _cardMenu(String title) {
    return Stack(
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primaryColor),
        ),
        Positioned(
            top: 5,
            right: 10,
            child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(
                  "assets/svg/atom.svg",
                  height: 60,
                ))),
        Container(
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent),
          child: Center(
            child: Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ),
      ],
    );
  }

  void _bottomSheetContentProfile() {
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.lightGrey, width: 35, height: 4),
                SizedBox(height: 30),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Column(
                      children: [
                        _listAction2(
                            icon: Feather.phone_call,
                            title: "Informasi Selanjutnya",
                            type: "about"),
                      ],
                    )),
                SizedBox(height: 13),
                _logoutAction()
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget _listAction2({
    IconData? icon,
    required String title,
    String? path,
    String? type,
  }) {
    return SizedBox(
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            if (path != null) {
              if (type != 'about') {
                Get.toNamed(path);
              }
            }
            if (type == 'about') {
              homeController.onLaunchUrl("https://wa.me/+6287753896137-?text=");
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              minLeadingWidth: 0,
              leading: Icon(icon),
              title: Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey),
              ),
              trailing: Icon(Feather.chevron_right),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutAction() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
            DialogHelper.showConfirm(
                title: "Logout",
                description: "Anda yakin akan keluar aplikasi?",
                titlePrimary: "Logout",
                titleSecondary: "Batal",
                action: () => firebaseAuthC.logout());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              minLeadingWidth: 0,
              leading: Icon(Feather.log_out, color: Colors.red.shade400),
              title: Text(
                "Keluar",
                style: GoogleFonts.poppins(color: Colors.red.shade400),
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
