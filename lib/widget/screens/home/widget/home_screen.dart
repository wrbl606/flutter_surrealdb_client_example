import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:surreal_auth/repository/token.dart' as token;
import 'package:surreal_auth/widget/common/surreal.dart';
import 'package:surreal_auth/widget/screens/home/widget/widget/counter.dart';
import 'package:surreal_auth/widget/screens/home/widget/widget/increment_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    token.load().then((token) {
      final client = Surreal.of(context).client;
      final userId = JwtDecoder.decode(token)['id'];
      client
          .query(
              'SELECT value FROM counter WHERE user = $userId ORDER BY value DESC LIMIT 1')
          .then((result) {
        if (result[0]['result'].isEmpty) {
          return;
        }
        final counter = result[0]['result'][0]['value'];
        setState(() {
          _counter = counter;
        });
      });
    });
  }

  void _incrementCounter() {
    final client = Surreal.of(context).client;
    final counter = _counter + 1;
    token.load().then((token) {
      final userId = JwtDecoder.decode(token)['id'];
      client.create('counter', {
        'value': counter,
        'user': userId,
        'clicked_at': DateTime.now().toIso8601String(),
      });
    });
    setState(() {
      _counter = counter;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Auth page')),
        body: Center(child: Counter(counter: _counter)),
        floatingActionButton: IncrementFab(onPressed: _incrementCounter),
      );
}
