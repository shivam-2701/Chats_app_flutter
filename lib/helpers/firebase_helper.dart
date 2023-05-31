import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static Future<UserCredential> signUp(String? email, String? password) async {
    final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email as String,
      password: password as String,
    );

    return user;
  }

  static Future<String> uploadImage({String? imagePath, File? fileName}) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("user_data")
        .child("$imagePath.jpg");

    await ref.putFile(fileName as File);
    final url = await ref.getDownloadURL();

    return url;
  }

  static Future<void> setUserData({
    String? path,
    String? username,
    String? email,
    String? imageUrl,
  }) async {
    FirebaseFirestore.instance.doc("users/$path").set(
      {
        "username": username,
        "email": email,
        "image_url": imageUrl,
      },
    );
    return;
  }

  static Future<UserCredential> signIn(
    String email,
    String password,
  ) async {
    final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user;
  }
}
