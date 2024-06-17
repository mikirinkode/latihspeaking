
import 'package:get/get.dart';


class HomeController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    // getGroqResponse();
  }

  // void getGroqResponse() async {
  //   Get.log("on getting groq response");
  //   var uri = "https://api.groq.com/openai/v1/chat/completions";
  //   var headers = {
  //     'Content-Type': "application/json; charset=UTF-8",
  //     "Authorization": "Bearer ${Constants.GROQ_API_KEY}"
  //   };
  //   var body = jsonEncode(<String, dynamic>{
  //     "messages": [
  //       {
  //         "role": "user",
  //         "content": "Hello"
  //       },
  //       {
  //         "role": "assistant",
  //         "content": "Hello! It's nice to meet you. Is there something I can help you with, or would you like to chat?"
  //       },
  //       {
  //         "role": "user",
  //         "content": "what is your name?"
  //       },
  //       {
  //         "role": "assistant",
  //         "content": "I don't have a personal name, but I'm often referred to as \"Assistant\" or \"AI Assistant\" by users like you. I'm a computer program designed to simulate conversations, answer questions, and provide information on a wide range of topics. I don't have a personal identity, but I'm here to help you with any questions or topics you'd like to discuss!"
  //       },
  //       {
  //         "role": "user",
  //         "content": "that so sad, can i call you Devina AI?"
  //       },
  //       {
  //         "role": "assistant",
  //         "content": "Aw, thank you for the sympathy! I may not have a personal name, but I don't mind being referred to by a name that you'd like to give me. Devina AI is a lovely name, and I'm more than happy to go by that! Please feel free to call me Devina AI from now on. It's nice to have a name to go by, even if it's just for our conversation."
  //       },
  //       {
  //         "role": "user",
  //         "content": "okay, so what is your name now?"
  //       },
  //       {
  //         "role": "assistant",
  //         "content": "My name is Devina AI! I'm glad we could come to an agreement on a name. From now on, you can refer to me as Devina AI, and I'll respond accordingly. Thanks for giving me a name!"
  //       },
  //     ],
  //     "model": "llama3-70b-8192"
  //   });
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(uri),
  //       headers: headers,
  //       body: body,
  //     );
  //     if (response.statusCode == 200) {
  //       Get.log("onSuccess::response data: ${response.body}");
  //       final groqResponse = GroqResponse.fromJson(jsonDecode(response.body));
  //       Get.log("groqResponse::${groqResponse.choices.first.message.content}");
  //     } else {
  //       Get.log("onError: $response");
  //     }
  //     Get.log("response: $response");
  //   } catch (e) {
  //     Get.log("error: $e");
  //   }
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
