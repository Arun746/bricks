import 'package:freezed_annotation/freezed_annotation.dart';

part '{{feature_name}}_model.freezed.dart';

@freezed
sealed class {{feature_name.pascalCase()}}Model with _${{feature_name.pascalCase()}}Model {
  const factory {{feature_name.pascalCase()}}Model({
    required String id,
    @Default('') String title,
  }) = _{{feature_name.pascalCase()}}Model;
}
