// ignore_for_file: constant_identifier_names

import 'package:get/route_manager.dart';
import 'package:weightcue_mobile/bindings/firebase_binding.dart';
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
}
