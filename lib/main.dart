import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:speaking/app/core/theme/app_color.dart';
import 'package:speaking/app/core/theme/app_theme.dart';
import 'package:speaking/app/data/provider/api_provider.dart';

import 'package:speaking/app/routes/app_pages.dart';
import 'package:speaking/constants.dart';
import 'package:speaking/firebase_options.dart';

import 'app/data/provider/firebase_provider.dart';
import 'app/data/service/auth_service.dart';


Future<void> initServices() async {
  Get.log("Starting services ...");
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => ApiProvider().init());
  await Get.putAsync(() => AuthService().init());
  Get.log("All services started ...");
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initServices();

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
            title: "LatihSpeaking",
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
