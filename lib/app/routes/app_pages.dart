import 'package:get/get.dart';

import '../modules/groqchat/bindings/groqchat_binding.dart';
import '../modules/groqchat/views/groqchat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/voice_chat/bindings/voice_chat_binding.dart';
import '../modules/voice_chat/views/voice_chat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.VOICE_CHAT,
      page: () => const VoiceChatView(),
      binding: VoiceChatBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.GROQCHAT,
      page: () => const GroqchatView(),
      binding: GroqchatBinding(),
    ),
  ];
}
