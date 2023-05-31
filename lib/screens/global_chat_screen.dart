import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/message_tile.dart';

class GlobalChatScreen extends StatelessWidget {
  GlobalChatScreen({super.key});

  final controller = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> trySubmit() async {
    final msg = controller.text.trim();

    if (msg.isEmpty) {
      return;
    }
    controller.clear();

    final user =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    await FirebaseFirestore.instance.collection("global_chat").add({
      "msgData": msg,
      "senderId": uid,
      "username": (user.data() as Map<String, dynamic>)["username"],
      "timestamp": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var data = snapshot.data?.docs
            as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
        return Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      showUserName: true,
                      username: data[index].data()["username"],
                      isMe: data[index].data()["senderId"] == uid,
                      msg: data[index].data()["msgData"],
                    );
                  },
                  itemCount: snapshot.data?.docs.length,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              margin: const EdgeInsets.only(
                bottom: 16,
                top: 10,
              ),
              child: CustomTextField(
                controller: controller,
                trySubmit: trySubmit,
              ),
            ),
          ],
        );
      },
      stream: FirebaseFirestore.instance
          .collection("global_chat")
          .orderBy(
            "timestamp",
            descending: true,
          )
          .snapshots(),
    );
  }
}
