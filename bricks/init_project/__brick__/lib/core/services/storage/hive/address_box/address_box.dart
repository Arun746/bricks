import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'address_box.g.dart';
part 'address_box.freezed.dart';

class AddressBox {
  static const boxKey = 'address';
  static const dataKey = 'data';

  static Future<void> open() async {
    await Hive.openBox(boxKey);
  }

  static Future<void> close() async {
    await Hive.box(boxKey).close();
  }

  static isOpen() => Hive.isBoxOpen(boxKey);
  static Future<int> clear() async => await Hive.box(boxKey).clear();

  static Future<void> set(Map<String, dynamic> data) async {
    try {
      await Hive.box(boxKey).put(dataKey, data);
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> update(AddressBoxProperties properties) async {
    try {
      var updateData = properties.toJson();
      final existing = get();
      if (existing != null) {
        updateData = existing
            .copyWith(
              latitude: properties.latitude,
              longitude: properties.longitude,
              formattedAddress: properties.formattedAddress,
            )
            .toJson();
      }

      await set(updateData);
    } catch (_) {
      rethrow;
    }
  }

  static AddressBoxProperties? get() {
    try {
      var data = Hive.box(boxKey).get(dataKey) as Map<dynamic, dynamic>?;
      if (data == null) {
        return null;
      }
      final casted = data.cast<String, dynamic>();
      return AddressBoxProperties.fromJson(casted);
    } catch (error, stackTrace) {
      Zone.current.handleUncaughtError(error, stackTrace);
      return null;
    }
  }

  static ValueListenable<Box<dynamic>> listenable() {
    return Hive.box(boxKey).listenable();
  }
}

@Freezed()
class AddressBoxProperties with _$AddressBoxProperties {
  factory AddressBoxProperties({
    required double? latitude,
    required double? longitude,
    required String? formattedAddress,
  }) = _AddressBoxProperties;

  factory AddressBoxProperties.fromJson(Map<String, dynamic> json) =>
      _$AddressBoxPropertiesFromJson(json);
}
