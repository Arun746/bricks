import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{{feature_name}}_provider.freezed.dart';
part '{{feature_name}}_provider.g.dart';

@freezed
sealed class {{feature_name.pascalCase()}}State with _${{feature_name.pascalCase()}}State {
  const factory {{feature_name.pascalCase()}}State({
    @Default(false) bool isLoading,
  }) = _{{feature_name.pascalCase()}}State;
}

@riverpod
class {{feature_name.pascalCase()}} extends _${{feature_name.pascalCase()}} {
  @override
  {{feature_name.pascalCase()}}State build() {
    return const {{feature_name.pascalCase()}}State();
  }
}