import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';

class FirebaseProvider extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FirebaseProvider> init() async {
    return this;
  }

  late final _userRef = _firestore.collection("users").withConverter(
      fromFirestore: UserModel.fromFirestore,
      toFirestore: (UserModel user, options) => user.toFirestore());

  User? getCurrentUser() {
    return _auth.currentUser;
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

  Future<void> checkUserData() async {
    try {
      var userId = _auth.currentUser?.uid;
      var userData = await _userRef.doc(userId).get();

      if (!userData.exists) {
        await _userRef.doc(userId).set(UserModel(
              userId: userId!,
              name: _auth.currentUser?.displayName ?? "",
              email: _auth.currentUser?.email ?? "",
              avatarUrl: _auth.currentUser?.photoURL ?? "",
              createAt: DateTime.now().toUtc().millisecondsSinceEpoch,
              updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
            ));
      } else {
        Get.log("User data is exist");
      }
    } catch (error) {
      Get.log("Error: $error");
      rethrow;
    }
  }

  Future<bool> updateProficiency(String proficiency) async {
    try {
      var userId = _auth.currentUser?.uid;

      var data = <String, String>{"proficiency": proficiency};

      await _userRef.doc(userId).update(data);
      return true;
    } catch (error) {
      Get.log("Error: $error");
      return false;
    }
  }
}
