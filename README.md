# surreal_auth

Example app with SurrealDB as backed.

Features:
  - Sign up, sign in
  - Storing and fetching user's counter values

## Getting Started

Before the app can use Surreal's sign up/in feature following preparation is necessary.

### Configure Surreal instance

Connect to your instance as with `surreal sql`, eg.

```
surreal sql --user root --pass root --db test --ns test --pretty --conn http://localhost:8000
```

Run following commands:

1. Define a table for storing user data. Set permissions to disallow users creating and deleting records, and allow reading and updating user's record:   
```
DEFINE TABLE user SCHEMALESS
	PERMISSIONS
		FOR select, update WHERE id = $auth.id,
		FOR create, delete NONE;
```

2. Define a scope to which users can sign up/in: 
```
DEFINE SCOPE allusers
	SESSION 7d
	SIGNUP (CREATE user SET user=$user, pass=crypto::argon2::generate($pass))
	SIGNIN (SELECT * FROM user WHERE user=$user AND crypto::argon2::compare(pass, $pass));
```

3. Create a counter table for storing user's counter readings:
```
CREATE TABLE counter;
```

After finishing above steps your database should response to `INFO FOR DB;` like so:

```
[
  {
    "result": {
      "dl": {},
      "dt": {},
      "sc": {
        "allusers": "DEFINE SCOPE allusers SESSION 1w SIGNUP (CREATE user SET user = $user, pass = crypto::argon2::generate($pass)) SIGNIN (SELECT * FROM user WHERE user = $user AND crypto::argon2::compare(pass, $pass))"
      },
      "tb": {
        "counter": "DEFINE TABLE counter SCHEMALESS",
        "user": "DEFINE TABLE user SCHEMALESS PERMISSIONS FOR select WHERE id = $auth.id, FOR create NONE, FOR update WHERE id = $auth.id, FOR delete NONE"
      }
    },
    "status": "OK",
    "time": "70.528µs"
  }
]
```

### Configure the app

The app is expecting the `SURREAL_RPC_URL` key to be set via `--dart-define`, eg:

CLI:
```
flutter run --dart-define SURREAL_RPC_URL=http://localhost:8000/rpc
```

VSCode config at `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "surreal_auth",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define",
        "SURREAL_RPC_URL=http://localhost:8000/rpc"
      ]
    },
    {
      "name": "surreal_auth (profile mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile",
      "args": [
        "--dart-define",
        "SURREAL_RPC_URL=http://localhost:8000/rpc"
      ]
    },
    {
      "name": "surreal_auth (release mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release",
      "args": [
        "--dart-define",
        "SURREAL_RPC_URL=http://localhost:8000/rpc"
      ]
    }
  ]
}
```
