import 'package:get/get.dart';

import '../controllers/proficiency_controller.dart';

class ProficiencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProficiencyController>(
      () => ProficiencyController(),
    );
  }
}
