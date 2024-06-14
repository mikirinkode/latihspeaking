import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../service/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!Get.find<AuthService>().isAuth && route != Routes.LOGIN) {
      return const RouteSettings(name: Routes.LOGIN);
    }

    return null;
  }
}
