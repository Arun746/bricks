import 'package:{{project_name}}/core/services/http/http_service.dart';
import 'package:{{project_name}}/features/{{feature_name}}/repositories/{{feature_name}}_repository.dart';

class {{feature_name.pascalCase()}}RepositoryImpl implements {{feature_name.pascalCase()}}Repository {
  final HttpService httpService;
  {{feature_name.pascalCase()}}RepositoryImpl( this.httpService );
}