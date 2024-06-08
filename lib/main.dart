import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:voicechat/app/core/theme/app_color.dart';
import 'package:voicechat/app/core/theme/app_theme.dart';

import 'package:voicechat/app/routes/app_pages.dart';
import 'package:voicechat/constants.dart';
import 'package:voicechat/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // put your GEMINI AI API KEY HERE
  // it should be look like --> AI########
  Gemini.init(apiKey: Constants.GEMINI_AI_API_KEY);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.NEUTRAL_200,
      child: Center(
        child: SizedBox(
          width: kIsWeb ? 480 : double.infinity,
          child: GetMaterialApp(
            title: "VoiceChat",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            theme: lightTheme(),
            defaultTransition: Transition.cupertino,
          ),
        ),
      ),
    );
  }
}
