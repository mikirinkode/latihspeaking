import 'package:get/get.dart';

import '../modules/voice_chat/bindings/voice_chat_binding.dart';
import '../modules/voice_chat/views/voice_chat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.VOICE_CHAT;

  static final routes = [
    GetPage(
      name: _Paths.VOICE_CHAT,
      page: () => const VoiceChatView(),
      binding: VoiceChatBinding(),
    ),
  ];
}
