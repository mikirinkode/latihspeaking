import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:speaking/app/global_widgets/button_widget.dart';
import 'package:speaking/app/modules/spontaneous_conversation/views/spontaneous_conversation_view.dart';

import '../../../core/theme/app_color.dart';
import '../../../global_widgets/loading_indicator.dart';
import '../../playground/views/playground_view.dart';
import '../controllers/conversation_controller.dart';

class ConversationView extends GetView<ConversationController> {
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
                            const SizedBox(height: 16,),
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                  text: "Selesai",
                                  onPressed: () {
                                    Get.back();
                                  }),
                            ),
                            const SizedBox(height: 32,),
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
              floatingActionButton: (controller.shownMessages.isEmpty)
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
                          ? Container(
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
                  : controller.shownMessages.isEmpty
                      ? Center(
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
                                      controller.getConversation();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          reverse: true,
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0, 16, 150.0),
                            child: Column(
                              children: [
                                Column(
                                  children: controller.shownMessages
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    return ThemedChatWidget(
                                        message: e.value.content,
                                        role: e.value.role,
                                        translatedMessage:
                                            e.value.translation ?? "",
                                        isFocusedMessage: controller
                                                .currentFocusedMessage.value ==
                                            e.key,
                                        currentSaidText: controller.text,
                                        textSaidByUser:
                                            e.value.wordSaidByUser ?? "",
                                        translate: () {
                                          controller.getTranslation(
                                              e.value, e.key);
                                        });
                                  }).toList(),
                                ),
                                // TODO [WIP] : CONTINUE LATER
                                // controller.conversationFeedback.value == null
                                //     ? Container()
                                //     : Column(
                                //       children: [
                                //         const SizedBox(height: 16,),
                                //         Text("Here is feedback for our conversation: "),
                                //         Padding(
                                //             padding: const EdgeInsets.only(top: 16.0),
                                //             child: Container(
                                //                 padding: EdgeInsets.all(16),
                                //                 decoration: BoxDecoration(
                                //                   color: Colors.white,
                                //                   borderRadius: BorderRadius.circular(16),
                                //                 ),
                                //                 child: Column(
                                //                   children: [
                                //                     Container(
                                //                       padding: EdgeInsets.all(16),
                                //                       decoration: BoxDecoration(
                                //                           color: AppColor.PRIMARY_50,
                                //                           borderRadius:
                                //                               BorderRadius.circular(16),
                                //                           border: Border.all(
                                //                               width: 1,
                                //                               color: AppColor.PRIMARY_50)),
                                //                       child: Column(
                                //                         children: [
                                //                           Text(
                                //                             controller.conversationFeedback
                                //                                 .value!.overall!.score
                                //                                 .toString(),
                                //                             style: TextStyle(
                                //                                 color: AppColor.PRIMARY,
                                //                                 fontSize: 24,
                                //                                 fontWeight: FontWeight.w900),
                                //                           ),
                                //                           const SizedBox(
                                //                             height: 8,
                                //                           ),
                                //                           Text("Skor Keseluruhan")
                                //                         ],
                                //                       ),
                                //                     ),
                                //                     const SizedBox(
                                //                       height: 16,
                                //                     ),
                                //                     const SizedBox(
                                //                         width: double.infinity,
                                //                         child: Text(
                                //                           "Feedback",
                                //                           style: TextStyle(
                                //                               fontSize: 18,
                                //                               fontWeight: FontWeight.bold),
                                //                         )),
                                //                     const SizedBox(
                                //                       height: 8,
                                //                     ),
                                //                     controller
                                //                             .translatedFeedback.value.isEmpty
                                //                         ? SizedBox()
                                //                         : MarkdownBody(
                                //                             data: controller
                                //                                 .translatedFeedback.value)
                                //                   ],
                                //                 )),
                                //           ),
                                //       ],
                                //     )
                              ],
                            ),
                          ),
                        )),
            ),
    );
  }
}

class ThemedChatWidget extends StatelessWidget {
  final String message;
  final String role;
  final String translatedMessage;
  final bool isFocusedMessage;
  final String currentSaidText;
  final String textSaidByUser;
  final Function() translate;

  const ThemedChatWidget(
      {required this.message,
      required this.role,
      required this.translatedMessage,
      required this.isFocusedMessage,
      required this.currentSaidText,
      required this.textSaidByUser,
      required this.translate,
      super.key});

  @override
  Widget build(BuildContext context) {
    var isUser = role == "user";
    return (role == "system")
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(
                top: 16, right: isUser ? 0 : 16, left: isUser ? 16 : 0),
            child: Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: isFocusedMessage
                              ? AppColor.PRIMARY
                              : isUser
                                  ? AppColor.PRIMARY_50
                                  : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      color: isUser ? AppColor.PRIMARY_50 : Colors.white),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MarkdownBody(
                        data: message,
                        styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                                color: isUser
                                    ? AppColor.NEUTRAL_700
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      ),
                      (isUser && isFocusedMessage && currentSaidText.isNotEmpty)
                          ? Container(
                              child: Text(
                                currentSaidText,
                                style: TextStyle(
                                    color: AppColor.PRIMARY,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          : textSaidByUser.isNotEmpty
                              ? Text(
                                  textSaidByUser,
                                  style: TextStyle(
                                      color: AppColor.PRIMARY,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                              : SizedBox(),
                      TranslationSection(
                        translatedMessage: translatedMessage,
                        translate: translate,
                      ),
                    ],
                  )),
            ),
          );
  }
}
