
<p>
  <img src="https://raw.githubusercontent.com/xtyxtyx/restarter/master/image/logo.png">
</p>

Watch and Restart made easy.

Restarter is a tool that detects file changes and automatically restarts the application.

## Usage

```dart
import 'package:restarter/restarter.dart';

void main() {
  final restarter = Restarter(
    'dart',
    args: ['example/counter.dart'],
    watch: ['*.dart', 'pubspec.lock'],
  );
  restarter.start();
}
```

<p>
  <img src="https://raw.githubusercontent.com/xtyxtyx/restarter/master/image/example.png">
</p>

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

## License

```
MIT
```

[tracker]: https://github.com/xtyxtyx/restarter/issues
