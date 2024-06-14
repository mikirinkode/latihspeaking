import 'package:get/get.dart';

class SelectableModel {
  final String title;
  final String desc;

  SelectableModel({required this.title, required this.desc});

}

class ProficiencyController extends GetxController {
  List<SelectableModel> getProficiencyList() => [
    SelectableModel(
        title: "Pemula",
        desc:
        ""),
    SelectableModel(
        title: "Menengah",
        desc:
        ""),
    SelectableModel(
        title: "Lanjutan",
        desc:""),
  ];
  // List<SelectableModel> getProficiencyList() => [
  //   SelectableModel(
  //       title: "Pemula",
  //       desc:
  //       "Baru mulai? Tenang, di sini kamu akan belajar dengan cara yang seru!"),
  //   SelectableModel(
  //       title: "Menengah",
  //       desc:
  //       "Sudah biasa dengan kalimat yang lebih rumit dan percakapan sehari-hari? Bagus sekali, yuk lanjut belajar lagi."),
  //   SelectableModel(
  //       title: "Lanjutan",
  //       desc:
  //       "Siap untuk tantangan baru? Mari eksplor kosakata tingkat lanjut, percakapan bernuansa, idiom, dan ekspresi."),
  // ];

  final selectedProficiency = "".obs;

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

  void changeSelectedProficiency(String title) {
    selectedProficiency.value = title;
  }

}
