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
        future: FirebaseFirestore.instance
            .collection("users")
            .orderBy("username")
            .get(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) =>
                        snapshot.data?.docs[index].id == uid
                            ? const SizedBox(
                                height: 0,
                              )
                            : ListTile(
                                onTap: () async {
                                  final id =
                                      snapshot.data?.docs[index].id as String;

                                  Navigator.of(context).pushNamed(
                                    ChatScreen.routeName,
                                    arguments: id,
                                  );
                                },
                                title: Text(
                                  (snapshot.data?.docs[index].data()
                                      as Map<String, dynamic>)["username"],
                                ),
                                leading: Hero(
                                  tag: (snapshot.data?.docs[index].data()
                                      as Map<String, dynamic>)["image_url"],
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      (snapshot.data?.docs[index].data()
                                          as Map<String, dynamic>)["image_url"],
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                    itemCount: snapshot.data?.size,
                  ),
      ),
    );
  }
}
