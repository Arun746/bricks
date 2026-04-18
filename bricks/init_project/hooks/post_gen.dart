import 'dart:io';
import 'package:mason/mason.dart';

void run(HookContext context) async {
  final projectName = context.vars['project_name'] as String;
  final projectDir = Directory.current.path;

  context.logger.info('');
  context.logger.info('========================================');
  context.logger.info('Project "$projectName" created successfully!');
  context.logger.info('========================================');
  context.logger.info('');
  context.logger.info('Next steps:');
  context.logger.info('1. cd $projectName');
  context.logger.info('2. flutter pub get');
  context.logger.info('3. dart run build_runner build -d');
  context.logger.info('');
}
