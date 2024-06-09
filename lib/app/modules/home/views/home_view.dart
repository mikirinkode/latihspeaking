import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:voicechat/app/core/theme/app_color.dart';
import 'package:voicechat/app/global_widgets/button_widget.dart';
import 'package:voicechat/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColor.PRIMARY_500,
        title: const Text('VoiceChat App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.PRIMARY_100,
                  border: Border.all(
                    width: 2,
                    color: AppColor.PRIMARY_500,
                  ),
                  borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Welcome!",
                    style: TextStyle(
                        color: AppColor.PRIMARY_500,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                      "Disini kamu bisa coba latih speaking bahasa inggris, chatting santai atau tanya hal lainnya. Gratis!")
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Supported Language",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomChip(title: "English")
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customize your AI Buddy",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "Voice Model",
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          children: controller.voiceList
                              .map((e) => VoiceCard(
                                    name: e.name,
                                    locale: e.locale,
                                    isSelected: e.name ==
                                        controller.selectedVoice.value,
                                    onCardTapped: () {
                                      controller
                                          .changeSelectedVoiceModel(e.name);
                                    },
                                  ))
                              .toList()),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        "AI Model",
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          children: controller.aiList
                              .map((e) => VoiceCard(
                                    name: e.name,
                                    locale: e.locale,
                                    isSelected: e.name ==
                                        controller.selectedAIModel.value,
                                    onCardTapped: () {
                                      controller.changeSelectedAIModel(e.name);
                                    },
                                  ))
                              .toList()),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                            text: "Play",
                            enabled: controller.selectedVoice.isNotEmpty,
                            onPressed: () {
                              if (controller.selectedAIModel.value ==
                                  "Gemini AI") {
                                Get.toNamed(Routes.VOICE_CHAT, arguments: {
                                  "VOICE_MODEL": controller.selectedVoice.value
                                });
                              } else {
                                Get.toNamed(Routes.GROQCHAT, arguments: {
                                  "VOICE_MODEL": controller.selectedVoice.value
                                });
                              }
                            }),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                          "*Aplikasi ini menggunakan alat bawaan device kamu untuk analisa suara, jdi ada kemungkinan muncul masalah atau jawaban yang tidak akurat.",
                      style: TextStyle(color: AppColor.NEUTRAL_400, fontStyle: FontStyle.italic),)
                    ],
                  ),
                ),
              )),
        ],
      )),
    );
  }
}

class VoiceCard extends StatelessWidget {
  final String name;
  final String locale;
  final bool isSelected;
  final Function() onCardTapped;

  const VoiceCard(
      {required this.name,
      required this.locale,
      required this.isSelected,
      required this.onCardTapped,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 2,
                  color:
                      isSelected ? AppColor.PRIMARY_500 : AppColor.NEUTRAL_200),
              borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(locale)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String title;

  const CustomChip({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.PRIMARY_100, borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(
            color: AppColor.PRIMARY_500,
            fontSize: 14,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
