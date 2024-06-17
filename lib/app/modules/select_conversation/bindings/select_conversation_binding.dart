import 'package:get/get.dart';

import '../controllers/select_conversation_controller.dart';

class SelectConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectConversationController>(
      () => SelectConversationController(),
    );
  }
}
