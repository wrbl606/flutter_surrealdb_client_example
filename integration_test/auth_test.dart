import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:surreal_auth/main.dart';

void main() {
  late final int timestamp;
  const counterClicks = 10;
  setUpAll(() {
    timestamp = DateTime.now().millisecondsSinceEpoch;
  });

  patrolTest('signs up user', ($) async {
    await $.pumpWidgetAndSettle(MyApp());
    await $(TextField).first.enterText('user$timestamp');
    await $(TextField).last.enterText('password$timestamp');
    await $('Sign up').tap();
    expect($('You have pushed the button this many times:'), findsOneWidget);

    for (var i = 0; i < counterClicks; i++) {
      await $(FloatingActionButton).tap();
    }

    expect($(counterClicks.toRadixString(10)), findsOneWidget);
  });

  patrolTest('signs in user', ($) async {
    await $.pumpWidgetAndSettle(MyApp());
    await $(TextField).first.enterText('user$timestamp');
    await $(TextField).last.enterText('password$timestamp');
    await $('Sign in').tap();
    expect($('You have pushed the button this many times:'), findsOneWidget);

    expect($(counterClicks.toRadixString(10)), findsOneWidget);

    for (var i = 0; i < counterClicks; i++) {
      await $(FloatingActionButton).tap();
    }

    expect($((counterClicks * 2).toRadixString(10)), findsOneWidget);
  });
}
