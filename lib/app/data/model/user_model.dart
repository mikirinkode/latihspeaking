import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? name;
  String? email;
  String? avatarUrl;
  int? createAt;
  int? updatedAt;
  String? proficiency;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.createAt,
    required this.updatedAt,
    this.proficiency,
  });

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return UserModel(
      userId: data?['userId'],
      name: data?['name'],
      email: data?['email'],
      avatarUrl: data?['avatarUrl'],
      createAt: data?['createAt'],
      updatedAt: data?['updatedAt'],
      proficiency: data?['proficiency'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'createAt': createAt,
      'updatedAt': updatedAt,
      'proficiency': proficiency,
    };
  }
}
