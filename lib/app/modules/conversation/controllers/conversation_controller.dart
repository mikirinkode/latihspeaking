import 'dart:convert';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../../../../constants.dart';
import '../../../data/model/conversation_message.dart';
import '../../../data/model/groq_message.dart';
import '../../../data/model/groq_response.dart';

class ConversationController extends GetxController {
  // for initial message prompt
  final messages = <GroqMessage>[].obs;

  final isLoading = false.obs;
  final theme = "".obs;

  // conversation
  final conversationMessages = <ConversationMessage>[].obs;
  final shownMessages = <ConversationMessage>[].obs;

  final isConversationOnGoing = false.obs;
  final isFinished = false.obs;
  final isSpeakingEnabled = true.obs; // TODO: LATER
  final currentFocusedMessage = (-1).obs;
  // final ttsState = TtsState.stopped.obs;

  final _isListening = false.obs;

  bool get isListening => _isListening.value;

  final _text = "".obs;

  String get text => _text.value;

  final selectedVoice = "".obs;

  /// Object
  late SpeechToText _speech;
  late FlutterTts _tts;
  late GoogleTranslator _translator;

  @override
  void onInit() {
    super.onInit();
    // theme("Trip to Bali, Indonesia");
    theme(Get.arguments["CONVERSATION_THEME"]);
    _initVoiceChat();
    getConversation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _speech.stop();
    _tts.stop();
  }

  void _initVoiceChat() {
    selectedVoice("Female");
    _speech = SpeechToText();
    _tts = FlutterTts();
    _translator = GoogleTranslator();

    if (selectedVoice.value == "Male") {
      _tts.setVoice({"name": "Google UK English Male", "locale": "en-GB"});
    } else {
      _tts.setVoice({"name": "Google UK English Female", "locale": "en-GB"});
    }

    _tts.setErrorHandler((message) {
      Get.log("onStatus: tts error: $message");
    });
    Get.log("selected voice: ${selectedVoice.value}");
  }

  Future<void> getConversation() async {
    Get.log("on get conversation message list");
    messages.addAll([
      GroqMessage(
          "system", SystemPromptTemplate.getConversationPractice(theme.value)),
      GroqMessage("user",
          "create an english conversation practice for theme : ${theme.value}")
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
            .map((conv) => ConversationMessage.fromJson(conv))
            .toList();
        Get.log("list length: ${resultList.length}");

        conversationMessages.addAll(resultList);
        shownMessages.add(resultList.first);
        shownMessages.add(resultList.elementAt(1));
      } else {
        Get.log("error: ${apiResponse.body}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.log("error: $e");
    }
  }

  void startConversation() {
    currentFocusedMessage.value = 0;
    isConversationOnGoing.value = true;
    if (isConversationOnGoing.value) {
      Get.log("CurrentMessageIndex: $currentFocusedMessage");
      ConversationMessage currentMessage =
          conversationMessages.elementAt(currentFocusedMessage.value);
      _speak(currentMessage.content);
    }
  }

  void _speak(String input) {
    Get.log("onStatus: speaking playing");

    _tts.speak(input).onError((error, stackTrace) {
      Get.log("onStatus: speaking error: $error");
    });
  }

  startListening() async {
    _tts.stop();
    if (!isListening) {
      bool available = await _speech.initialize(
          // onStatus: (val) => Get.log("onStatus: $val"),
          // onError: (val) => Get.log("onError: $val"),
          );
      if (available) {
        Get.log("onStatus: speech start listening");
        _nextMessage();
        _text.value = "";
        _isListening.value = true;
        _speech.listen(
            onResult: (val) => {
                  _text.value = val.recognizedWords,
                  // if (val.hasConfidenceRating && val.confidence > 0)
                  //   {_confidence.value = val.confidence}
                });
      }
    } else {
      _isListening.value = false;
      _speech.stop();
      Get.log("onStatus: listening done");
      // update the previous message
      ConversationMessage currentMessage =
          conversationMessages.elementAt(currentFocusedMessage.value);

      ConversationMessage updatedMessage = ConversationMessage(
          role: currentMessage.role,
          content: currentMessage.content,
          wordSaidByUser: text);
      shownMessages[currentFocusedMessage.value] = updatedMessage;

      // show next message
      shownMessages
          .add(conversationMessages.elementAt(currentFocusedMessage.value + 1));

      if (currentFocusedMessage.value + 2 < conversationMessages.length - 1) {
        // show the user too
        shownMessages.add(
            conversationMessages.elementAt(currentFocusedMessage.value + 2));
      }

      Get.log("onStatus: next messages displayed");
      _nextMessage();
      _continueConversation();
    }
  }

  void _continueConversation() {
    if (isConversationOnGoing.value) {
      Get.log("CurrentMessageIndex: $currentFocusedMessage");
      ConversationMessage currentMessage =
          conversationMessages.elementAt(currentFocusedMessage.value);
      _speak(currentMessage.content);
    } else {
      Get.log("CurrentMessageIndex: $currentFocusedMessage");
      ConversationMessage currentMessage = conversationMessages.last;
      _speak(currentMessage.content);
      Get.log("Speak last message");
      Get.log("Conversation is DONE");
    }
  }

  void _nextMessage() {
    if (currentFocusedMessage.value + 1 <= conversationMessages.length - 1) {
      currentFocusedMessage.value = currentFocusedMessage.value + 1;
      Get.log("CurrentMessageIndex changed to: $currentFocusedMessage");
      if (currentFocusedMessage.value == conversationMessages.length - 1) {
        Get.log("CurrentMessageIndex has reach the last");
        isConversationOnGoing.value = false;
        isFinished.value = true;
      }
    } else {
      Get.log("ELSE CurrentMessageIndex has reach the last");
      isConversationOnGoing.value = false;
    }
  }
}
