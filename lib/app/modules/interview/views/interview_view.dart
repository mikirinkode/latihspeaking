import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speaking/app/global_widgets/in_chat_loading.dart';

import '../../../core/theme/app_color.dart';
import '../../playground/views/playground_view.dart';
import '../controllers/interview_controller.dart';

class InterviewView extends GetView<InterviewController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Ruang Interview"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: controller.isFinished.value
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "🎉 Yeay! kamu telah menyelesaikan latihan interview!",
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
                    controller.isListening
                        ? controller.stopListening()
                        : controller.startListening();
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
                                child: InChatLoading(),
                              ),
                            )
                          : Container(),
                      controller.feedback.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: MarkdownBody(
                                  data: controller.feedback.value,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
