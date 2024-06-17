import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speaking/app/global_widgets/button_widget.dart';

import '../../../core/theme/app_color.dart';
import '../controllers/conversation_controller.dart';

class ConversationView extends GetView<ConversationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(controller.theme.value),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (controller.shownMessages.isEmpty)
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
                : !controller.isConversationOnGoing.value
                    ? Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 24, right: 24, left: 24),
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
                              controller.startListening();
                            }
                          },
                          backgroundColor: controller.isSpeakingEnabled.value
                              ? AppColor.PRIMARY_500
                              : AppColor.NEUTRAL_200,
                          foregroundColor: controller.isSpeakingEnabled.value
                              ? Colors.white
                              : AppColor.NEUTRAL_400,
                          child: Icon(
                              controller.isListening ? Icons.stop : Icons.mic),
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
                        children:
                            controller.shownMessages.asMap().entries.map((e) {
                          return ThemedChatWidget(
                              message: e.value.content,
                              role: e.value.role,
                              translatedMessage: e.value.translation ?? "",
                              isFocusedMessage:
                                  controller.currentFocusedMessage.value ==
                                      e.key,
                              currentSaidText: controller.text,
                              textSaidByUser: e.value.wordSaidByUser ?? "",
                              translate: () {});
                        }).toList(),
                      )
                      // ListView.builder(
                      //   itemCount: controller.conversationMessages.length,
                      //   itemBuilder: (context, index) {
                      //     var e = controller.conversationMessages[index];
                      //     return ThemedChatWidget(
                      //         message: e.content,
                      //         role: e.role,
                      //         translatedMessage: e.translation ?? "",
                      //         translate: () {});
                      //   },
                      // ),
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
                                  ? AppColor.PRIMARY_100
                                  : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      color: isUser ? AppColor.PRIMARY_100 : Colors.white),
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
                              : SizedBox()
                      // isUser
                      //     ? const SizedBox()
                      //     : Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           IconButton(
                      //               onPressed: () {
                      //                 translate();
                      //               },
                      //               icon: const Icon(
                      //                 Icons.translate,
                      //                 size: 16,
                      //               )),
                      //           translatedMessage.isEmpty
                      //               ? const SizedBox()
                      //               : Flexible(
                      //                   child: Padding(
                      //                     padding:
                      //                         const EdgeInsets.only(top: 8.0),
                      //                     child: MarkdownBody(
                      //                         data: translatedMessage,
                      //                         styleSheet: MarkdownStyleSheet(
                      //                           p: const TextStyle(
                      //                             fontSize: 14,
                      //                           ),
                      //                         )),
                      //                   ),
                      //                 )
                      //         ],
                      //       ),
                    ],
                  )),
            ),
          );
  }
}
