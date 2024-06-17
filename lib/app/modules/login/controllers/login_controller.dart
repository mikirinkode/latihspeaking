import 'package:get/get.dart';

import '../../../data/provider/firebase_provider.dart';
import '../../../data/service/auth_service.dart';
import '../../../global_widgets/ui.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<dynamic> signInWithGoogle() async {
    try {
      bool success = await Get.find<FirebaseProvider>().signInWithGoogle();
      if (success) {
        await Get.find<FirebaseProvider>().checkUserData();
        Get.find<AuthService>().refreshUser();
        Get.offAllNamed(Routes.PROFICIENCY);
      } else {
        UI.showSnackbar(message: "Terjadi kesalahan, coba lagi");
      }
    } catch (error) {
      Get.log("Error: $error");
      UI.showSnackbar(message: "Login gagal, coba lagi");
    }

  //   Get.find<FirebaseProvider>().signInWithGoogle().then((value) {
  //     // UI.showSnackbar(message: "Login Berhasil");
  //     if (value) {
  //       Get.find<FirebaseProvider>().checkUserData();
  //       Get.find<AuthService>().refreshUser();
  //       Get.offAllNamed(Routes.PROFICIENCY);
  //     } else {
  //       UI.showSnackbar(message: "Terjadi kesalahan, coba lagi");
  //     }
  //   }).onError((error, stackTrace) {
  //     Get.log("Error: $error");
  //     UI.showSnackbar(message: "Login gagal, coba lagi");
  //   });
  }
}
