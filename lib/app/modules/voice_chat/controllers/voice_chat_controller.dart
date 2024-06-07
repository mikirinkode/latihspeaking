import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voicechat/app/model/gemini_message.dart';

class VoiceChatController extends GetxController {
  final _isListening = false.obs;
  bool get isListening => _isListening.value;

  final _isGeneratingResponse = false.obs;
  bool get isGeneratingResponse => _isGeneratingResponse.value;

  final _text = "Press the button and start speaking".obs;
  String get text => _text.value;

  final _response = "".obs;
  String get response => _response.value;

  final _confidence = 0.0.obs;
  double get confidence => _confidence.value;

  final _messageId = 0.obs;
  final messages = [].obs;

  /// Object
  late SpeechToText _speech;
  late Gemini _gemini;
  late FlutterTts _tts;

  @override
  void onInit() {
    super.onInit();

    _speech = SpeechToText();
    _gemini = Gemini.instance;
    _tts = FlutterTts();
    _tts.setVoice({"name": "Google UK English Female", "locale": "en-GB"});
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _tts.stop();
    _speech.stop();
    _gemini.cancelRequest();
  }

  startListening() async {
    _tts.stop();
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print("onStatus: $val"),
        onError: (val) => print("onError: $val"),
      );
      if (available) {
        _text.value = "";
        _isListening.value = true;

        _speech.listen(
            onResult: (val) => {
                  _text.value = val.recognizedWords,
                  if (val.hasConfidenceRating && val.confidence > 0)
                    {_confidence.value = val.confidence}
                });
      }
    } else {
      _isListening.value = false;
      messages.add(GeminiMessage(message: text, id: _messageId.value));
      _messageId.value = _messageId.value + 1;
      _speech.stop();
      _getGeminiResponse();
    }
  }

  void _getGeminiResponse() async {
    print("onStatus: _getGeminirResponse($_text)");
    try {
      _response.value = "";
      _isGeneratingResponse.value = true;
      _gemini.streamGenerateContent(text).listen((value) {
        // print("response: ${value.output}");
        _response.value += value.output ?? "";
      }).onDone(() {
        print("onStatus: onGemini Done");
        _text.value = "";
        _isGeneratingResponse.value = false;
        messages.add(GeminiMessage(message: response, id: _messageId.value));
        _messageId.value = _messageId.value + 1;
        _speak();
      });
    } catch (e) {
      _isGeneratingResponse.value = false;
      print("onStatus: gemini error: $e");
    }
  }

  void _speak() {
    print("onStatus: speaking");
    _tts.speak(response);
  }
}
