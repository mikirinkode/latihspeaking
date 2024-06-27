import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
              kIsWeb &&
                      (defaultTargetPlatform != TargetPlatform.android ||
                          defaultTargetPlatform != TargetPlatform.iOS)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, left: 16),
                          child: Text(
                            "Browser yang didukung",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColor.PRIMARY_50,
                                borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                SupportedWebCard(title: "Google Chrome", isSupported: true,),
                                SupportedWebCard(title: "Mozilla Firefox", isSupported: false,),
                                SupportedWebCard(title: "Microsoft Edge", isSupported: false,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              kIsWeb && defaultTargetPlatform == TargetPlatform.android
                  ? GestureDetector(
                      onTap: () {
                        launchUrl(
                            Uri.parse(
                                "https://play.google.com/store/apps/details?id=com.coolva.speaking"),
                            mode: LaunchMode.externalNonBrowserApplication);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColor.PRIMARY_50,
                              border: Border.all(
                                width: 2,
                                color: AppColor.PRIMARY_500,
                              ),
                              borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Info Penting!",
                                style: TextStyle(
                                    color: AppColor.PRIMARY_500,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                  "Kamu bisa pindah ke aplikasi versi Playstore agar dapat merasakan pengalaman yang lebih baik. Klik disini untuk download.")
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 16),
                child: Text(
                  "Tutorial",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              PracticeCard(
                icon: "👋",
                title: "Perkenalan",
                desc: "Panduan singkat menggunakan aplikasi",
                tags: ["Mudah"],
                onTap: () {
                  Get.toNamed(Routes.INTRODUCTION);
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24.0, left: 16),
                child: Text(
                  "Latihan umum",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              PracticeCard(
                icon: "💬",
                title: "Obrolan Terarah",
                desc:
                    "Simulasi percakapan dengan skenario tertentu seperti pergi ke bioskop atau restoran. Cocok untuk latihan dengan panduan jawaban yang sudah disediakan.",
                tags: ["mudah"],
                onTap: () {
                  Get.toNamed(Routes.SELECT_CONVERSATION,
                      arguments: {"CONVERSATION_TYPE": "DIRECTED"});
                },
              ),
              PracticeCard(
                icon: "⚡",
                title: "Obrolan Spontan",
                desc:
                    "Tingkatkan kemampuan berbicara dengan tantangan spontan. Tentukan jawabanmu sendiri dalam berbagai situasi percakapan tanpa panduan",
                tags: ["menengah"],
                onTap: () {
                  Get.toNamed(Routes.SELECT_CONVERSATION,
                      arguments: {"CONVERSATION_TYPE": "SPONTAN"});
                },
              ),
              PracticeCard(
                icon: "🎤",
                title: "Obrolan bebas (Uji Coba)",
                desc:
                    "Ngobrol sesuka kamu dan ekspresikan diri tanpa batasan tema. Latih kemampuan berbicara secara alami dan spontan!",
                tags: ["menengah"],
                onTap: () {
                  Get.toNamed(Routes.PLAYGROUND, arguments: {
                    "VOICE_MODEL": "Female",
                    "AI_AGENT": Agent.casualChatAgent
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24.0, left: 16),
                child: Text(
                  "Persiapan karir",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              PracticeCard(
                icon: "💼",
                title: "Mock Interview",
                desc:
                    "Perkuat keterampilan berbicaramu dan persiapkan dirimu untuk sukses dalam karir dengan latihan wawancara yang realistis.",
                tags: ["menengah"],
                onTap: () {
                  Get.toNamed(Routes.INTERVIEW_SETUP);
                },
              ),
              // PracticeCard(
              //   icon: "🔁",
              //   title: "Repeat after me (Uji Coba)",
              //   desc:
              //       "AI Buddy akan mengucapkan sebuah kalimat. Kamu bisa mengulanginya untuk melatih intonasi dan pelafalan.",
              //   onTap: () {
              //     Get.toNamed(Routes.PLAYGROUND, arguments: {
              //       "VOICE_MODEL": "Female",
              //       "AI_AGENT": Agent.repeatAfterMeAgent
              //     });
              //   },
              // ),
              // PracticeCard(
              //   icon: "🔊",
              //   title: "Pronunciation Practice  (Uji Coba)",
              //   desc: "Fokus berlatih pengucapan kata kata yang tricky",
              //   onTap: () {
              //     Get.toNamed(Routes.PLAYGROUND, arguments: {
              //       "VOICE_MODEL": "Female",
              //       "AI_AGENT": Agent.pronunciationPracticeAgent
              //     });
              //   },
              // ),
              // const SizedBox(
              //   height: 24,
              // ),
              // const Text(
              //   "Profil",
              //   style: TextStyle(fontSize: 18),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
              //   child: Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(16)),
              //     padding: const EdgeInsets.all(12),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Status",
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         const SizedBox(
              //           height: 8,
              //         ),
              //         CustomChip(title: "Beginner"),
              //         const SizedBox(
              //           height: 8,
              //         ),
              //         PrimaryButton(text: "Test Ulang", onPressed: () {})
              //       ],
              //     ),
              //   ),
              // )
              const Padding(
                padding: EdgeInsets.only(top: 24.0, left: 16),
                child: Text(
                  "Tentang Aplikasi",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.PRIMARY_50,
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LatihSpeaking",
                          style: TextStyle(
                              color: AppColor.PRIMARY,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                            "adalah platform latihan bicara bahasa inggris berbasis AI dengan fitur percakapan yang mudah, menyenangkan dan Gratis!"),
                        SizedBox(height: 16),
                        Text("Punya saran / feedback?"),
                        SizedBox(
                          height: 8,
                        ),
                        SecondaryButton(
                            text: "Kirim Feedback",
                            onPressed: () {
                              if (kIsWeb) {
                                launchUrl(
                                  Uri.parse(
                                      "https://forms.gle/bxRNgavRcVwxCdo67"),
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                Get.toNamed(Routes.EMBEDDED_WEB);
                              }
                            })
                      ],
                    ),
                  ))
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
  final List<String> tags;
  final Function() onTap;

  const PracticeCard(
      {required this.icon,
      required this.title,
      required this.desc,
      required this.tags,
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
                      color: AppColor.PRIMARY_50, shape: BoxShape.circle),
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
                    const SizedBox(
                      width: 8,
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

class SupportedWebCard extends StatelessWidget {
  final String title;
  final bool isSupported;

  const SupportedWebCard(
      {required this.title, required this.isSupported, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
        ),
        Spacer(),
        Icon(
          isSupported ? Icons.check : Icons.close_rounded,
          color: isSupported ? Colors.green : Colors.blueGrey,
        )
      ],
    );
  }
}
