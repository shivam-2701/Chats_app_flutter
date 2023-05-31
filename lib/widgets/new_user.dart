import 'package:flutter/material.dart';

class NewUser extends StatelessWidget {
  const NewUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.help_outline,
            size: 60,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            "New here?\nTry texting Kirei_Senpai!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
