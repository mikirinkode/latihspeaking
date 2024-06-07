import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/voice_chat_controller.dart';

class VoiceChatView extends GetView<VoiceChatController> {
  const VoiceChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
              "Your Confidence: ${(controller.confidence * 100.0).toStringAsFixed(1)}%"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
            animate: controller.isListening,
            glowColor: Theme.of(context).primaryColor,
            // endRadius: 75.0,
            duration: const Duration(milliseconds: 2000),
            // repeatPauseDuration: const Duration(milliseconds: 100),
            repeat: true,
            child: FloatingActionButton(
              onPressed: () {
                controller.startListening();
              },
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              child: Icon(controller.isListening ? Icons.stop : Icons.mic),
            )),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: Column(
              children: [
                Column(
                  children: controller.messages.map((e) {
                    var id = (e.id ?? 0);
                    var isUser = id % 2 == 0;
                    return Padding(
                      padding: EdgeInsets.only(
                          top: 16,
                          right: isUser ? 0 : 64,
                          left: isUser ? 64 : 0),
                      child: Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              color: isUser
                                  ? Color.fromARGB(255, 65, 33, 243)
                                  : Color.fromARGB(255, 232, 234, 255)),
                          padding: const EdgeInsets.all(16.0),
                          child: Text(e.message ?? "",
                              style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                controller.messages.isEmpty && !controller.isListening
                    ? Text(controller.text,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400))
                    : Container(),
                controller.isListening
                    ? Padding(
                        padding: EdgeInsets.only(top: 16, right: 0, left: 64),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 65, 33, 243)),
                            padding: const EdgeInsets.all(16.0),
                            child: Text(controller.text,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      )
                    : Container(),
                controller.isGeneratingResponse
                    ? Padding(
                        padding: EdgeInsets.only(top: 16, right: 64, left: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 232, 234, 255)),
                            padding: const EdgeInsets.all(16.0),
                            child: Text(controller.response,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400)),
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
