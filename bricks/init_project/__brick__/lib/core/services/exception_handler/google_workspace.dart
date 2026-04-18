import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../configs/configs.dart';
import '../../exceptions/api_exception.dart';
import '../../utils/extensions/date_extensions.dart';

class GoogleWorkspace {
  static void logAll(
      {required Object error, required StackTrace stackTrace}) async {
    try {
      final String text = await _getText(error, stackTrace);
      final url = Configs.googleWorkspaceWebhookUrl;
      await Dio().post(url, data: {"text": text});
    } catch (_) {}
  }

  static Future<String> _getText(Object error, StackTrace stackTrace) async {
    const encoder = JsonEncoder.withIndent('  ');
    String errorText = '';
    if (error is ApiException) {
      if (error.fullResponse != null) {
        String formattedJsonString =
            encoder.convert(jsonDecode(error.fullResponse!));
        errorText = "```\n$formattedJsonString\n```";
      } else {
        errorText = "```\n${error.toString()}\n```";
      }
    } else {
      errorText = "`${error.toString()}`";
    }
    final String stackTraceText = "```${stackTrace.toString()}```";
    final String device = encoder.convert(
        Platform.isIOS ? await _iosInfoBlock() : await _androidInfoBlock());
    final user = encoder.convert(_userInfoBlock());
    final app = encoder.convert(await _appInfoBlock());

    return "${DateTime.now().formattedTimeIn12Hr}$errorText\n$stackTraceText\n\n\n```$device```\n```$user```\n```$app```";
  }

  static Future<Map> _androidInfoBlock() async {
    String ipv4 = '';
    AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
    final model = info.model;
    final manufacturer = info.manufacturer;
    final board = info.board;
    final bootloader = info.bootloader;
    final brand = info.brand;
    final device = info.device;
    final isPhysical = info.isPhysicalDevice == true ? "Yes" : "NO";
    final androidVersion = info.version.release;
    return {
      "Model": model,
      "Manufacturer": manufacturer,
      "Board": board,
      "Bootloader": bootloader,
      "Brand": brand,
      "Device": device,
      "IsPhysicalDevice": isPhysical,
      "AndroidVersion": androidVersion,
      "ipv4": ipv4
    };
  }

  static Future<Map> _iosInfoBlock() async {
    String ipv4 = '';
    IosDeviceInfo info = await DeviceInfoPlugin().iosInfo;
    final model = info.model;
    final name = info.name;
    final systemName = info.systemName;
    final systemVersion = info.systemVersion;
    final isPhysical = info.isPhysicalDevice == true ? "Yes" : "NO";

    return {
      "Model": model,
      "Name": name,
      "SystemName": systemName,
      "SystemVersion": systemVersion,
      "IsPhysicalDevice": isPhysical,
      "ipv4": ipv4
    };
  }

  static Map _userInfoBlock() {
    return{};
    // String? email = UserBox.get()?.email;
    // String? username = UserBox.get()?.username;
    // return {"Username": username};
  }

  static Future<Map> _appInfoBlock() async {
    final info = await PackageInfo.fromPlatform();
    final appVersion = info.version;
    final buildNumber = info.buildNumber;
    return {"version": "$appVersion+$buildNumber"};
  }

  // ignore: unused_element
  static Map _requestInfoBlock(requestInfoMap) {
    String? url = "empty";
    String? method = "empty";
    String queryParameters = "empty";
    try {
      Map rm = jsonDecode(requestInfoMap!);
      url = rm['url'];
      method = rm['method'];
      queryParameters = rm['query_parameters'].toString();
    } catch (_) {}
    return {"Url": url, "Method": method, "QueryParameters": queryParameters};
  }
}
