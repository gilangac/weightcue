// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/models/article_model.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:get/get.dart';

class DetailArticlePage extends StatelessWidget {
  DetailArticlePage({Key? key}) : super(key: key);

  var textContent =
      "Obesitas adalah keadaan dimana seseorang memiliki berat badan berlebih, karena kalori yang masuk ke dalam tubuh lebih besar dibandingkan kalori yang dibakar. Seseorang yang sangat gemuk dan mengandung banyak lemak ditubuhnya harus segera ditanggulangi, karena obesitas bisa menyebabkan gangguan kesehatan sehingga menurunkan harapan hidup dan meningkatkan masalah kesehatan.\n\nObesitas atau kegemukan dapat menyebabkan risiko terkena berbagai penyakit meningkat, diantaranya: \n\n·Penyakit jantung\n·Diabetes tipe 2\n·Obstructive sleep apnea\n·Kanker tertentu\n·Ostheoarthritis\n·Asma  ";
  late ArticleModel data;
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      data = Get.arguments;
    }
    return Scaffold(
      appBar: appBar(title: "Detail Informasi"),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_image(), _content()],
      )),
    );
  }

  Widget _image() {
    return Hero(
      transitionOnUserGestures: true,
      tag: data.idArtikel ?? '',
      child: SizedBox(
        height: Get.height * 0.3,
        width: Get.width,
        child: CachedNetworkImage(
          imageUrl: data.imageUrl ?? '',
          width: Get.width,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error)),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                color: AppColors.primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.judul ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                height: 1.5,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(
            height: 10,
          ),
          Text(data.materi ?? '',
              textAlign: TextAlign.justify,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  }
}
