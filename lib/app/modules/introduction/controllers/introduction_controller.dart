import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speaking/app/data/provider/speech_recognizer.dart';
import 'package:speaking/constants.dart';
import 'package:translator/translator.dart';

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
          if (kIsWeb) {
            _text.value = val;
          } else {
            _text.value = val;
            // if (!_text.value.contains(val)) {
            //   _text.value = "${_text.value} ${val}";
            // }
          }
        }
      });
    }
  }

  stopListening() async {
    Get.log("stopListening() called");
    _isListening.value = false;
    messages.add(GroqMessage("user", text));
    Get.find<SpeechRecognizer>().stopListening();
    _getModelResponse();
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
}
