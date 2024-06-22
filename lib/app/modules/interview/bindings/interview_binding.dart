import 'package:get/get.dart';

import '../controllers/interview_controller.dart';

class InterviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterviewController>(
      () => InterviewController(),
    );
  }
}
