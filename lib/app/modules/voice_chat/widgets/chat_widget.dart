import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:voicechat/app/core/theme/app_color.dart';

class ChatWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final String translatedMessage;
  final Function() translate;

  const ChatWidget(
      {required this.message,
      required this.isUser,
      required this.translatedMessage,
      required this.translate,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 16, right: isUser ? 0 : 16, left: isUser ? 16 : 0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isUser ? AppColor.PRIMARY_500 : AppColor.PRIMARY_100),
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
                              : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Flexible(
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
