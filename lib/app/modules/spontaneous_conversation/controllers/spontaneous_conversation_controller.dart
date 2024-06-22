import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../../../../constants.dart';
import '../../../data/model/conversation_message.dart';
import '../../../data/model/groq_message.dart';
import '../../../data/model/groq_response.dart';
import '../../../data/provider/api_provider.dart';
import '../../../data/provider/speech_recognizer.dart';
import '../../../utils/text_utils.dart';

class SpontaneousConversationController extends GetxController {
  // for initial message prompt
  // final _initialMessages = <GroqMessage>[].obs;

  final isLoading = false.obs;
  final _isGeneratingResponse = false.obs;

  bool get isGeneratingResponse => _isGeneratingResponse.value;
  final theme = "".obs;

  // conversation
  final conversationMessages = <GroqMessage>[].obs;

  final isConversationOnGoing = false.obs;
  final isFinished = false.obs;
  final isSpeakingEnabled = true.obs; // TODO: LATER
  // final currentFocusedMessage = (-1).obs;
  final _isSpeechRecognizerEnabled = false.obs;

  final _isListening = false.obs;

  bool get isListening => _isListening.value;

  final _text = "".obs;

  String get text => _text.value;

  final selectedVoice = "".obs;

  // final currentConversationLength = 0.obs;

  /// Object
  late FlutterTts _tts;
  late GoogleTranslator _translator;

  @override
  void onInit() {
    super.onInit();
    // theme("Trip to Bali, Indonesia");
    theme(Get.arguments["CONVERSATION_THEME"]);
    _initVoiceChat();
    getInitialConversation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    Get.find<SpeechRecognizer>().onClose();
    _tts.stop();
  }

  Future<void> _initVoiceChat() async {
    selectedVoice("Female");
    _tts = FlutterTts();
    _translator = GoogleTranslator();

    _isSpeechRecognizerEnabled.value =
        Get.find<SpeechRecognizer>().isEnabled;

    if (selectedVoice.value == "Male") {
      _tts.setVoice({"name": "Google UK English Male", "locale": "en-GB"});
    } else {
      _tts.setVoice({"name": "Google UK English Female", "locale": "en-GB"});
    }

    _tts.setErrorHandler((message) {
      Get.log("onStatus: tts error: $message");
    });
    Get.log("selected voice: ${selectedVoice.value}");

    // _initialMessages.add(GroqMessage("system",
    //     SystemPromptTemplate.getSpontanConversationPractice(theme.value)));
    conversationMessages.add(GroqMessage("system",
        SystemPromptTemplate.getSpontanConversationPractice(theme.value, conversationMessages.length)));
  }

  Future<void> getInitialConversation() async {
    Get.log("getInitialConversation Called()");
    isLoading.value = true;
    List<GroqMessage> initialMessages = [
      GroqMessage("system",
          SystemPromptTemplate.getInitialSpontanConversationPractice(theme.value)),
      // GroqMessage("user",
      //     "create initial message for the given theme. could be greeting, question or other to start our conversation. only response on JSON format do not add any other words or sentence outside the JSON")
    ];
    try {
      await Get.find<ApiProvider>()
          .getFormattedResponse(initialMessages)
          .then((groqResponse) {
        _text.value = "";
        var decoded = jsonDecode(groqResponse.choices.first.message.content);

        final resultList = List.from(decoded["conversations"])
            .map((conv) => GroqMessage.fromJson(conv))
            .toList();
        Get.log("list length: ${resultList.length}");
        final result = resultList.first;

        conversationMessages.add(result);
        _speak(TextUtils.removeAsterisk(result.content));
        isLoading.value = false;
      }).onError((error, stackTrace) {
        Get.log("onError: $error");
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      Get.log("error: $e");
    }
  }

  startListening() async {
    _text.value = "";
    continueListening();
  }

  continueListening() async {
    Get.log("continueListening() called");
    _tts.stop();
    if (_isSpeechRecognizerEnabled.value) {
      _isListening.value = true;
      Get.find<SpeechRecognizer>().continueListening(
          onResultCallback: (String val) {
            if (kIsWeb) {
              _text.value = val;
            } else {
              if (!_text.value.contains(val)) {
                _text.value = "${_text.value} ${val}";
              }
            }
          });
    }
  }

  stopListening() async {
    Get.log("stopListening() called");
    _isListening.value = false;
    conversationMessages.add(GroqMessage("user", text));
    conversationMessages[0] = GroqMessage("system",
        SystemPromptTemplate.getSpontanConversationPractice(theme.value, conversationMessages.length));
    Get.find<SpeechRecognizer>().stopListening();
    _getModelResponse();
  }

  _getModelResponse() async {
    _isGeneratingResponse.value = true;
    Get.log("onStatus: _getModelResponse($_text)");
    List<GroqMessage> inputtedMessages = [];
    if (conversationMessages.length <= 3){
      inputtedMessages.addAll(conversationMessages);
    } else {
      inputtedMessages.addAll(conversationMessages);
      var lastMessage = conversationMessages.last;
      var lastIndex = conversationMessages.length -1;
      inputtedMessages[lastIndex] = GroqMessage("user", """
currentLength is 4, you have to end this conversation. reply below message and end the conversation.
userMessage : ${lastMessage.content}
""");
    }
    try {
      await Get.find<ApiProvider>()
          .getModelResponse(inputtedMessages)
          .then((groqResponse) {
        _text.value = "";
        _isGeneratingResponse.value = false;
        var result = groqResponse.choices.first.message.content;
        conversationMessages.add(GroqMessage("assistant", result));
        conversationMessages[0] = GroqMessage("system",
            SystemPromptTemplate.getSpontanConversationPractice(theme.value, conversationMessages.length));
        _speak(TextUtils.removeAsterisk(result));

        if (result.contains("[CONVERSATION COMPLETED]")){
          isFinished.value = true;
        }
      }).onError((error, stackTrace) {
        _isGeneratingResponse.value = false;
        Get.log("onError: $error");
      });
    } catch (e) {
      _isGeneratingResponse.value = false;
      Get.log("error: $e");
    }
  }

  void _speak(String input) {
    Get.log("onStatus: speaking");
    _tts.speak(input).onError((error, stackTrace) {
      Get.log("onStatus: speaking error: $error");
    });
  }
}
