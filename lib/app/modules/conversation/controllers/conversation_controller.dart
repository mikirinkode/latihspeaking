import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speaking/app/data/model/conversation_feedback.dart';
import 'package:speaking/app/data/provider/api_provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../../../../constants.dart';
import '../../../data/model/conversation_message.dart';
import '../../../data/model/groq_message.dart';
import '../../../data/model/groq_response.dart';
import '../../../data/provider/speech_recognizer.dart';

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
  final _isSpeechRecognizerEnabled = false.obs;

  final _isListening = false.obs;

  bool get isListening => _isListening.value;

  final _text = "".obs;

  String get text => _text.value;

  final selectedVoice = "".obs;

  final conversationFeedback = Rx<ConversationFeedback?>(null);
  final feedback = "".obs;
  final translatedFeedback = "".obs;

  /// Object
  late FlutterTts _tts;
  late GoogleTranslator _translator;

  @override
  Future<void> onInit() async {
    super.onInit();
    // theme("Trip to Bali, Indonesia");
    theme(Get.arguments["CONVERSATION_THEME"]);
    await _initVoiceChat();
    await getConversation();
    // await _getFeedback();
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
        if (resultList[1] != null) {
          if (resultList[1].content.isEmpty || resultList[1].content == "...") {
            getConversation();
          }
        }
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
    if (currentFocusedMessage.value <= 0){
      _nextMessage();
      continueListening();
    } else if (text.isNotEmpty){
      _text.value = "";
      _nextMessage();
      continueListening();
    } else {
      continueListening();
    }
    Get.log("current focused: ${currentFocusedMessage.value}");
  }

  continueListening() async {
    // Get.log("continueListening() called");
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

    if(text.isNotEmpty){
      // update the previous message
      ConversationMessage currentMessage =
          shownMessages.elementAt(currentFocusedMessage.value);

      ConversationMessage updatedMessage = ConversationMessage(
          role: currentMessage.role,
          content: currentMessage.content,
          translation: currentMessage.translation,
          wordSaidByUser: text);
      shownMessages[currentFocusedMessage.value] = updatedMessage;

      var conversationMessageJson = shownMessages.map((e) => e.toJson()).toList();
      Get.log("conversation json: ${conversationMessageJson}");
      // show next message
      shownMessages
          .add(conversationMessages.elementAt(currentFocusedMessage.value + 1));

      if (currentFocusedMessage.value + 2 < conversationMessages.length - 1) {
        // show the user too
        shownMessages
            .add(conversationMessages.elementAt(currentFocusedMessage.value + 2));
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

  Future<void> _nextMessage() async {
    if (currentFocusedMessage.value + 1 <= conversationMessages.length - 1) {
      currentFocusedMessage.value = currentFocusedMessage.value + 1;
      Get.log("CurrentMessageIndex changed to: $currentFocusedMessage");

      if (currentFocusedMessage.value == conversationMessages.length - 1) {
        Get.log("CurrentMessageIndex has reach the last");

        var conversationMessageJson =
            shownMessages.map((e) => e.toJson()).toList();
        // Get.log("conversation json: ${conversationMessageJson}");
        isConversationOnGoing.value = false;
        isFinished.value = true;
        await _getFeedback();
      }
    } else {
      Get.log("ELSE CurrentMessageIndex has reach the last");
      isConversationOnGoing.value = false;
    }
  }

  void getTranslation(ConversationMessage groqMessage, int key) {
    if (groqMessage.translation == null) {
      _translator
          .translate(groqMessage.content, from: "en", to: "id")
          .then((value) {
        Get.log("translated message: ${value.text}");
        ConversationMessage updatedMessage = ConversationMessage(
            role: groqMessage.role,
            content: groqMessage.content,
            translation: value.text);
        shownMessages[key] = updatedMessage;
      });
    } else {
      Get.log("onGetTranslation info: there already translation");
    }
  }

  Future<void> _getFeedback() async {
    // var conversationMessageJson = shownMessages.map((e) => e.toJson()).toList();
    List<String> conversationMessageJson =
        shownMessages.map((e) => e.toString()).toList();
    Get.log("conversation json: ${conversationMessageJson}");
    // var x =
    //     "[Conversation(role: assistant, content: Have you ever considered visiting Bali, Indonesia? It's a beautiful island with stunning beaches and temples., wordSaidByUser: null), Conversation(role: user, content: Yes, I've always wanted to go there. I've heard the beaches are amazing., wordSaidByUser: yes I have always wanted to go there I have heard that the beaches are amazing), Conversation(role: assistant, content: They definitely are! Kuta, Seminyak, and Nusa Dua are some of the most popular beaches. Which one would you like to visit first?, wordSaidByUser: null), Conversation(role: user, content: I think I'd like to visit Kuta. I've heard it's a great place for surfers., wordSaidByUser: I think I like to visit Kota I have her it is a great place for soft first), Conversation(role: assistant, content: That's right! Kuta is known for its great surfing spots. Are you planning to try surfing while you're there or just relax on the beach?, wordSaidByUser: null), Conversation(role: user, content: I've never surfed before, but I'd love to try it. Do you know of any good surf schools in Kuta?, wordSaidByUser: I've never heard suffered Pizza but I love to try it do you know any good sort of schools in Qatar), Conversation(role: assistant, content: There are several good surf schools in Kuta. I can recommend Rip Curl School of Surf and Odyssey Surf School. They both have great instructors and equipment., wordSaidByUser: null), Conversation(role: user, content: Thanks for the recommendations. How long do you think I should stay in Bali to get a good feel for the island?, wordSaidByUser: thanks for the recommendation how long do you think I should stay in Bali to get a good feel for the Iceland), Conversation(role: assistant, content: I think at least a week would be good to explore the island and its culture. You could also consider visiting some of the temples, like Tanah Lot or Uluwatu, and experience the local cuisine., wordSaidByUser: null), Conversation(role: user, content: A week sounds like a good amount of time. Do you think I should book my accommodations in advance or wait until I get there?, wordSaidByUser: a week sounds like a good amount of time do you think I should put my accommodation in advance or wait until I get there), Conversation(role: assistant, content: I would recommend booking your accommodations in advance, especially during peak season. You can find some great deals on hotels and villas online. [CONVERSATION COMPLETED], wordSaidByUser: null)]";
    // var encoded = json.encode(conversationMessageJson);
    // var c = "[{\"role\":\"assistant\",\"content\":\"Hi! Have you ever thought of visiting Bali, Indonesia? It's such a beautiful island with stunning beaches and temples.\",\"wordSaidByUser\":null},{\"role\":\"user\",\"content\":\"Yes, I've always wanted to visit Bali. I've heard it's a great place to relax and unwind.\",\"wordSaidByUser\":\"yes I have always wanted to visit Bali I have heard it is a great place to relax and unwind\"},{\"role\":\"assistant\",\"content\":\"Absolutely! Bali is perfect for relaxation. What kind of activities are you interested in doing while you're there? Would you like to try surfing or yoga?\",\"wordSaidByUser\":null},{\"role\":\"user\",\"content\":\"I'm not really into surfing, but I'd love to try yoga on the beach. Are there any good yoga studios in Bali?\",\"wordSaidByUser\":\"I'm not really into surfing but I'd love to try yoga on the beach after any good yoga studios in Bali\"},{\"role\":\"assistant\",\"content\":\"There are plenty of great yoga studios in Bali. You should check out Yoga House in Ubud or The Yoga Room in Canggu. They both offer amazing classes with breathtaking views.\",\"wordSaidByUser\":null},{\"role\":\"user\",\"content\":\"That sounds amazing! I'll definitely check them out. What about accommodations? Should I stay in a hotel or a villa?\",\"wordSaidByUser\":\"that sounds amazing I will definitely check them out what about accommodation so I stay at a hotel or a villa\"},{\"role\":\"assistant\",\"content\":\"It really depends on your budget and preferences. If you're looking for luxury, you could stay at a 5-star hotel like the Four Seasons. But if you want something more traditional, you could rent a villa through Airbnb.\",\"wordSaidByUser\":null},{\"role\":\"user\",\"content\":\"I think I'll opt for a villa. Do you know any good areas to stay in?\",\"wordSaidByUser\":\"I think I will up for Villa do you know any good areas to stay in\"},{\"role\":\"assistant\",\"content\":\"Seminyak is a great area to stay in. It's close to the beach and has plenty of restaurants and shops. Or you could stay in Ubud, which is more inland and surrounded by rice fields.\",\"wordSaidByUser\":null},{\"role\":\"user\",\"content\":\"I think I'll stay in Seminyak. How long do you think I should stay in Bali for?\",\"wordSaidByUser\":\"I think I will stay in semia how long do you think I should stay in for money\"},{\"role\":\"assistant\",\"content\":\"I'd recommend staying for at least a week to really get a feel for the island. But if you have more time, 10-14 days would be even better. You could explore the whole island and take your time to relax. [CONVERSATION COMPLETED]\",\"wordSaidByUser\":null}]";
// var c = "[]";
    List<GroqMessage> feedbackMessages = [
      GroqMessage("system",
          SystemPromptTemplate.directedConversationFeedback(conversationMessageJson.toString())),
      GroqMessage("user", "give feedback for our conversation")
    ];
    await Get.find<ApiProvider>()
        .getModelResponse(feedbackMessages)
        .then((groqResponse) {
      var result = groqResponse.choices.first.message.content;
      feedback.value = result;

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
