import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import "../helpers/firebase_helper.dart";

enum AuthStatus {
  login,
  signUp,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthStatus _authStatus = AuthStatus.signUp;
  // ignore: prefer_final_fields
  Map<String, String> _formData = {};
  UserCredential? _user;
  File? _userImage;

  bool _isLoading = false;

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 200,
    );
    setState(() {
      _userImage = File(pickedImage?.path as String);
    });
  }

  void _trySubmit() async {
    FocusScope.of(context).unfocus();
    if (_authStatus == AuthStatus.signUp && _userImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add a profile picture."),
        ),
      );
      return;
    }
    bool isValid = _formKey.currentState?.validate() as bool;

    setState(() {
      _isLoading = true;
    });

    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    try {
      if (_authStatus == AuthStatus.signUp) {
        _user = await FirebaseHelper.signUp(
          _formData['email'],
          _formData['password'],
        );

        final url = await FirebaseHelper.uploadImage(
          imagePath: _user?.user?.uid,
          fileName: _userImage,
        );

        FirebaseHelper.setUserData(
          path: _user?.user?.uid,
          username: _formData["username"],
          email: _formData["email"],
          imageUrl: url,
        );
      } else {
        _user = await FirebaseHelper.signIn(
          _formData["email"] as String,
          _formData["password"] as String,
        );
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      _formKey.currentState?.reset();
      final String errMsg = error.code
          .split('-')
          .map((element) => element[0].toUpperCase() + element.substring(1))
          .join(" ");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Oops, An error occured!"),
          icon: const Icon(Icons.help_outline),
          iconColor: Colors.red,
          content: Text(
            errMsg,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).viewPadding,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                if (_authStatus == AuthStatus.signUp)
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: _userImage == null
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      backgroundImage: _userImage == null
                          ? null
                          : FileImage(_userImage as File),
                      child: _userImage == null
                          ? Icon(
                              Icons.camera_alt_rounded,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 60,
                            )
                          : null,
                    ),
                  ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  _authStatus == AuthStatus.signUp
                      ? "Welcome, let's sign you up!"
                      : "Welcome back!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Email"),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a valid email address.";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _formData['email'] = newValue as String;
                          },
                          autofillHints: const [
                            AutofillHints.email,
                          ],
                        ),
                        if (_authStatus == AuthStatus.signUp)
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text("Username"),
                            ),
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter a valid username.";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _formData['username'] = newValue as String;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text("Password"),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a valid password.";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _formData['password'] = newValue as String;
                          },
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(
                          _authStatus == AuthStatus.signUp
                              ? "Sign Up"
                              : "Log In",
                        ),
                      ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_authStatus == AuthStatus.signUp) {
                        _authStatus = AuthStatus.login;
                      } else {
                        _authStatus = AuthStatus.signUp;
                      }
                    });
                  },
                  child: Text(
                    _authStatus == AuthStatus.signUp
                        ? "Have an account, log in instead?"
                        : "Don't have an account, register?",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
