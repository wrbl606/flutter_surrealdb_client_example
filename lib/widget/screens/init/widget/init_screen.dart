import 'package:flutter/material.dart';
import 'package:surreal_auth/widget/common/surreal.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: Surreal.of(context).client.wait(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.microtask(
              () => Navigator.of(context).pushReplacementNamed('/auth'),
            );
          }

          return const InitScreenContent();
        },
      );
}

class InitScreenContent extends StatelessWidget {
  const InitScreenContent({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
}
