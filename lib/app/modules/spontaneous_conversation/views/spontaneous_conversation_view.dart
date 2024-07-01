import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speaking/app/global_widgets/loading_indicator.dart';
import 'package:speaking/app/modules/playground/views/playground_view.dart';

import '../../../core/theme/app_color.dart';
import '../../../global_widgets/button_widget.dart';
import '../../../global_widgets/in_chat_loading.dart';
import '../../conversation/views/conversation_view.dart';
import '../controllers/spontaneous_conversation_controller.dart';

class SpontaneousConversationView
    extends GetView<SpontaneousConversationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.isShowFeedback.value)
          ? Scaffold(
              appBar: AppBar(
                title: Text("Feedback"),
                centerTitle: true,
              ),
              body: (controller.isGeneratingFeedback.value)
                  ? LoadingIndicator()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ConversationFeedbackCard(
                                feedback: controller.feedback.value,
                                translatedFeedback:
                                    controller.translatedFeedback.value,
                                translateFeedback: () {
                                  controller.translatedFeedback();
                                }),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                  text: "Selesai",
                                  onPressed: () {
                                    Get.back();
                                  }),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                          ],
                        ),
                      ),
                    ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(controller.theme.value),
                centerTitle: true,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: controller.isLoading.value
                  ? Container()
                  : controller.isFinished.value
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "🎉 Yeay! kamu telah menyelesaikan percakapan ini!",
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SecondaryButton(
                                text: "Lihat Feedback",
                                onPressed: () {
                                  controller.showFeedback();
                                },
                              ),
                            ],
                          ),
                        )
                      : !(controller.isConversationOnGoing.value)
                          ? (controller.conversationMessages.length <= 1) ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Gagal mengambil data",
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Saat ini server sedang ramai, \nharap coba beberapa saat lagi.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PrimaryButton(
                          text: "Coba Lagi",
                          onPressed: () {
                            controller.getInitialConversation();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ) : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  top: 24, right: 24, left: 24),
                              child: PrimaryButton(
                                  text: "Mulai Sekarang",
                                  onPressed: () {
                                    controller.startConversation();
                                  }),
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
                                backgroundColor:
                                    controller.isSpeakingEnabled.value
                                        ? AppColor.PRIMARY_500
                                        : AppColor.NEUTRAL_200,
                                foregroundColor:
                                    controller.isSpeakingEnabled.value
                                        ? Colors.white
                                        : AppColor.NEUTRAL_400,
                                child: Icon(controller.isListening
                                    ? Icons.stop
                                    : Icons.mic),
                              )),
              body: Obx(() => controller.isLoading.value
                  ? LoadingIndicator()
                  : controller.conversationMessages.length <= 1 ? Container() : SingleChildScrollView(
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
                                return ChatWidget(
                                    message: e.value.content,
                                    role: e.value.role,
                                    translatedMessage:
                                        e.value.translation ?? "",
                                    translate: () {
                                      controller.getTranslation(e.value, e.key);
                                    });
                                // ThemedChatWidget(
                                //   message: e.value.content,
                                //   role: e.value.role,
                                //   translatedMessage: e.value.translation ?? "",
                                //   isFocusedMessage: false,
                                //   currentSaidText: controller.text,
                                //   textSaidByUser: "",
                                //   translate: () {});
                              }).toList(),
                            ),
                            controller.isListening
                                ? ChatWidget(
                                    role: "user",
                                    message: controller.text,
                                    translatedMessage: "",
                                    translate: () {},
                                  )
                                : Container(),
                            controller.isGeneratingResponse
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: 16, right: 64, left: 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: InChatLoading(),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )),
            ),
    );
  }
}

class ConversationFeedbackCard extends StatelessWidget {
  final String feedback;
  final String translatedFeedback;
  final Function() translateFeedback;

  const ConversationFeedbackCard(
      {required this.feedback,
      required this.translatedFeedback,
      required this.translateFeedback,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          MarkdownBody(
            data: feedback,
          ),
          TranslationSection(
              translatedMessage: translatedFeedback,
              translate: () {
                translateFeedback();
              })
        ],
      ),
    );
  }
}
