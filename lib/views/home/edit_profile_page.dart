// ignore_for_file: must_be_immutable, unnecessary_null_comparison, unused_element

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';
import 'package:weightcue_mobile/controllers/home/edit_profile_controller.dart';
import 'package:weightcue_mobile/widgets/general/app_bar.dart';
import 'package:weightcue_mobile/widgets/general/form_input.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);
  EditProfileController editProfileController =
      Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Edit Profile"),
      body: _body(),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget _body() {
    return Obx(() => SizedBox(
        height: Get.height,
        width: Get.width,
        child: editProfileController.isLoading.value
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
                          key: editProfileController.formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showBottomSheet(),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 1.5),
                                        color: Colors.white,
                                      ),
                                      child: editProfileController
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
                                                              100),
                                                      child: Image(
                                                          fit: BoxFit.cover,
                                                          width: Get.width,
                                                          image: FileImage(File(
                                                              editProfileController
                                                                  .selectedImagePath
                                                                  .value)))),
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        editProfileController
                                                            .selectedImagePath
                                                            .value = '';
                                                      },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.8)),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Icon(
                                                              Feather.trash,
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )),
                                                    ))
                                              ],
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl: editProfileController
                                                        .dataUser.photo ??
                                                    "",
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
                                                      Icon(Icons.person,
                                                          size: 42,
                                                          color: Colors
                                                              .grey.shade400),
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
                                  title: "Email",
                                  placeholder: "Email",
                                  controller: editProfileController.emailFC,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.next,
                                  enabled: false,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Masukkan judul artikel terlebih dahulu';
                                    }
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              formInput(
                                  title: "Nama",
                                  placeholder: "Nama",
                                  controller: editProfileController.nameFC,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.next,
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
          onPressed: () => editProfileController.onEditPost(),
          child: Text(
            "Simpan",
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
        editProfileController.pickImage(source!);
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
