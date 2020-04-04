/// Support for doing something awesome.
///
/// More dartdocs go here.
library restarter;

import 'dart:async';
import 'dart:io';

import 'package:restarter/src/utils.dart';

class Restarter {
  Restarter(
    this.executable, {
    this.args,
    this.workingDirectory,
    this.environment,
    this.includeParentEnvironment = false,
    this.runInShell = false,
    this.watch,
    this.ignore,
    this.delay,
  });

  final String executable;
  final List<String> args;
  final String workingDirectory;
  final Map<String, String> environment;
  final bool includeParentEnvironment;
  final bool runInShell;

  final List<String> watch;
  final List<String> ignore;
  final Duration delay;

  Process _process;
  bool _initialized = false;
  bool _restarting = false;
  final _subscriptions = <StreamSubscription>[];

  void _connectIO() {
    if (_process == null) return;
    stdout.addStream(_process.stdout);
    stderr.addStream(_process.stderr);
  }

  void _subscript(FileSystemEntity entity) {
    final sub = entity.watch().listen((_) => restart());
    _subscriptions.add(sub);
  }

  Future<void> _unsubscriptAll() {
    final futures = _subscriptions.map((s) => s.cancel());
    return Future.wait(futures);
  }

  Future<void> _init() async {
    if (_initialized) return;

    final watchList = WatchList(watch ?? []);
    final ignoreList = WatchList(ignore ?? []);
    await scan('.')
        .where((entity) => watchList.match(entity.path))
        .where((entity) => !ignoreList.match(entity.path))
        .forEach(_subscript);

    _initialized = true;
  }

  Future<void> start() async {
    if (_process != null) return;
    _process = await Process.start(
      executable,
      args,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
    );
    _connectIO();

    await _init();
  }

  Future<void> restart() async {
    if (_restarting) return;
    _restarting = true;

    _process.kill(ProcessSignal.sigusr2);
    await _process.exitCode;
    _process = null;
    await start();

    _restarting = false;
  }

  Future<void> stop() async {
    _process.kill(ProcessSignal.sigusr2);
    await _unsubscriptAll();
  }
}
