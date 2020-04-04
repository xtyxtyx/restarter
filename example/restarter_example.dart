import 'package:restarter/restarter.dart';

void main() {
  final restarter = Restarter(
    'dart',
    args: ['example/counter.dart'],
    watch: ['*.dart', 'pubspec.lock'],
  );
  restarter.start();
}
