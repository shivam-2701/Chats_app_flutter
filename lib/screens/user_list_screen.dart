import 'package:chat_app/repositories/firebase_repo.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class UserListScreen extends StatelessWidget {
  static const routeName = "/users";
  UserListScreen({super.key});

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select User"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];

                  return ListTile(
                    onTap: () async {
                      final id = data.uid;
                      if (uid == id) return;

                      Navigator.of(context).pushNamed(
                        ChatScreen.routeName,
                        arguments: id,
                      );
                    },
                    title: Text(
                      data.username,
                    ),
                    leading: Hero(
                      tag: data.uid,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          data.image,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data?.length,
              ),
        future: FirebaseRepo.fetchAllUsers(),
      ),
    );
  }
}
