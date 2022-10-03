import 'package:shared_preferences/shared_preferences.dart';

Future<void> save(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String> load() async =>
    (await SharedPreferences.getInstance()).getString('token') ?? '';
