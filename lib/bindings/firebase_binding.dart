import 'package:get/get.dart';
import 'package:weightcue_mobile/controllers/auth/firebase_auth_controller.dart';

class FirebaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FirebaseAuthController(), fenix: true);
  }
}
