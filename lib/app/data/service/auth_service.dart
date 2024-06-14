import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../provider/firebase_provider.dart';

class AuthService extends GetxService {
  late User? user;

  Future<AuthService> init() async {
    refreshUser();
    return this;
  }

  void refreshUser() {
    user = Get.find<FirebaseProvider>().getCurrentUser();
  }

  bool get isAuth => user != null;
}
