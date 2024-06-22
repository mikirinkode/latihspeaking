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
  final conversationThemeList = <ConversationTheme>[
    ConversationTheme(
        emoji: ":briefcase:", theme: "Asking for a raise at work"),
    ConversationTheme(emoji: ":school:", theme: "Back to school preparation"),
    ConversationTheme(emoji: ":gift:", theme: "Buying a birthday present"),
    ConversationTheme(emoji: ":tv:", theme: "Buying a new TV"),
    ConversationTheme(emoji: ":camera:", theme: "Buying a new camera"),
    ConversationTheme(emoji: ":computer:", theme: "Buying a new laptop"),
    ConversationTheme(
        emoji: ":convenience_store:",
        theme: "Buying snacks at a convenience store"),
    ConversationTheme(
        emoji: ":camera:", theme: "Capturing memories on vacation"),
    ConversationTheme(
        emoji: ":gift:", theme: "Celebrating a friend's birthday"),
    ConversationTheme(
        emoji: ":hotel:", theme: "Checking in at a hotel for a business trip"),
    ConversationTheme(
        emoji: ":office:", theme: "Coordinating a project with a team"),
    ConversationTheme(
        emoji: ":book:", theme: "Discussing a book with a book club"),
    ConversationTheme(
        emoji: ":computer:",
        theme: "Discussing computer hardware with a friend"),
    ConversationTheme(
        emoji: ":computer:", theme: "Discussing new gadgets with a colleague"),
    ConversationTheme(
        emoji: ":camera:", theme: "Discussing photography with an enthusiast"),
    ConversationTheme(
        emoji: ":movie_camera:", theme: "Discussing the latest movies"),
    ConversationTheme(
        emoji: ":camera:", theme: "Discussing travel plans and taking photos"),
    ConversationTheme(emoji: ":school_satchel:", theme: "First day of school"),
    ConversationTheme(emoji: ":toilet:", theme: "Fixing a leaky toilet"),
    ConversationTheme(
        emoji: ":convenience_store:",
        theme: "Going to convenience store with mom"),
    ConversationTheme(emoji: ":house:", theme: "House hunting with a friend"),
    ConversationTheme(
        emoji: ":telephone:", theme: "Making a doctor's appointment"),
    ConversationTheme(
        emoji: ":phone:", theme: "Making a phone call to a customer service"),
    ConversationTheme(
        emoji: ":telephone:",
        theme: "Making a phone call to a customer service representative"),
    ConversationTheme(
        emoji: ":fork_and_knife:",
        theme: "Making a reservation at a restaurant"),
    ConversationTheme(
        emoji: ":calendar:",
        theme: "Making plans with a friend for the weekend"),
    ConversationTheme(emoji: ":house:", theme: "Moving into a new home"),
    ConversationTheme(emoji: ":bank:", theme: "Opening a new bank account"),
    ConversationTheme(emoji: ":pizza:", theme: "Ordering food at a restaurant"),
    ConversationTheme(
        emoji: ":convenience_store:",
        theme: "Picking up groceries at a convenience store"),
    ConversationTheme(
        emoji: ":post_office:", theme: "Sending a package to a loved one"),
    ConversationTheme(
        emoji: ":alarm_clock:", theme: "Setting goals for the new year"),
    ConversationTheme(
        emoji: ":department_store:",
        theme: "Shopping for clothes with a friend"),
    ConversationTheme(
        emoji: ":house:", theme: "Showing a friend around your new apartment"),
    ConversationTheme(emoji: ":camera:", theme: "Taking a photography class"),
    ConversationTheme(
        emoji: ":factory:", theme: "Taking a tour of a local factory"),
    ConversationTheme(
        emoji: ":school:", theme: "Talking about school life with friends"),
    ConversationTheme(
        emoji: ":school:", theme: "Talking to a classmate about an assignment"),
    ConversationTheme(
        emoji: ":hospital:", theme: "Visiting a friend at the hospital"),
    ConversationTheme(emoji: ":elephant:", theme: "Visiting a zoo")
  ].obs;

  final conversationType = "".obs;

  @override
  void onInit() {
    super.onInit();
    conversationType(Get.arguments["CONVERSATION_TYPE"]);
    // getConversationList();
    conversationThemeList.sort((a, b) => a.theme.compareTo(b.theme));

    Get.log("result list: $conversationThemeList");
    Get.log("list length: ${conversationThemeList.length}");
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

        resultList.sort((a, b) => a.theme.compareTo(b.theme));

        Get.log("result list: $resultList");
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
