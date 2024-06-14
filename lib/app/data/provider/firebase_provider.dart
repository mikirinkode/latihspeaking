import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseProvider extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FirebaseProvider> init() async {
    return this;
  }


  Future<bool> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
      } else {
        GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await _auth.signInWithCredential(credential);
      }

      return true;
    } on Exception catch (e) {
      Get.log(e.toString());
      return false;
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await GoogleSignIn().disconnect();
      await _auth.signOut();
      return true;
    } on Exception catch (e) {
      Get.log(e.toString());
      return false;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}