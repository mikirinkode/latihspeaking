import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/theme/app_color.dart';
import '../../../routes/app_pages.dart';
import '../controllers/select_conversation_controller.dart';

class SelectConversationView extends GetView<SelectConversationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Percakapan'),
        centerTitle: true,
      ),
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
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 16),
              itemCount: controller.conversationThemeList.length,
              itemBuilder: (context, index) {
                var e = controller.conversationThemeList[index];
                return ConversationThemeCard(
                  emoji: e.emoji,
                  theme: e.theme,
                  onTap: () {
                    if (controller.conversationType.value == "DIRECTED"){
                      Get.toNamed(Routes.CONVERSATION,
                          arguments: {"CONVERSATION_THEME": e.theme});
                    } else {
                      Get.toNamed(Routes.SPONTANEOUS_CONVERSATION,
                          arguments: {"CONVERSATION_THEME": e.theme});
                    }
                  },
                );
              },
            )),
    );
  }
}

class ConversationThemeCard extends StatelessWidget {
  final String emoji;
  final String theme;
  final Function() onTap;

  const ConversationThemeCard(
      {required this.emoji,
      required this.theme,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    MarkdownBody(
                      data: emoji,
                      styleSheet:
                          MarkdownStyleSheet(p: TextStyle(fontSize: 18)),
                      extensionSet: md.ExtensionSet(
                        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                        <md.InlineSyntax>[
                          md.EmojiSyntax(),
                          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        theme,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColor.NEUTRAL_700,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
