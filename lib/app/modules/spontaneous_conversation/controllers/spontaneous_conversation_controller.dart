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

  final feedback = "".obs;
  final translatedFeedback = "".obs;
  final isShowFeedback = false.obs;
  final isGeneratingFeedback = false.obs;

  final _conversationLimit = 10; // NOTE: CHANGE THE LIMIT HERE, should even number

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
  Future<void> onClose() async {
    await Get.find<SpeechRecognizer>().onClose();
    await _tts.stop();
    super.onClose();
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
        SystemPromptTemplate.getSpontanConversationPractice(theme.value, conversationMessages.length, _conversationLimit)));
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
        // _speak(TextUtils.removeAsterisk(result.content)); // TODO
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

  void startConversation(){
    if (conversationMessages.length >= 2){
      var message = conversationMessages[1];
      Get.log("content: ${message.content}");
    _speak(TextUtils.removeAsterisk(message.content));
    isConversationOnGoing.value = true;
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
            _text.value = val;
            // if (kIsWeb) {
            //   _text.value = val;
            // } else {
            //   if (!_text.value.contains(val)) {
            //     _text.value = "${_text.value} ${val}";
            //   }
            // }
          });
    }
  }

  stopListening() async {
    Get.log("stopListening() called");
    _isListening.value = false;
    Get.find<SpeechRecognizer>().stopListening();
    if (text.isNotEmpty){
      conversationMessages.add(GroqMessage("user", text));
      conversationMessages[0] = GroqMessage("system",
          SystemPromptTemplate.getSpontanConversationPractice(theme.value, conversationMessages.length, _conversationLimit));
      _getModelResponse();
    }
  }

  _getModelResponse() async {
    _isGeneratingResponse.value = true;
    Get.log("onStatus: _getModelResponse($_text)");
    List<GroqMessage> inputtedMessages = [];
    if (conversationMessages.length <= (_conversationLimit -1)){ // NOTE: FOR THE LIMIT SHOULD -1 to trigger end conversation
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
            SystemPromptTemplate.getSpontanConversationPractice(theme.value, conversationMessages.length, _conversationLimit));
        _speak(TextUtils.removeAsterisk(result));

        if (result.contains("[CONVERSATION COMPLETED]")){
          isFinished.value = true;
          // _getFeedback();
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

  void showFeedback(){
    _tts.stop();
    isShowFeedback.value = true;
    _getFeedback();
  }

  Future<void> _getFeedback() async {
    isGeneratingFeedback.value = true;
    List<String> conversationMessageJson =
    conversationMessages.map((e) => e.toString()).toList();
    Get.log("conversation json: ${conversationMessageJson}");
    // var x =
    //     "[Conversation(role: assistant, content: Have you ever considered visiting Bali, Indonesia? It's a beautiful island with stunning beaches and temples., wordSaidByUser: null), Conversation(role: user, content: Yes, I've always wanted to go there. I've heard the beaches are amazing., wordSaidByUser: yes I have always wanted to go there I have heard that the beaches are amazing), Conversation(role: assistant, content: They definitely are! Kuta, Seminyak, and Nusa Dua are some of the most popular beaches. Which one would you like to visit first?, wordSaidByUser: null), Conversation(role: user, content: I think I'd like to visit Kuta. I've heard it's a great place for surfers., wordSaidByUser: I think I like to visit Kota I have her it is a great place for soft first), Conversation(role: assistant, content: That's right! Kuta is known for its great surfing spots. Are you planning to try surfing while you're there or just relax on the beach?, wordSaidByUser: null), Conversation(role: user, content: I've never surfed before, but I'd love to try it. Do you know of any good surf schools in Kuta?, wordSaidByUser: I've never heard suffered Pizza but I love to try it do you know any good sort of schools in Qatar), Conversation(role: assistant, content: There are several good surf schools in Kuta. I can recommend Rip Curl School of Surf and Odyssey Surf School. They both have great instructors and equipment., wordSaidByUser: null), Conversation(role: user, content: Thanks for the recommendations. How long do you think I should stay in Bali to get a good feel for the island?, wordSaidByUser: thanks for the recommendation how long do you think I should stay in Bali to get a good feel for the Iceland), Conversation(role: assistant, content: I think at least a week would be good to explore the island and its culture. You could also consider visiting some of the temples, like Tanah Lot or Uluwatu, and experience the local cuisine., wordSaidByUser: null), Conversation(role: user, content: A week sounds like a good amount of time. Do you think I should book my accommodations in advance or wait until I get there?, wordSaidByUser: a week sounds like a good amount of time do you think I should put my accommodation in advance or wait until I get there), Conversation(role: assistant, content: I would recommend booking your accommodations in advance, especially during peak season. You can find some great deals on hotels and villas online. [CONVERSATION COMPLETED], wordSaidByUser: null)]";

    List<GroqMessage> feedbackMessages = [
      GroqMessage(
          "system", SystemPromptTemplate.spontanConversationFeedback(conversationMessageJson.toString())),
      GroqMessage("user", "give feedback for our conversation")
    ];
    await Get.find<ApiProvider>()
        .getModelResponse(feedbackMessages)
        .then((groqResponse) {
      var result = groqResponse.choices.first.message.content;
      feedback.value = result;
      isGeneratingFeedback.value = false;
    });
  }

  void getTranslation(GroqMessage groqMessage, int key) {
    if (groqMessage.translation == null) {
      _translator
          .translate(groqMessage.content, from: "en", to: "id")
          .then((value) {
        Get.log("translated message: ${value.text}");
        GroqMessage updatedMessage = GroqMessage(
            groqMessage.role, groqMessage.content,
            translation: value.text);
        conversationMessages[key] = updatedMessage;
      });
    } else {
      Get.log("onGetTranslation info: there already translation");
    }
  }
  translateFeedback() {
    if (feedback.value.isNotEmpty || translatedFeedback.value.isEmpty) {
      _translator
          .translate(feedback.value, from: "en", to: "id")
          .then((value) {
        Get.log("translated message: ${value.text}");
        translatedFeedback.value = value.text;
      });
    } else {
      Get.log("onGetTranslation info: there already translation or its empty");
    }
  }
}
