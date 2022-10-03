import 'package:flutter/widgets.dart';
import 'package:surrealdb_client/surrealdb_client.dart';

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
