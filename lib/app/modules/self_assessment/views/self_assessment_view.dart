import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/self_assessment_controller.dart';

class SelfAssessmentView extends GetView<SelfAssessmentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SelfAssessmentView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SelfAssessmentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
