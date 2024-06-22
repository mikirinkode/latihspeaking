import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:speaking/app/global_widgets/button_widget.dart';

import '../controllers/interview_setup_controller.dart';

class InterviewSetupView extends GetView<InterviewSetupController> {
  @override
  Widget build(BuildContext context) {
    controller.setupInterviewKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Setup Interview'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => Form(
                key: controller.setupInterviewKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      decoration: InputDecoration(
                        labelText: "Posisi",
                        hintText: "Senior Content Writer",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Posisi tidak boleh kosong";
                        }
                        return null;
                      },
                      onChanged: (value) =>
                          controller.jobNameInput.value = value ?? "",
                      onSaved: (value) =>
                          controller.jobNameInput.value = value ?? "",
                      initialValue: "",
                    ),
                    const SizedBox(height: 16,),
                    PrimaryButton(
                        text: "Mulai",
                        enabled: controller.jobNameInput.value != "",
                        onPressed: () {})
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
