import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/new_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_list_screen.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.of(context).pushNamed(UserListScreen.routeName);
        },
        child: const Icon(
          Icons.message_rounded,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          // ignore: prefer_is_empty
          if (snapshot.data?.docs.length == 0) {
            return const NewUser();
          }
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => ListTile(
                    leading: Hero(
                      tag: (snapshot.data?.docs[index].data()
                          as Map<String, dynamic>)["image_url"],
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          (snapshot.data?.docs[index].data()
                              as Map<String, dynamic>)["image_url"],
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      (snapshot.data?.docs[index].data()
                          as Map<String, dynamic>)["username"],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                      ),
                    ),
                    minLeadingWidth: 40,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 10,
                    ),
                    horizontalTitleGap: 5,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ChatScreen.routeName,
                        arguments: snapshot.data?.docs[index].id,
                      );
                    },
                  ),
                  itemCount: snapshot.data?.docs.length,
                );
        },
        stream: FirebaseFirestore.instance
            .collection("users/$_uid/chats")
            .snapshots(),
      ),
    );
  }
}
