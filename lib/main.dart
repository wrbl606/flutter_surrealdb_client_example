import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surrealdb_client/surrealdb_client.dart';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String> loadToken() async =>
    (await SharedPreferences.getInstance()).getString('token') ?? '';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Surreal(
        SurrealClient(
          url: const String.fromEnvironment('SURREAL_RPC_URL'),
        ),
        namespace: 'test',
        database: 'test',
        child: MaterialApp(
          title: 'Surreal Auth',
          theme: ThemeData(colorSchemeSeed: Colors.white),
          routes: {
            '/home': (context) => const HomePage(),
            '/auth': (context) => const AuthPage(),
            '/': (context) => const InitPage(),
          },
        ),
      );
}

class Surreal extends InheritedWidget {
  final SurrealClient client;
  final String namespace;
  final String database;

  Surreal(
    this.client, {
    super.key,
    required super.child,
    required this.namespace,
    required this.database,
  }) {
    client.on('opened', (_) {
      return client.use(namespace, database);
    });
  }

  static Surreal of(BuildContext context) {
    final Surreal? result =
        context.dependOnInheritedWidgetOfExactType<Surreal>();
    assert(result != null, 'No Surreal found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant Surreal oldWidget) => false;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    loadToken().then((token) {
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
    loadToken().then((token) {
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
        appBar: AppBar(
          title: const Text('Auth page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final TextEditingController _userController;
  late final TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController();
    _passController = TextEditingController();
    loadToken().then((token) async {
      final client = Surreal.of(context).client;
      // FIXME: Bug in the Surreal instance?
      // authenticate rpc call doesn't generate any events
      final result = await client.authenticate(token);
    });
  }

  void _handleSign(
    Future Function(Map<String, dynamic>) function,
    ScaffoldMessengerState scaffoldMessenger,
    NavigatorState navigator,
    SurrealClient client,
  ) {
    function({
      'NS': 'test',
      'DB': 'test',
      'SC': 'allusers',
      'user': _userController.text,
      'pass': _passController.text,
    }).then((token) {
      saveToken(token).then((_) => navigator.pushNamed('/home'));
    }).catchError((value) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(value.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    final client = Surreal.of(context).client;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Wrap(
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'user'),
                controller: _userController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'pass'),
                controller: _passController,
              ),
              Wrap(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _handleSign(
                      client.signIn,
                      ScaffoldMessenger.of(context),
                      Navigator.of(context),
                      client,
                    ),
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _handleSign(
                      client.signUp,
                      ScaffoldMessenger.of(context),
                      Navigator.of(context),
                      client,
                    ),
                    icon: const Icon(Icons.login),
                    label: const Text('Sign up'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: Surreal.of(context).client.wait(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.microtask(
              () => Navigator.of(context).pushReplacementNamed('/auth'),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        },
      );
}
