import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/theme/app_color.dart';
import '../controllers/playground_controller.dart';

class PlaygroundView extends GetView<PlaygroundController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(controller.pageTitle.value),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
            animate: controller.isListening,
            glowColor: AppColor.PRIMARY_500,
            // endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            // repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              onPressed: () {
                controller.startListening();
              },
              backgroundColor: AppColor.PRIMARY_500,
              foregroundColor: Colors.white,
              child: Icon(controller.isListening ? Icons.stop : Icons.mic),
            )),
        body: controller.messages.isEmpty && !controller.isListening
            ? Center(
          child: Text(controller.text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
        )
            : SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 150.0),
            child: Column(
              children: [
                Column(
                  children:
                  controller.messages.asMap().entries.map((entry) {
                    var isUser = entry.value.role == "user";
                    return ChatWidget(
                      message: entry.value.content ?? "",
                      role: entry.value.role,
                      translatedMessage: entry.value.translation ?? "",
                      translate: () {
                        controller.getTranslation(entry.value, entry.key);
                      },
                    );
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
                  padding:
                  EdgeInsets.only(top: 16, right: 64, left: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor.PRIMARY_100),
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
        ),
      ),
    );
  }
}


class ChatWidget extends StatelessWidget {
  final String message;
  final String role;
  final String translatedMessage;
  final Function() translate;

  const ChatWidget(
      {required this.message,
        required this.role,
        required this.translatedMessage,
        required this.translate,
        super.key});

  @override
  Widget build(BuildContext context) {
    var isUser = role == "user";
    return (role == "system")
        ? const SizedBox()
    // Padding(
    //       padding: const EdgeInsets.only(top: 16.0),
    //       child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(16),
    //             color: Colors.white,
    //           ),
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(message),
    //         ),
    //     )
        : Padding(
      padding: EdgeInsets.only(
          top: 16, right: isUser ? 0 : 16, left: isUser ? 16 : 0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color:
                isUser ? AppColor.PRIMARY : Colors.white),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                MarkdownBody(
                  data: message,
                  styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
                isUser
                    ? const SizedBox()
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          translate();
                        },
                        icon: const Icon(
                          Icons.translate,
                          size: 16,
                        )),
                    translatedMessage.isEmpty
                        ? const SizedBox()
                        : Flexible(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 8.0),
                        child: MarkdownBody(
                            data: translatedMessage,
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                fontSize: 14,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
