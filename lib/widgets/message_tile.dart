import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final bool isMe;
  final String msg;
  final bool showUserName;
  final String username;

  const MessageTile({
    this.isMe = false,
    this.msg = '',
    super.key,
    this.username = "Hello",
    this.showUserName = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.3,
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 10,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showUserName)
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isMe
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              if (showUserName)
                const SizedBox(
                  height: 5,
                ),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16,
                  color: isMe
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
