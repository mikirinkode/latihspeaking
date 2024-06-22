import 'package:get/get.dart';

import '../controllers/spontaneous_conversation_controller.dart';

class SpontaneousConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpontaneousConversationController>(
      () => SpontaneousConversationController(),
    );
  }
}
