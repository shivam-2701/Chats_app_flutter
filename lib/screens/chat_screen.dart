import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/message_tile.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = "/chat";
  ChatScreen({super.key});

  final _uid = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _controller = TextEditingController();

  Future<DocumentSnapshot<Map<String, dynamic>>> _createChat(String id) async {
    final check = await FirebaseFirestore.instance
        .collection("users/$_uid/chats")
        .doc(id)
        .get();
    if (check.data() != null) {
      return FirebaseFirestore.instance
          .collection("users/$_uid/chats")
          .doc(id)
          .get();
    }
    final targetDetails =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    final userDetails =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    final res = await FirebaseFirestore.instance.collection("chats").add({});
    await FirebaseFirestore.instance
        .collection("users/$_uid/chats")
        .doc(id)
        .set({
      "chatId": res.id,
      "username": (targetDetails.data() as Map<String, dynamic>)["username"],
      "image_url": (targetDetails.data() as Map<String, dynamic>)["image_url"],
    });
    await FirebaseFirestore.instance
        .collection("users/$id/chats")
        .doc(_uid)
        .set({
      "chatId": res.id,
      "username": (userDetails.data() as Map<String, dynamic>)["username"],
      "image_url": (userDetails.data() as Map<String, dynamic>)["image_url"],
    });
    return FirebaseFirestore.instance
        .collection("users/$_uid/chats")
        .doc(id)
        .get();
  }

  Future<void> _trySubmit(String chatId) async {
    final msg = _controller.text.trim();

    if (msg.isEmpty) {
      return;
    }
    _controller.clear();

    await FirebaseFirestore.instance.collection("chats/$chatId/messages").add({
      "msgData": msg,
      "senderId": _uid,
      "timestamp": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)?.settings.arguments as String;

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final chatData = snapshot.data?.data() as Map<String, dynamic>;
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Row(
              children: [
                Hero(
                  tag: chatData["image_url"],
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(chatData["image_url"]),
                  ),
                ),
                const SizedBox(width: 10),
                Text(chatData["username"]),
              ],
            ),
          ),
          body: StreamBuilder(
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
                        reverse: true,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            isMe: (data[index].data())["senderId"] == _uid,
                            msg: (data[index].data())["msgData"],
                          );
                        },
                        itemCount: data.length,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              label: const Text("Type a message"),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.5),
                              ),
                              constraints: const BoxConstraints(
                                maxHeight: 45,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 15,
                              ),
                              prefixIcon: const Icon(Icons.keyboard),
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        FloatingActionButton(
                          onPressed: () => _trySubmit(chatData["chatId"]),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            stream: FirebaseFirestore.instance
                .collection("chats/${chatData["chatId"]}/messages")
                .orderBy(
                  "timestamp",
                  descending: true,
                )
                .snapshots(),
          ),
        );
      },
      future: _createChat(routeData),
    );
  }
}
