import 'package:get/get.dart';

import '../controllers/groqchat_controller.dart';

class GroqchatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroqchatController>(
      () => GroqchatController(),
    );
  }
}
