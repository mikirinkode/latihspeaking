import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speaking/app/data/provider/speech_recognizer.dart';
import 'package:speaking/constants.dart';
import 'package:translator/translator.dart';

import '../../../data/model/conversation_feedback.dart';
import '../../../data/model/groq_message.dart';
import '../../../data/provider/api_provider.dart';
import '../../../utils/text_utils.dart';

class IntroductionController extends GetxController {
  final _isListening = false.obs;

  bool get isListening => _isListening.value;

  final _isSpeechRecognizerEnabled = false.obs;

  final _isGeneratingResponse = false.obs;

  bool get isGeneratingResponse => _isGeneratingResponse.value;

  final _text = "Press the button and start speaking".obs;

  String get text => _text.value;

  final _response = "".obs;

  String get response => _response.value;

  final messages = <GroqMessage>[].obs;
  final selectedVoice = "".obs;

  final isFinished = false.obs;

  final feedback = "".obs;
  final translatedFeedback = "".obs;
  final isShowFeedback = false.obs;
  final isGeneratingFeedback = false.obs;

  /// Object
  late FlutterTts _tts;
  late GoogleTranslator _translator;

  @override
  void onInit() {
    super.onInit();
    _initVoiceChat();
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
    _isSpeechRecognizerEnabled.value = Get.find<SpeechRecognizer>().isEnabled;

    if (selectedVoice.value == "Male") {
      _tts.setVoice({"name": "Google UK English Male", "locale": "en-GB"});
    } else {
      _tts.setVoice({"name": "Google UK English Female", "locale": "en-GB"});
    }

    _tts.setErrorHandler((message) {
      Get.log("onStatus: tts error: $message");
    });
    Get.log("selected voice: ${selectedVoice.value}");

    // set prompt
    messages.add(GroqMessage("system", SystemPromptTemplate.selfAssessment));
  }

  Future<void> _getModelResponse() async {
    _isGeneratingResponse.value = true;
    Get.log("onStatus: _getModelResponse($_text)");

    try {
      await Get.find<ApiProvider>()
          .getModelResponse(messages)
          .then((groqResponse) {
        _text.value = "";
        _isGeneratingResponse.value = false;
        var result = groqResponse.choices.first.message.content;
        _response.value = result;
        messages.add(GroqMessage("assistant", response));
        _speak(TextUtils.removeAsterisk(response));
        if (result.contains("INTRODUCTION COMPLETED")) {
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

  startListening() async {
    Get.log("startListening() called");
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
        // Get.log("val: $val");
        if (messages.length <= 1) {
          // first message should be hi or hello
          if (val.toLowerCase() == "hi") {
            _text.value = "hi";
          } else if (val.toLowerCase() == "hello") {
            _text.value = "hello";
          }
        } else {
          _text.value = val;
          // if (kIsWeb) {
          //   _text.value = val;
          // } else {
          //   if (!_text.value.contains(val)) {
          //     _text.value = "${_text.value} ${val}";
          //   }
          // }
        }
      });
    }
  }

  stopListening() async {
    Get.log("stopListening() called");
    _isListening.value = false;
    Get.find<SpeechRecognizer>().stopListening();
    if (text.isNotEmpty) {
      messages.add(GroqMessage("user", text));
      _getModelResponse();
    }
  }

  void _speak(String input) {
    Get.log("onStatus: speaking");
    _tts.speak(input).onError((error, stackTrace) {
      Get.log("onStatus: speaking error: $error");
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
        messages[key] = updatedMessage;
      });
    } else {
      Get.log("onGetTranslation info: there already translation");
    }
  }

  bool checkFirstGreeting() {
    if (text == "hi" || text == "hello") {
      return true;
    } else {
      return false;
    }
  }

  void showFeedback(){
    _tts.stop();
    isShowFeedback.value = true;
    _getFeedback();
  }

  Future<void> _getFeedback() async {
    isGeneratingFeedback.value = true;
    // var conversationMessageJson = shownMessages.map((e) => e.toJson()).toList();
    List<String> conversationMessageJson =
    messages.map((e) => e.toString()).toList();
    Get.log("conversation json: ${conversationMessageJson}");
    // var x =
    //     "[Conversation(role: assistant, content: Have you ever considered visiting Bali, Indonesia? It's a beautiful island with stunning beaches and temples., wordSaidByUser: null), Conversation(role: user, content: Yes, I've always wanted to go there. I've heard the beaches are amazing., wordSaidByUser: yes I have always wanted to go there I have heard that the beaches are amazing), Conversation(role: assistant, content: They definitely are! Kuta, Seminyak, and Nusa Dua are some of the most popular beaches. Which one would you like to visit first?, wordSaidByUser: null), Conversation(role: user, content: I think I'd like to visit Kuta. I've heard it's a great place for surfers., wordSaidByUser: I think I like to visit Kota I have her it is a great place for soft first), Conversation(role: assistant, content: That's right! Kuta is known for its great surfing spots. Are you planning to try surfing while you're there or just relax on the beach?, wordSaidByUser: null), Conversation(role: user, content: I've never surfed before, but I'd love to try it. Do you know of any good surf schools in Kuta?, wordSaidByUser: I've never heard suffered Pizza but I love to try it do you know any good sort of schools in Qatar), Conversation(role: assistant, content: There are several good surf schools in Kuta. I can recommend Rip Curl School of Surf and Odyssey Surf School. They both have great instructors and equipment., wordSaidByUser: null), Conversation(role: user, content: Thanks for the recommendations. How long do you think I should stay in Bali to get a good feel for the island?, wordSaidByUser: thanks for the recommendation how long do you think I should stay in Bali to get a good feel for the Iceland), Conversation(role: assistant, content: I think at least a week would be good to explore the island and its culture. You could also consider visiting some of the temples, like Tanah Lot or Uluwatu, and experience the local cuisine., wordSaidByUser: null), Conversation(role: user, content: A week sounds like a good amount of time. Do you think I should book my accommodations in advance or wait until I get there?, wordSaidByUser: a week sounds like a good amount of time do you think I should put my accommodation in advance or wait until I get there), Conversation(role: assistant, content: I would recommend booking your accommodations in advance, especially during peak season. You can find some great deals on hotels and villas online. [CONVERSATION COMPLETED], wordSaidByUser: null)]";
    List<GroqMessage> feedbackMessages = [
      GroqMessage("system",
          SystemPromptTemplate.introductionFeedback(conversationMessageJson.toString())),
      GroqMessage("user", "give feedback for our conversation")
    ];
    await Get.find<ApiProvider>()
        .getModelResponse(feedbackMessages)
        .then((groqResponse) {
      var result = groqResponse.choices.first.message.content;
      feedback.value = result;

      isGeneratingFeedback.value = false;
      // var decoded = jsonDecode(groqResponse.choices.first.message.content);
      // ConversationFeedback result = ConversationFeedback.fromJson(decoded);
      // Get.log("overall score: ${result.overall?.score}");
      // conversationFeedback.value = result;
      // translatedFeedback.value = result.feedbackAndSuggestion ?? "";
      // if (result.feedbackAndSuggestion != null) {
      //   _translator
      //       .translate(result.feedbackAndSuggestion!, from: "en", to: "id")
      //       .then((val) {
      //     // translatedFeedback.value = val.text ?? "";
      // });
      // }
    });
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
