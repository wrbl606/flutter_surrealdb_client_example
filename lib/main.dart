import 'package:flutter/material.dart';
import 'package:surreal_auth/widget/common/surreal.dart';
import 'package:surreal_auth/widget/common/theme.dart';
import 'package:surreal_auth/widget/screens/auth/widget/auth_screen.dart';
import 'package:surreal_auth/widget/screens/home/widget/home_screen.dart';
import 'package:surreal_auth/widget/screens/init/widget/init_screen.dart';
import 'package:surrealdb_client/surrealdb_client.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = {
    '/home': (context) => const HomeScreen(),
    '/auth': (context) => const AuthScreen(),
    '/': (context) => const InitScreen(),
  };
  MyApp({super.key});

  @override
  Widget build(BuildContext context) => Surreal(
        SurrealClient(
          url: const String.fromEnvironment('SURREAL_RPC_URL'),
        ),
        namespace: 'test',
        database: 'test',
        child: MaterialApp(
          title: 'Surreal Auth',
          theme: theme,
          routes: routes,
        ),
      );
}
