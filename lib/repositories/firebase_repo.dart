import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../models/constants.dart';
import '../models/chat.dart';

class FirebaseRepo {
  static Stream<Chat> fetchAllChats() async* {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Authorization error. Kindly re-login.");
      }
      final stream =
          Constants.userCollection.doc("${user.uid}/chats").snapshots().map(
        (snapshot) {
          final dataMap = snapshot.data()!;
          return Chat.fromJSON(dataMap: {
            ...dataMap,
            "id": snapshot.id,
          });
        },
      );
      yield* stream;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      rethrow;
    }
  }

  static Stream<List<Message>> fetchGlobalChat() async* {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Authorization error. Kindly re-login.");
      }

      final stream = Constants.globalChatsCollection
          .orderBy(
            "timestamp",
            descending: true,
          )
          .snapshots()
          .map(
        (snapshot) {
          final dataList = snapshot.docs;
          return dataList
              .map(
                (message) => Message.fromJSON(
                  dataMap: {
                    ...message.data(),
                    "id": message.id,
                  },
                ),
              )
              .toList();
        },
      );
      yield* stream;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      rethrow;
    }
  }

  static Future<void> postGlobalMessage({
    required Message message,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Authorization Error. Kindly re-login.");
      }
      await Constants.globalChatsCollection.add(message.toJSON);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      rethrow;
    }
  }

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
