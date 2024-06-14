import 'package:get/get.dart';

class UI {
  static showSnackbar({required String message, int duration = 3}) {
    return Get.showSnackbar(GetSnackBar(
      message: message,
      duration: Duration(seconds: duration),
    ));
  }
}
