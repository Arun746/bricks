import 'dart:io';

import 'package:mason/mason.dart';

/// Dependencies that can safely float to the latest version.
const _dependencies = [
  'dio',
  'pretty_dio_logger',
  'connectivity_plus',
  'package_info_plus',
  'device_info_plus',
  'email_validator',
  'flutter_secure_storage',
  'go_router',
  'hive_flutter',
  'video_thumbnail_plus',
  'android_id',
  'firebase_core',
  'firebase_messaging',
  'flutter_local_notifications',
];

/// The riverpod/freezed packages move as an interlocking set: floating them
/// independently produces unsolvable version states. They are therefore
/// pinned to one coherent major line and bumped together.
const _pinnedDependencies = [
  'flutter_riverpod:^3.0.0',
  'riverpod_annotation:^3.0.0',
  'freezed_annotation:^3.0.0',
  'json_annotation:^4.9.0',
];

/// Required for codegen (freezed / riverpod_generator / json_serializable)
/// and for the default analysis_options.yaml shipped by `flutter create`.
const _devDependencies = [
  'build_runner',
  'freezed:^3.0.0',
  'riverpod_generator:^3.0.0',
  'json_serializable',
  'flutter_lints',
];

Future<void> run(HookContext context) async {
  final projectName = context.vars['project_name'] as String;

  context.logger.info('');
  final depsOk = await _pubAdd(context, [..._dependencies, ..._pinnedDependencies]);
  final devDepsOk =
      depsOk ? await _pubAdd(context, _devDependencies, dev: true) : false;

  context.logger.info('');
  context.logger.info('========================================');
  if (depsOk && devDepsOk) {
    context.logger.success('Project "$projectName" created successfully!');
    context.logger.info('');
    context.logger.info('Next steps:');
    context.logger.info('1. dart run build_runner build -d');
  } else {
    context.logger.warn(
        'Project "$projectName" generated, but dependencies were not installed.');
    context.logger.info('');
    context.logger.info('Next steps:');
    context.logger.info(
        '1. Check your internet connection / Flutter setup, then run:');
    context.logger.info('   flutter pub add ${[..._dependencies, ..._pinnedDependencies].join(' ')}');
    context.logger.info(
        '   flutter pub add --dev ${_devDependencies.join(' ')}');
    context.logger.info('2. dart run build_runner build -d');
  }
  context.logger.info('========================================');
  context.logger.info('');
}

Future<bool> _pubAdd(
  HookContext context,
  List<String> packages, {
  bool dev = false,
}) async {
  final label = dev ? 'dev dependencies' : 'dependencies';
  final progress = context.logger.progress('Installing $label');

  try {
    final result = await Process.run(
      'flutter',
      [
        'pub',
        'add',
        if (dev) '--dev',
        ...packages,
      ],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      progress.fail('Failed to install $label');
      context.logger.err(result.stdout.toString());
      context.logger.err(result.stderr.toString());
      return false;
    }

    progress.complete('Installed ${packages.length} $label');
    return true;
  } catch (error) {
    progress.fail('Failed to install $label');
    context.logger
        .err('Could not run "flutter". Is Flutter on your PATH?\n$error');
    return false;
  }
}
