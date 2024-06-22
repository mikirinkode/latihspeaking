import 'package:get/get.dart';

import 'package:speaking/app/data/middleware/auth_middleware.dart';
import 'package:speaking/app/modules/conversation/bindings/conversation_binding.dart';
import 'package:speaking/app/modules/conversation/views/conversation_view.dart';
import 'package:speaking/app/modules/embedded_web/bindings/embedded_web_binding.dart';
import 'package:speaking/app/modules/embedded_web/views/embedded_web_view.dart';
import 'package:speaking/app/modules/interview_setup/bindings/interview_setup_binding.dart';
import 'package:speaking/app/modules/interview_setup/views/interview_setup_view.dart';
import 'package:speaking/app/modules/introduction/bindings/introduction_binding.dart';
import 'package:speaking/app/modules/introduction/views/introduction_view.dart';
import 'package:speaking/app/modules/login/bindings/login_binding.dart';
import 'package:speaking/app/modules/login/views/login_view.dart';
import 'package:speaking/app/modules/playground/bindings/playground_binding.dart';
import 'package:speaking/app/modules/playground/views/playground_view.dart';
import 'package:speaking/app/modules/proficiency/bindings/proficiency_binding.dart';
import 'package:speaking/app/modules/proficiency/views/proficiency_view.dart';
import 'package:speaking/app/modules/select_conversation/bindings/select_conversation_binding.dart';
import 'package:speaking/app/modules/select_conversation/views/select_conversation_view.dart';
import 'package:speaking/app/modules/spontaneous_conversation/bindings/spontaneous_conversation_binding.dart';
import 'package:speaking/app/modules/spontaneous_conversation/views/spontaneous_conversation_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      // middlewares: [AuthMiddleware()]
    ),
    GetPage(
      name: _Paths.PLAYGROUND,
      page: () => PlaygroundView(),
      binding: PlaygroundBinding(),
    ),
    GetPage(
      name: _Paths.PROFICIENCY,
      page: () => ProficiencyView(),
      binding: ProficiencyBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_CONVERSATION,
      page: () => SelectConversationView(),
      binding: SelectConversationBinding(),
    ),
    GetPage(
      name: _Paths.CONVERSATION,
      page: () => ConversationView(),
      binding: ConversationBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.EMBEDDED_WEB,
      page: () => EmbeddedWebView(),
      binding: EmbeddedWebBinding(),
    ),
    GetPage(
      name: _Paths.INTERVIEW_SETUP,
      page: () => InterviewSetupView(),
      binding: InterviewSetupBinding(),
    ),
    GetPage(
      name: _Paths.SPONTANEOUS_CONVERSATION,
      page: () => SpontaneousConversationView(),
      binding: SpontaneousConversationBinding(),
    ),
  ];
}
