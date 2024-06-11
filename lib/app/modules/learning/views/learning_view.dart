import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../constants.dart';
import '../../../routes/app_pages.dart';
import '../controllers/learning_controller.dart';

class LearningView extends GetView<LearningController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Latihan",
              ),
              PracticeCard(
                title: "🔁 Repeat after me",
                desc:
                    "AI Buddy akan mengucapkan sebuah kalimat. Kamu bisa mengulanginya untuk melatih intonasi dan pelafalan.",
                onTap: () {
                  Get.toNamed(Routes.GROQCHAT, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.repeatAfterMeAgent
                  });
                },
              ),
              PracticeCard(
                title: "🔊 Pronunciation Practice",
                desc: "Fokus berlatih ke kata kata yang tricky",
                onTap: () {
                  Get.toNamed(Routes.GROQCHAT, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.pronunciationPracticeAgent
                  });
                },
              ),
              PracticeCard(
                title: "🗪 Conversational Practice",
                desc:
                    "Simulasi ngobrol dengan tema seperti pergi nonton ke bioskop atau ke restoran",
                onTap: () {
                  Get.toNamed(Routes.GROQCHAT, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.conversationalPracticeAgent
                  });
                },
              ),
              PracticeCard(
                title: "👤 Free talk",
                desc:
                    "Ngobrol sesuka kamu, ekspresikan diri dan latih speaking mu!",
                onTap: () {
                  Get.toNamed(Routes.GROQCHAT, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.casualChatAgent
                  });
                },
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Progress Kamu",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PracticeCard extends StatelessWidget {
  final title;
  final desc;
  final Function() onTap;

  const PracticeCard(
      {required this.title,
      required this.desc,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(desc)
            ],
          ),
        ),
      ),
    );
  }
}
