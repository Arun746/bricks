import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  final pubspec = File('pubspec.yaml');

  if (!pubspec.existsSync()) {
    context.logger.err(
      'pubspec.yaml not found in "${Directory.current.path}". '
      'Run this brick from your Flutter app root directory.',
    );
    exit(1);
  }

  final match = RegExp(
    r'^name:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec.readAsStringSync());

  if (match == null) {
    context.logger.err('Could not read "name" from pubspec.yaml.');
    exit(1);
  }

  context.vars['project_name'] = match.group(1)!;
  context.logger.info('Detected package: ${match.group(1)}');
}
