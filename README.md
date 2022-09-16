# surreal_auth

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

SurrealQL:

```
USE NS test DB test;
DEFINE TABLE user SCHEMALESS
	PERMISSIONS
		FOR select, update WHERE id = $auth.id,
		FOR create, delete NONE;
DEFINE SCOPE allusers
	SESSION 7d
	SIGNUP (CREATE user SET user=$user, pass=crypto::argon2::generate($pass))
	SIGNIN (SELECT * FROM user WHERE user=$user AND crypto::argon2::compare(pass, $pass));
CREATE TABLE counter;
```