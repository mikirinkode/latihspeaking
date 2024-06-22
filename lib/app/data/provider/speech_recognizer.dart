import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognizer extends GetxService {
  final _isListening = false.obs;

  bool get isListening => _isEnabled.value;

  final _isEnabled = false.obs;

  bool get isEnabled => _isEnabled.value;

  late SpeechToText _speech;

  // // Default or Placeholder Callback
  // void _defaultOnResultCallback(String recognizedWords) {
  //   // Handle or ignore the recognized words by default
  // }

  // Callback property
  Function(String)? _controllerCallback;

  Future<SpeechRecognizer> init() async {
    /// This has to happen only once per app
    _speech = SpeechToText();
    _isEnabled.value = await _speech.initialize(
        onStatus: (val) async {
          // Get.log("onStatus: $val");
          if (_isListening.value && val == "notListening") {
            // on android speech can be automatically turned off after few seconds
            // to handle it, if the _isListening is still true and status was notListening
            // then force it to continue listening
            // Get.log("onStatus: should continue");
            await _speech.stop();
            // TODO: i want to recall the continue listening, but it should be handled from controller too
            await continueListening(onResultCallback:_controllerCallback);
          }
        },
        onError: (val) {
          Get.log("onError: $val");
        },
        finalTimeout: const Duration(minutes: 5),
        options: [
          SpeechToText.androidAlwaysUseStop,
        ]);
    return this;
  }

  Future<void> continueListening({required Function(String)? onResultCallback}) async {
    if (onResultCallback != null){
      _controllerCallback = onResultCallback;
    }

    if (_isEnabled.value) {
      _isListening.value = true;
      _speech.listen(
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          partialResults: true,
        ),
        onResult: (val) {
          // Pass recognized words to callback
          // onResultCallback(val.recognizedWords);
          _controllerCallback?.call(val.recognizedWords);
        },
      );
    }
  }

  Future<void> stopListening() async {
    _isListening.value = false;
    await _speech.stop();
  }


  @override
  Future<void> onClose() async {
    super.onClose();
    _isListening.value = false;
    if (_speech.isListening){
      await _speech.stop();
      await _speech.cancel();
    }
  }
}
