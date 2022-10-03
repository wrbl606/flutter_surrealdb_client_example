import 'package:flutter/material.dart';

class IncrementFab extends StatelessWidget {
  final void Function() onPressed;

  const IncrementFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      );
}
