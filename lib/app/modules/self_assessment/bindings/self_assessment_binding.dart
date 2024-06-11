import 'package:get/get.dart';

import '../controllers/self_assessment_controller.dart';

class SelfAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelfAssessmentController>(
      () => SelfAssessmentController(),
    );
  }
}
