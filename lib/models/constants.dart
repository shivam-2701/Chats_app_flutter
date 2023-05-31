import 'package:cloud_firestore/cloud_firestore.dart';

class Constants {
  static final userCollection = FirebaseFirestore.instance.collection("users");
  static final chatCollection = FirebaseFirestore.instance.collection("chats");
  static final globalChatsCollection =
      FirebaseFirestore.instance.collection("global_chats");
}
