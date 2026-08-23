import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:{{project_name}}/core/configs/configs.dart';
import 'package:{{project_name}}/core/services/exception_handler/google_workspace.dart';


class ExceptionHandler {
  static void catchAll({
    required Object error,
    required StackTrace stackTrace,
  }) {
    if (kDebugMode) {
      log(
        '🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥',
      );
      if (error is DioException) {
        print(error.response);
      }
      log('''
                        ERROR
                        -----
${error.toString()}
----------------------------------------------------------------------------------------------------------------------------------------
                      STACKTRACE
                      ---------
$stackTrace''');
      log(
        '🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥',
      );
    } else {
      handleProductionException(error, stackTrace);
    }
  }

  static handleProductionException(Object error, StackTrace stackTrace) {
    if (Configs.currentStage == ConfigEnums.staging.name ||
        Configs.currentStage == ConfigEnums.development.name) {
      GoogleWorkspace.logAll(error: error, stackTrace: stackTrace);
    }

    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
