// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weightcue_mobile/constant/colors.dart';

Widget formInput(
    {required String title,
    String? initialValue,
    required String placeholder,
    required controller,
    required TextInputType inputType,
    required TextInputAction inputAction,
    List<TextInputFormatter>? inputFormater,
    bool secureText = false,
    bool enabled = true,
    bool suffix = false,
    ontap,
    required validator}) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.poppins(
              color: AppColors.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        initialValue: initialValue,
        controller: controller,
        onChanged: (text) => {},
        keyboardType: inputType,
        textInputAction: inputAction,
        obscureText: secureText,
        enabled: enabled,
        onTap: ontap,
        inputFormatters: inputFormater ?? [],
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.0),
            ),
            hintText: placeholder,
            fillColor: AppColors.white,
            suffixIcon: suffix == true ? Icon(Feather.chevron_down) : null),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
      ),
    ],
  );
}
