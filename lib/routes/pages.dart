// ignore_for_file: constant_identifier_names

import 'package:get/route_manager.dart';
import 'package:weightcue_mobile/bindings/firebase_binding.dart';
import 'package:weightcue_mobile/views/ahli/article/add_article_page.dart';
import 'package:weightcue_mobile/views/ahli/bmi/riwayat_bmi_page.dart';
import 'package:weightcue_mobile/views/ahli/diagnosis/riwayat_diagnosis_page.dart';
import 'package:weightcue_mobile/views/ahli/home_ahli_page.dart';
import 'package:weightcue_mobile/views/article/article_page.dart';
import 'package:weightcue_mobile/views/article/detail_article_page.dart';
import 'package:weightcue_mobile/views/auth/login_page.dart';
import 'package:weightcue_mobile/views/bmi/calculator_bmi_page.dart';
import 'package:weightcue_mobile/views/diagnosis/diagnosis_page.dart';
import 'package:weightcue_mobile/views/diagnosis/result_diagnosis_page.dart';
import 'package:weightcue_mobile/views/home/home_page.dart';

part 'routes.dart';

class AppPages {
  static const SPLASH = _Paths.SPLASH;
  static const NAVIGATOR = _Paths.NAVIGATOR;
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const CALCULATOR_BMI = _Paths.CALCULATOR_BMI;
  static const ARTICLE = _Paths.ARTICLE;
  static const DETAIL_ARTICLE = _Paths.DETAIL_ARTICLE;
  static const DIAGNOSIS = _Paths.DIAGNOSIS;
  static const RESULT_DIAGNOSIS = _Paths.RESULT_DIAGNOSIS;
  static const NOT_FOUND = _Paths.NOT_FOUND;

  //AHLI route
  static const HOME_AHLI = _Paths.HOME_AHLI;
  static const ADD_ARTICLE = _Paths.ADD_ARTICLE;
  static const RIWAYAT_BMI = _Paths.RIWAYAT_BMI;
  static const RIWAYAT_DIAGNOSIS = _Paths.RIWAYAT_DIAGNOSIS;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const NAVIGATOR = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const CALCULATOR_BMI = '/calculator-bmi';
  static const ARTICLE = '/article';
  static const DETAIL_ARTICLE = '/detail-article';
  static const DIAGNOSIS = '/diagnosis';
  static const RESULT_DIAGNOSIS = '/result-diagnosis';
  static const NOT_FOUND = '/404';

  //AHLI route
  static const HOME_AHLI = '/home-ahli';
  static const ADD_ARTICLE = '/add-article/';
  static const RIWAYAT_BMI = '/riwayat-bmi';
  static const RIWAYAT_DIAGNOSIS = '/riwayat-diagnosis';
}
