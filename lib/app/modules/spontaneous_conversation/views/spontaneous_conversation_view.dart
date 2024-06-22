import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/theme/app_color.dart';
import '../../conversation/views/conversation_view.dart';
import '../controllers/spontaneous_conversation_controller.dart';

class SpontaneousConversationView
    extends GetView<SpontaneousConversationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.theme.value),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: controller.isLoading.value
            ? Container()
            : controller.isFinished.value
                ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      "🎉 Yeay! kamu telah menyelesaikan percakapan ini!",
                      textAlign: TextAlign.center,
                    ),
                  )
                : AvatarGlow(
                    animate: controller.isListening,
                    glowColor: AppColor.PRIMARY_500,
                    // endRadius: 75.0,
                    duration: const Duration(milliseconds: 2000),
                    // repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (controller.isSpeakingEnabled.value) {
                          if (controller.isListening) {
                            controller.stopListening();
                          } else {
                            controller.startListening();
                          }
                        }
                      },
                      backgroundColor: controller.isSpeakingEnabled.value
                          ? AppColor.PRIMARY_500
                          : AppColor.NEUTRAL_200,
                      foregroundColor: controller.isSpeakingEnabled.value
                          ? Colors.white
                          : AppColor.NEUTRAL_400,
                      child:
                          Icon(controller.isListening ? Icons.stop : Icons.mic),
                    )),
        body: Obx(() => controller.isLoading.value
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white),
                  padding: const EdgeInsets.all(16),
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppColor.PRIMARY_500, size: 24),
                ),
              )
            : SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 150.0),
                  child: Column(
                    children: [
                      Column(
                        children: controller.conversationMessages
                            .asMap()
                            .entries
                            .map((e) {
                          return ThemedChatWidget(
                              message: e.value.content,
                              role: e.value.role,
                              translatedMessage: e.value.translation ?? "",
                              isFocusedMessage: false,
                              currentSaidText: controller.text,
                              textSaidByUser: "",
                              translate: () {});
                        }).toList(),
                      ),
                      controller.isListening
                          ? ThemedChatWidget(
                              role: "user",
                              message: controller.text,
                              translatedMessage: "",
                              isFocusedMessage: false,
                              currentSaidText: controller.text,
                              textSaidByUser: "",
                              translate: () {},
                            )
                          : Container(),
                      controller.isGeneratingResponse
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: 16, right: 64, left: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: LoadingAnimationWidget.waveDots(
                                      color: AppColor.PRIMARY_500, size: 24),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              )),
      ),
    );
  }
}
