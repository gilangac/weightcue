// ignore_for_file: must_be_immutable

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/ahli/bmi/riwayat_bmi_controller.dart';
import 'package:weightcue_mobile/models/riwayat_bmi_model.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:weightcue_mobile/widgets/general/circle_avatar.dart';

class RiwayatDiagnosisPage extends StatelessWidget {
  RiwayatBmiController bmiController = Get.put(RiwayatBmiController());
  RiwayatDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Riwayat BMI",
      ),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    return Obx(() => SizedBox(
          height: Get.height,
          width: Get.width,
          child: bmiController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  itemCount: bmiController.listBmi.length,
                  itemBuilder: (context, index) {
                    return _cardArticle(index);
                  }),
        ));
  }

  Widget _cardArticle(int index) {
    RiwayatBmiModel data = bmiController.listBmi[index];
    return Stack(
      children: [
        Container(
          width: Get.width,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 4, color: AppColors.backgroundColor),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
              color: AppColors.white),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(data.idUser)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: data.idBmi ?? '',
                        transitionOnUserGestures: true,
                        child: circleAvatar(
                            imageData: snapshot.hasData
                                ? snapshot.data!.get("photo") ?? ""
                                : "",
                            nameData: (snapshot.hasData
                                ? snapshot.data!.get("name") ?? ""
                                : ""),
                            size: 25),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  snapshot.hasData
                                      ? snapshot.data!.get("name") ?? ""
                                      : "",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(
                                  DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                      .format(data.date!.toDate()),
                                  textAlign: TextAlign.justify,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Get.width * 0.2,
                                    child: Text('Gender',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          height: 1.5,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                  Text(': ${data.gender}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        height: 1.5,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Get.width * 0.2,
                                    child: Text('BMI',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          height: 1.5,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                  Text(': ${data.bmi}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        height: 1.5,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Get.width * 0.2,
                                    child: Text('Keterangan',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          height: 1.5,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                  Text(': ${data.keterangan}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        height: 1.5,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
        Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => bmiController.onConfirmDelete(data.idBmi ?? ''),
              child: Icon(
                Icons.delete,
                size: 20,
                color: Colors.red.shade400,
              ),
            ))
      ],
    );
  }
}