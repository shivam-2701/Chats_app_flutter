// ignore_for_file: deprecated_member_use

import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/user_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'firebase_options.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';

Future<void> main() async {
  //Add this to initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Till this
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> setRefreshRate() async {
    final supported = await FlutterDisplayMode.supported;
    await FlutterDisplayMode.setPreferredMode(supported[1]);
    setState(() {});
  }

  @override
  void initState() {
    setRefreshRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          colorScheme: ColorScheme.light(
            primary: const Color.fromARGB(255, 30, 189, 152),
            secondary: Colors.tealAccent[100] as Color,
          ),
          iconTheme: const IconThemeData(
            size: 25,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 2,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        darkTheme: ThemeData(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          colorScheme: ColorScheme.dark(
            primary: const Color.fromARGB(255, 30, 189, 152),
            secondary: Colors.tealAccent[100] as Color,
          ),
          iconTheme: const IconThemeData(
            size: 25,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 2,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Color.fromARGB(255, 30, 189, 152),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) =>
              snapshot.hasData ? const HomeScreen() : const AuthScreen(),
        ),
        routes: {
          UserListScreen.routeName: (context) => UserListScreen(),
          ChatScreen.routeName: (context) => ChatScreen(),
        },
      ),
    );
  }
}
