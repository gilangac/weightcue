// ignore_for_file: constant_identifier_names, prefer_const_constructors

part of 'pages.dart';

class AppRoutes {
  static const INITIAL = AppPages.SPLASH;

  static final pages = [
    GetPage(name: _Paths.HOME, page: () => HomePage()),
    GetPage(name: _Paths.CALCULATOR_BMI, page: () => CalculatorBmiPage()),
    GetPage(name: _Paths.ARTICLE, page: () => ArticlePage()),
    GetPage(name: _Paths.DETAIL_ARTICLE, page: () => DetailArticlePage()),
    GetPage(name: _Paths.DIAGNOSIS, page: () => DiagnosisPage()),
    GetPage(name: _Paths.RESULT_DIAGNOSIS, page: () => ResultDiagnosisPage()),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginPage(),
        binding: FirebaseBinding()),
  ];
}
