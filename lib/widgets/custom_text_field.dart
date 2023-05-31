import "package:flutter/material.dart";

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.trySubmit,
  });

  final TextEditingController controller;
  final Function trySubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: const Text("Say Hi!"),
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
          onPressed: () => trySubmit(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child: const Icon(Icons.send),
        ),
      ],
    );
  }
}
