// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/article/article_controller.dart';
import 'package:weightcue_mobile/models/article_model.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:get/get.dart';

class DetailArticlePage extends StatelessWidget {
  DetailArticlePage({Key? key}) : super(key: key);
  ArticleController articleController = Get.find();

  var textContent =
      "Obesitas adalah keadaan dimana seseorang memiliki berat badan berlebih, karena kalori yang masuk ke dalam tubuh lebih besar dibandingkan kalori yang dibakar. Seseorang yang sangat gemuk dan mengandung banyak lemak ditubuhnya harus segera ditanggulangi, karena obesitas bisa menyebabkan gangguan kesehatan sehingga menurunkan harapan hidup dan meningkatkan masalah kesehatan.\n\nObesitas atau kegemukan dapat menyebabkan risiko terkena berbagai penyakit meningkat, diantaranya: \n\n·Penyakit jantung\n·Diabetes tipe 2\n·Obstructive sleep apnea\n·Kanker tertentu\n·Ostheoarthritis\n·Asma  ";
  late ArticleModel data;
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      data = Get.arguments;
    }
    return Scaffold(
      appBar: appBar(title: "Detail Informasi", actions: [
        articleController.isAhli
            ? GestureDetector(
                onTap: () {
                  _bottomSheetContent();
                },
                child: const Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                  size: 24,
                ),
              )
            : const SizedBox()
      ]),
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
          if (data.link != '')
            GestureDetector(
              onTap: () => articleController.onLaunchUrl(data.link ?? ''),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.link,
                      color: AppColors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Buka Berita',
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
            ),
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

  void _bottomSheetContent() {
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.lightGrey, width: 35, height: 4),
                const SizedBox(height: 30),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Column(
                      children: [
                        _listAction(
                            title: "Edit Artikel",
                            path: AppPages.ADD_ARTICLE,
                            type: "edit"),
                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                        _deleteAction(),
                      ],
                    )),
                const SizedBox(height: 13),
                _cancelAction()
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget _listAction({
    required String title,
    required String path,
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
            if (type == 'edit') {
              Get.toNamed(AppPages.ADD_ARTICLE, arguments: data);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteAction() {
    return SizedBox(
      width: Get.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            articleController.onConfirmDelete(data.idArtikel ?? '');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Hapus Artikel",
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.red.shade500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cancelAction() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
      child: Material(
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
            )),
        color: Colors.transparent,
      ),
    );
  }
}
