import 'package:{{project_name}}/core/services/http/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final {{feature_name.camelCase()}}RepositoryProvider = Provider<{{feature_name.pascalCase()}}Repository>(
    (ref) => {{feature_name.pascalCase()}}RepositoryImpl(ref.read(httpServiceProvider)));