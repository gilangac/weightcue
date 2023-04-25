// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, unused_import, must_be_immutable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:weightcue_mobile/routes/pages.dart';
import 'package:weightcue_mobile/services/service_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weightcue_mobile/themes/light_theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferenceService.init();
  initializeDateFormatting('id', null);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var isLogged = auth.currentUser != null;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeightCue!',
      theme: lightTheme(context),
      initialRoute: isLogged
          ? PreferenceService.getTypeUser() == 0
              ? AppPages.HOME
              : AppPages.HOME_AHLI
          : AppPages.LOGIN,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
