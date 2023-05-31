import 'package:chat_app/screens/global_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import "./chat_list_screen.dart";

enum Menu {
  logOut,
  help,
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatsApp"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
        bottom: const TabBar(
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Text("CHAT"),
            ),
            Tab(
              child: Text("GLOBAL CHAT"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          ChatListScreen(),
          GlobalChatScreen(),
        ],
      ),
    );
  }
}
