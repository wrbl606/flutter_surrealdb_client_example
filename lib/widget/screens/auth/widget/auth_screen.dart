import 'package:flutter/material.dart';
import 'package:surreal_auth/repository/token.dart' as token;
import 'package:surreal_auth/widget/common/surreal.dart';
import 'package:surrealdb_client/surrealdb_client.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final TextEditingController _userController;
  late final TextEditingController _passController;

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController();
    _passController = TextEditingController();
    token.load().then((token) async {
      final client = Surreal.of(context).client;
      // FIXME: Bug in the Surreal instance?
      // authenticate rpc call doesn't generate any events
      // ignore: unused_local_variable
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
    }).then((receivedToken) {
      token.save(receivedToken).then((_) => navigator.pushNamed('/home'));
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
