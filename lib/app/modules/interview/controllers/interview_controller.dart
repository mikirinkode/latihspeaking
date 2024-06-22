import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speaking/app/data/provider/api_provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../../../../constants.dart';
import '../../../data/model/groq_message.dart';
import '../../../data/model/groq_response.dart';
import '../../../data/provider/speech_recognizer.dart';
import '../../../utils/text_utils.dart';

class InterviewController extends GetxController {
  final _isListening = false.obs;

  bool get isListening => _isListening.value;

  final _isSpeechRecognizerEnabled = false.obs;

  final _isGeneratingResponse = false.obs;

  bool get isGeneratingResponse => _isGeneratingResponse.value;

  final _text = "Press the button and start speaking".obs;

  String get text => _text.value;

  final _response = "".obs;

  String get response => _response.value;

  // final _confidence = 0.0.obs;
  // double get confidence => _confidence.value;

  final messages = <GroqMessage>[].obs;
  final selectedVoice = "".obs;

  final pageTitle = "Playground".obs;

  /// Object
  late FlutterTts _tts;
  late GoogleTranslator _translator;

  @override
  void onInit() {
    super.onInit();
    _initVoiceChat();
    _initializedAgent(Get.arguments["APPLIED_POSITION"]);
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

    /// This has to happen only once per app
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
  }

  void _initializedAgent(String appliedPosition) {
    messages.addAll([
      GroqMessage(
          "system", SystemPromptTemplate.getRecruiterPrompt(appliedPosition)),
      GroqMessage("assistant",
          "Hi there! welcome to your Interview Practice. Are you ready to begin your interview?")
    ]);
  }

  startListening() async {
    _text.value = "";
    continueListening();
  }

  continueListening() async {
    // Get.log("continueListening() called");
    _tts.stop();
    if (_isSpeechRecognizerEnabled.value) {
      _isListening.value = true;
      Get.find<SpeechRecognizer>().continueListening(
          onResultCallback: (String val) {
            Get.log("recognized value: ${val}");
            Get.log(
                "!_text.value.contains(val.recognizedWords): ${!_text.value.contains(val)}");

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
    messages.add(GroqMessage("user", text));
    Get.find<SpeechRecognizer>().stopListening();
    _getModelResponse();
  }

  Future<void> _getModelResponse() async {
    _isGeneratingResponse.value = true;
    try {
      await Get.find<ApiProvider>()
          .getModelResponse(messages)
          .then((groqResponse) {
        _isGeneratingResponse.value = false;
        var result = groqResponse.choices.first.message.content;
        messages.add(GroqMessage("assistant", result));
        _speak(TextUtils.removeAsterisk(result));
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

  void _getTranslation(GroqMessage groqMessage) {
    _translator
        .translate(groqMessage.content, from: "en", to: "id")
        .then((value) {
      Get.log("translated message: ${value.text}");
      return value.text;
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
}
