import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../../core/theme/app_color.dart';
import '../../../global_widgets/button_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yuk latihan speaking! 🔥'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Latihan",
                style: TextStyle(fontSize: 18),
              ),
              PracticeCard(
                icon: "🔁",
                title: "Repeat after me",
                desc:
                "AI Buddy akan mengucapkan sebuah kalimat. Kamu bisa mengulanginya untuk melatih intonasi dan pelafalan.",
                onTap: () {
                  Get.toNamed(Routes.PLAYGROUND, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.repeatAfterMeAgent
                  });
                },
              ),
              PracticeCard(
                icon: "🔊",
                title: "Pronunciation Practice",
                desc: "Fokus berlatih ke kata kata yang tricky",
                onTap: () {
                  Get.toNamed(Routes.PLAYGROUND, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.pronunciationPracticeAgent
                  });
                },
              ),
              PracticeCard(
                icon: "💬",
                title: "Conversational Practice",
                desc:
                "Simulasi ngobrol dengan tema seperti pergi nonton ke bioskop atau ke restoran",
                onTap: () {
                  Get.toNamed(Routes.PLAYGROUND, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.conversationalPracticeAgent
                  });
                },
              ),
              PracticeCard(
                icon: "👤",
                title: "Free talk",
                desc:
                "Ngobrol sesuka kamu, ekspresikan diri dan latih speaking mu!",
                onTap: () {
                  Get.toNamed(Routes.PLAYGROUND, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.casualChatAgent
                  });
                },
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Profil",
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomChip(title: "Beginner"),
                      const SizedBox(
                        height: 8,
                      ),
                      PrimaryButton(text: "Test Ulang", onPressed: () {})
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PracticeCard extends StatelessWidget {
  final icon;
  final title;
  final desc;
  final Function() onTap;

  const PracticeCard(
      {required this.icon,
        required this.title,
        required this.desc,
        required this.onTap,
        super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: const BoxDecoration(
                      color: AppColor.PRIMARY_100, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(12),
                  child: Text(icon)),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(desc)
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColor.NEUTRAL_700,
                      size: 16,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String title;

  const CustomChip({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.PRIMARY_100, borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: const TextStyle(
            color: AppColor.PRIMARY_500,
            fontSize: 14,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
