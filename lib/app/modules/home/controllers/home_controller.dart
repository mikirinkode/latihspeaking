import 'package:get/get.dart';

class VoiceModel {
  final String name;
  final String locale;

  VoiceModel({required this.name, required this.locale});

  static List<VoiceModel> getVoiceList() => [
        VoiceModel(name: "Female", locale: "English UK"),
        VoiceModel(name: "Male", locale: "English UK"),
      ];
}

class HomeController extends GetxController {
  final voiceList = VoiceModel.getVoiceList();
  final selectedVoice = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeSelectedVoiceModel(String name) {
    selectedVoice.value = name;
  }
}
