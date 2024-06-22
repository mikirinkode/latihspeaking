import 'package:get/get.dart';

import '../controllers/interview_setup_controller.dart';

class InterviewSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewSetupController>(
      () => InterviewSetupController(),
    );
  }
}
