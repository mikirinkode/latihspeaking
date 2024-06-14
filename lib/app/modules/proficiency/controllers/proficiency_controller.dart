import 'package:get/get.dart';
import 'package:speaking/app/routes/app_pages.dart';

import '../../../data/provider/firebase_provider.dart';

class SelectableModel {
  final String title;
  final String desc;
  final String value;

  SelectableModel(
      {required this.title, required this.desc, required this.value});
}

class ProficiencyController extends GetxController {
  // List<SelectableModel> getProficiencyList() => [
  //   SelectableModel(
  //       title: "Pemula",
  //       desc:
  //       ""),
  //   SelectableModel(
  //       title: "Menengah",
  //       desc:
  //       ""),
  //   SelectableModel(
  //       title: "Lanjutan",
  //       desc:""),
  // ];
  List<SelectableModel> getProficiencyList() => [
        SelectableModel(
            title: "Pemula",
            desc:
                "Baru paham kosakata dasar dan kalimat sederhana? Tenang, di sini kamu akan belajar dengan cara yang seru!",
            value: "beginner"),
        SelectableModel(
          title: "Menengah",
          desc:
              "Sudah biasa dengan kalimat yang lebih rumit dan percakapan sehari-hari? Bagus sekali, yuk lanjut belajar lagi.",
          value: "intermediate",
        ),
        SelectableModel(
            title: "Lanjutan",
            desc:
                "Siap untuk tantangan baru? Mari eksplor kosakata tingkat lanjut, percakapan bernuansa, idiom, dan ekspresi.",
            value: "advanced"),
      ];

  final selectedProficiency = "".obs;
  final selectedProficiencyValue = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void changeSelectedProficiency(String title, String value) {
    selectedProficiency.value = title;
    selectedProficiencyValue.value = value;
  }

  Future<void> updateProficiency() async {
    await Get.find<FirebaseProvider>()
        .updateProficiency(selectedProficiencyValue.value)
        .then((value) {
      if (value) {
        Get.offAllNamed(Routes.HOME);
      }
    });
  }
}
