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
    GetPage(name: _Paths.ROOM_DIAGNOSIS, page: () => DiagnosisRoomPage()),
    GetPage(name: _Paths.RESULT_DIAGNOSIS, page: () => ResultDiagnosisPage()),
    GetPage(
        name: _Paths.DETAIL_RIWAYAT_DIAGNOSIS2,
        page: () => DetailRiwayatDiagnosisPage2()),
    GetPage(
        name: _Paths.RIWAYAT_DIAGNOSIS_USER,
        page: () => RiwayatDiagnosisUserPage()),
    //AHLI ROUTES
    GetPage(name: _Paths.HOME_AHLI, page: () => HomeAhliPage()),
    GetPage(name: _Paths.ADD_ARTICLE, page: () => AddArticlePage()),
    GetPage(name: _Paths.RIWAYAT_BMI, page: () => RiwayatBmiPage()),
    GetPage(name: _Paths.RIWAYAT_DIAGNOSIS, page: () => RiwayatDiagnosisPage()),
    GetPage(name: _Paths.EDIT_DIAGNOSIS, page: () => EditDiagnosisPage()),
    GetPage(name: _Paths.EDIT_PROFILE, page: () => EditProfilePage()),
    GetPage(
        name: _Paths.DETAIL_EDIT_DIAGNOSIS,
        page: () => DetailEditDiagnosisPage()),
    GetPage(
        name: _Paths.DETAIL_RIWAYAT_DIAGNOSIS,
        page: () => DetailRiwayatDiagnosisPage()),
    GetPage(
        name: _Paths.LOGIN,
        page: () => const LoginPage(),
        binding: FirebaseBinding()),
  ];
}
