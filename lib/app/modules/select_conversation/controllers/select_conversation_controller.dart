import 'dart:convert';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../../../../constants.dart';
import '../../../data/model/conversation_theme.dart';
import '../../../data/model/groq_message.dart';
import '../../../data/model/groq_response.dart';

class SelectConversationController extends GetxController {
  final messages = <GroqMessage>[].obs;
  final isLoading = false.obs;
  final conversationThemeList = <ConversationTheme>[].obs;

  @override
  void onInit() {
    super.onInit();
    getConversationList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future<void> getConversationList() async {
    Get.log("on get conversation list");
    messages.addAll([
      GroqMessage("system", SystemPromptTemplate.getConversationalList),
      GroqMessage("user", "give me a list of 10 conversational theme")
    ]);
    var uri = "https://api.groq.com/openai/v1/chat/completions";
    var headers = {
      'Content-Type': "application/json; charset=UTF-8",
      "Authorization": "Bearer ${Constants.GROQ_API_KEY}"
    };
    var body = jsonEncode(<String, dynamic>{
      "messages": messages.map((element) => element.toJson()).toList(),
      "model": "llama3-70b-8192",
      "response_format": {"type": "json_object"},
    });

    try {
      isLoading.value = true;
      final apiResponse = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: body,
      );
      isLoading.value = false;
      if (apiResponse.statusCode == 200) {
        Get.log("result: ${apiResponse.body}");
        final groqResponse =
            GroqResponse.fromJson(jsonDecode(apiResponse.body));
        Get.log("groqResponse: ${groqResponse.choices.first.message.content}");

        var decoded = jsonDecode(groqResponse.choices.first.message.content);

        final resultList = List.from(decoded["conversations"])
            .map((conv) => ConversationTheme.fromJson(conv))
            .toList();
        Get.log("list length: ${resultList.length}");
        conversationThemeList.addAll(resultList);
      } else {
        Get.log("error: ${apiResponse.body}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.log("error: $e");
    }
  }
}
