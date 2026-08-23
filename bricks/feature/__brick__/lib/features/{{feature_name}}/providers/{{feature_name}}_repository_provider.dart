import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:{{project_name}}/core/services/http/http_service_impl.dart';
import 'package:{{project_name}}/features/{{feature_name}}/repositories/{{feature_name}}_repository.dart';
import 'package:{{project_name}}/features/{{feature_name}}/repositories/{{feature_name}}_repository_impl.dart';

part '{{feature_name}}_repository_provider.g.dart';

@riverpod
{{feature_name.pascalCase()}}Repository {{feature_name.camelCase()}}Repository(Ref ref) {
  return {{feature_name.pascalCase()}}RepositoryImpl(ref.read(httpServiceProvider));
}
