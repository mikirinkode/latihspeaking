import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/theme/app_color.dart';
import '../../../global_widgets/button_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/proficiency_controller.dart';

class ProficiencyView extends GetView<ProficiencyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cek Kecakapan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Pilih opsi yang sesuai dengan pengalaman bahasa inggris mu:',
                      ),
                      ...controller.getProficiencyList().map((e) =>
                          SelectableCard(
                              title: e.title,
                              desc: e.desc,
                              isSelected: e.title ==
                                  controller.selectedProficiency.value,
                              onCardTapped: () {
                                controller.changeSelectedProficiency(e.title, e.value);
                              })),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                        text: "Lanjut",
                        enabled: controller.selectedProficiency.isNotEmpty,
                        onPressed: () {
                          controller.updateProficiency();
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectableCard extends StatelessWidget {
  final String title;
  final String desc;
  final bool isSelected;
  final Function() onCardTapped;

  const SelectableCard(
      {required this.title,
      required this.desc,
      required this.isSelected,
      required this.onCardTapped,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTapped,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 4, left: 4),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 2,
                  color:
                      isSelected ? AppColor.PRIMARY_500 : AppColor.NEUTRAL_200),
              borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              (isSelected)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(desc),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
