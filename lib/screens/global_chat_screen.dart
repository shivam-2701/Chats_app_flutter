import 'package:chat_app/models/message.dart';
import 'package:chat_app/repositories/firebase_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/message_tile.dart';

class GlobalChatScreen extends StatelessWidget {
  GlobalChatScreen({
    super.key,
  });

  final controller = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> trySubmit() async {
    final msg = controller.text.trim();

    if (msg.isEmpty) {
      return;
    }
    controller.clear();

    try {
      final user = FirebaseAuth.instance.currentUser;
      final newMessage = Message(
        message: msg,
        createdOn: DateTime.now(),
        senderUID: user!.uid,
        senderName: user.displayName!,
      );
      await FirebaseRepo.postGlobalMessage(message: newMessage);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var data = snapshot.data!;

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
                      username: data[index].senderName,
                      isMe: data[index].senderUID == uid,
                      msg: data[index].message,
                    );
                  },
                  itemCount: snapshot.data?.length,
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
      stream: FirebaseRepo.fetchGlobalChat(),
    );
  }
}
