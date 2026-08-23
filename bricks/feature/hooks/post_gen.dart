import 'package:mason/mason.dart';

void run(HookContext context) {
  final featureName = context.vars['feature_name'] as String;

  context.logger.info('');
  context.logger.success('Feature "$featureName" created!');
  context.logger.info('');
  context.logger.info('Next step:');
  context.logger.info('1. dart run build_runner build -d');
  context.logger.info('');
}
