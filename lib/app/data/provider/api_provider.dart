import 'dart:convert';

import 'package:get/get.dart';
import 'package:speaking/app/data/model/groq_message.dart';

import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../model/groq_response.dart';

class ApiProvider extends GetxService {

  Future<ApiProvider> init() async {
    return this;
  }

  /// handle on error
  /// ClientException: XMLHttpRequest error., uri=https://api.groq.com/openai/v1/chat/completions
  /// rate limit bla bla
  /// add to firestore
  /// display on top of app
  Future<GroqResponse> getModelResponse(List<GroqMessage> messages)async{
    var uri = "https://api.groq.com/openai/v1/chat/completions";
    var headers = {
      'Content-Type': "application/json; charset=UTF-8",
      "Authorization": "Bearer ${Constants.GROQ_API_KEY}"
    };
    var body = jsonEncode(<String, dynamic>{
      "messages": messages.map((element) => element.toJson()).toList(),
      "model": "llama3-70b-8192"
    });
    Get.log("body: $body");
    try {
      final apiResponse = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: body,
      );
      if (apiResponse.statusCode == 200) {
        // Get.log("onSuccess::response data: ${apiResponse.body}");
        final groqResponse =
        GroqResponse.fromJson(jsonDecode(apiResponse.body));
        Get.log("groqResponse::${groqResponse.choices.first.message.content}");
        return groqResponse;
      } else {
        Get.log("onError: $apiResponse");
        Get.log("onError: ${apiResponse.body}");
      return Future.error("Failed getting response from AI");
      }
    } catch (e) {
      Get.log("error: $e");
      return Future.error("Failed getting response from AI: $e");
    }
  }
  Future<GroqResponse> getFormattedResponse(List<GroqMessage> messages)async{
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
    Get.log("body: $body");
    try {
      final apiResponse = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: body,
      );
      if (apiResponse.statusCode == 200) {
        Get.log("onSuccess::response data: ${apiResponse.body}");
        final groqResponse =
        GroqResponse.fromJson(jsonDecode(apiResponse.body));
        Get.log("groqResponse::${groqResponse.choices.first.message.content}");
        return groqResponse;
      } else {
        Get.log("onError: ${apiResponse.body}");
      return Future.error("Failed getting response from AI");
      }
    } catch (e) {
      Get.log("error: $e");
      return Future.error("Failed getting response from AI: $e");
    }
  }
}