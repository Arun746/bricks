// TODO: Add your http service import
// import 'package:your_project/core/services/http/http_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final {{feature_name.camelCase()}}RepositoryProvider = Provider<{{feature_name.pascalCase()}}Repository>(
    (ref) => {{feature_name.pascalCase()}}RepositoryImpl(ref.read(httpServiceProvider)));