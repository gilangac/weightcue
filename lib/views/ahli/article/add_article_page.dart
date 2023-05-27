// ignore_for_file: must_be_immutable, unnecessary_null_comparison, unused_element

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/ahli/article/add_article_controller.dart';
import 'package:weightcue_mobile/controllers/article/article_controller.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:weightcue_mobile/widgets/general/form_input.dart';

class AddArticlePage extends StatelessWidget {
  ArticleController articleController = Get.put(ArticleController());
  AddArticleController addArticleC = Get.put(AddArticleController());
  AddArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar(title: addArticleC.isEdit ? "Edit Artikel" : "Tambah Artikel"),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
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
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: addArticleC.formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gambar Artikel",
                                    style: GoogleFonts.poppins(
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  GestureDetector(
                                    onTap: () => _showBottomSheet(),
                                    child: Container(
                                      height: 180,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 1.5),
                                        color: Colors.white,
                                      ),
                                      child: addArticleC
                                                  .selectedImagePath.value !=
                                              ''
                                          ? Stack(
                                              children: [
                                                SizedBox(
                                                  height: 180,
                                                  width: Get.width,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image(
                                                          fit: BoxFit.cover,
                                                          width: Get.width,
                                                          image: FileImage(File(
                                                              addArticleC
                                                                  .selectedImagePath
                                                                  .value)))),
                                                ),
                                                Positioned(
                                                    top: 6,
                                                    right: 6,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        addArticleC
                                                            .selectedImagePath
                                                            .value = '';
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.6)),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Icon(
                                                              Feather.trash,
                                                              size: 20,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )),
                                                    ))
                                              ],
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: addArticleC.isEdit
                                                    ? addArticleC.data != null
                                                        ? addArticleC.data
                                                                .imageUrl ??
                                                            ''
                                                        : ''
                                                    : '',
                                                width: Get.width,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                            child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.image_rounded,
                                                          size: 38,
                                                          color: Colors
                                                              .grey.shade400),
                                                      Text(
                                                        "Tambahkan Gambar",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Container(
                                                  color: Colors.white,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: downloadProgress
                                                          .progress,
                                                      color: AppColors
                                                          .primaryColor,
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              formInput(
                                  title: "Judul Artikel",
                                  placeholder: "Judul Artikel",
                                  controller: addArticleC.titleArticleFC,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.next,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Masukkan judul artikel terlebih dahulu';
                                    }
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              formInput(
                                  title: "Link Artikel (opsional)",
                                  placeholder: "Link Artikel",
                                  controller: addArticleC.linkArticleFC,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.next,
                                  validator: (val) {}),
                              const SizedBox(
                                height: 20,
                              ),
                              formInput(
                                  title: "Deskripsi Artikel",
                                  placeholder: "Deskripsi Artikel",
                                  controller: addArticleC.descriptionArticleFC,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.next,
                                  maxLines: 8,
                                  validator: (val) {}),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _btnAddArticle()
                ],
              )
        // ListView.builder(
        //     padding:
        //         const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        //     itemCount: articleController.listArticle.length,
        //     itemBuilder: (context, index) {
        //       return _cardArticle(index);
        //     }),
        ));
  }

  Widget _btnAddArticle() {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: Get.width * 0.1, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor, elevation: 0.1),
          onPressed: () => addArticleC.isEdit
              ? addArticleC.onEditPost()
              : addArticleC.onCreateArticle(),
          child: Text(
            addArticleC.isEdit ? 'Edit Artikel' : 'Buat Artikel',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    Get.bottomSheet(
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(color: AppColors.lightGrey, width: 35, height: 4),
                const SizedBox(height: 15),
                const Text(
                  "Pilih Gambar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                _listAction(title: "Kamera", source: 'camera'),
                _listAction(title: "Galeri", source: 'gallery'),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: AppColors.lightGrey,
                  height: 0.5,
                  width: Get.width,
                ),
                const SizedBox(height: 10),
                _cancelAction(
                  icon: Feather.x,
                  title: "Batal",
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(20),
                topRight: Radius.circular(20))),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true);
  }

  Widget _listAction({required String title, String? source, String? type}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          minLeadingWidth: 0,
          title: Text(title),
        ),
      ),
      onTap: () {
        Get.back();
        addArticleC.pickImage(source!);
      },
    );
  }

  Widget _cancelAction({IconData? icon, required String title}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          minLeadingWidth: 0,
          title: Text(
            title,
            style: GoogleFonts.poppins(color: Colors.red.shade400),
          ),
        ),
      ),
      onTap: () {
        Get.back();
      },
    );
  }
}
