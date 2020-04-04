import 'dart:io';

import 'package:path/path.dart' as path;

class WatchList {
  WatchList(List<String> patterns) {
    this.patterns = patterns.map(compilePattern).toList();
  }

  List<Pattern> patterns;

  bool match(String path) {
    return patterns.any((pattern) => pattern.allMatches(path).isNotEmpty);
  }

  static Pattern compilePattern(String pattern) {
    pattern = pattern.replaceAll('*', '(.+?)');
    pattern = pattern + '\$';
    return RegExp(pattern, caseSensitive: true);
  }
}

Stream<FileSystemEntity> scan(String dir) async* {
  await for (var entity in Directory(dir).list(followLinks: false)) {
    final filename = path.basename(entity.path);
    if (filename.startsWith('.')) {
      continue;
    }

    yield entity;
    if (entity is Directory) {
      yield* scan(entity.path);
    }
  }
}
