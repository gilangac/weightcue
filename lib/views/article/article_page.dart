// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/article/article_controller.dart';
import 'package:weightcue_mobile/models/article_model.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:weightcue_mobile/services/service_preference.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:weightcue_mobile/widgets/general/empty_widget.dart';

class ArticlePage extends StatelessWidget {
  ArticleController articleController = Get.put(ArticleController());
  ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Informasi Obesitas",
      ),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: _fab(),
    );
  }

  Widget _body() {
    return Obx(() => SizedBox(
          height: Get.height,
          width: Get.width,
          child: articleController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : articleController.listArticle.isEmpty
                  ? const EmptyWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      itemCount: articleController.listArticle.length,
                      itemBuilder: (context, index) {
                        return _cardArticle(index);
                      }),
        ));
  }

  Widget _cardArticle(int index) {
    ArticleModel data = articleController.listArticle[index];
    return GestureDetector(
      onTap: () => Get.toNamed(AppPages.DETAIL_ARTICLE, arguments: data),
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: data.idArtikel ?? '',
                  transitionOnUserGestures: true,
                  child: Container(
                    height: 80,
                    width: Get.width * 0.3,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: AppColors.backgroundColor),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: data.imageUrl ?? '',
                        width: Get.width,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Container(
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
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.materi ?? "",
                            textAlign: TextAlign.justify,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w400,
                            )),
                        const Spacer(),
                        Row(
                          children: [
                            const Spacer(),
                            Text("Lihat detail",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                  height: 1.5,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    bool isAhli = PreferenceService.getTypeUser() == 1;

    return isAhli
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: AppColors.primaryColor,
                elevation: 0.1),
            onPressed: () {
              Get.toNamed(AppPages.ADD_ARTICLE);
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.add),
            ))
        : const SizedBox();
  }
}
