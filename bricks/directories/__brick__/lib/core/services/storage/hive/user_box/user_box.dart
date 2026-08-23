import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_box.g.dart';

class UserBox {
  static const boxKey = 'user';
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

  static Future<void> update(UserBoxProperties properties) async {
    try {
      var updateData = properties.toJson();
      final existing = get();
      if (existing != null) {
        updateData = existing
            .copyWith(
              id: properties.id,
              username: properties.username,
            )
            .toJson();
      }

      await set(updateData);
    } catch (_) {
      rethrow;
    }
  }

  static UserBoxProperties? get() {
    try {
      var data = Hive.box(boxKey).get(dataKey) as Map<dynamic, dynamic>?;
      if (data == null) {
        return null;
      }
      // Backward compatibility: default 'avatar' to false if missing
      final casted = data.cast<String, dynamic>();
      casted.putIfAbsent('avatar', () => false);
      return UserBoxProperties.fromJson(casted);
    } catch (error, stackTrace) {
      Zone.current.handleUncaughtError(error, stackTrace);
      return null;
    }
  }

  static ValueListenable<Box<dynamic>> listenable() {
    return Hive.box(boxKey).listenable();
  }
}

@JsonSerializable()
class UserBoxProperties {
  UserBoxProperties({
    required this.username,
    required this.id,
  });

  factory UserBoxProperties.fromJson(Map<String, dynamic> json) =>
      _$UserBoxPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$UserBoxPropertiesToJson(this);

  final String? username;
  final String id;

  UserBoxProperties copyWith({
    String? username,
    String? id,
  }) {
    return UserBoxProperties(
      username: username ?? this.username,
      id: id ?? this.id,
    );
  }
}
