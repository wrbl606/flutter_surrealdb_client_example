import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final num counter;

  const Counter({super.key, this.counter = 0});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      );
}
