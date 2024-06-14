import 'package:get/get.dart';
import 'package:speaking/app/data/middleware/auth_middleware.dart';

import 'package:speaking/app/modules/login/bindings/login_binding.dart';
import 'package:speaking/app/modules/login/views/login_view.dart';
import 'package:speaking/app/modules/playground/bindings/playground_binding.dart';
import 'package:speaking/app/modules/playground/views/playground_view.dart';
import 'package:speaking/app/modules/proficiency/bindings/proficiency_binding.dart';
import 'package:speaking/app/modules/proficiency/views/proficiency_view.dart';

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
      middlewares: [AuthMiddleware()]
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
  ];
}
