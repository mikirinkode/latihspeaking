import 'package:get/get.dart';

import '../controllers/embedded_web_controller.dart';

class EmbeddedWebBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmbeddedWebController>(
      () => EmbeddedWebController(),
    );
  }
}
