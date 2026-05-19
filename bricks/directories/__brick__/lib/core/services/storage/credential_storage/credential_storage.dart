import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  setCredential({required String username, required String password}) async {
    try {
      await storage.write(key: "username", value: username);
      await storage.write(key: "password", value: password);
      await storage.write(key: "hascredentials", value: "1");
    } catch (_) {
      rethrow;
    }
  }

  Future<({String username, String password})> getCredential() async {
    try {
      final username = (await storage.read(key: "username"))!;
      final password = (await storage.read(key: "password"))!;

      return (username: username, password: password);
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> hasCredentials() async {
    bool retVal = false;
    try {
      final existingCreds = await storage.read(key: "hascredentials");
      retVal = existingCreds == "1";
    } catch (_) {}
    return retVal;
  }

  Future<void> eraseIfDifferent(String username) async {
    if (await hasCredentials()) {
      if ((await getCredential()).username != username) {
        await eraseCredentials();
      }
    }
  }

  Future<void> eraseCredentials() async {
    try {
      await storage.delete(key: "username");
      await storage.delete(key: "password");
      await storage.delete(key: "hascredentials");
    } catch (_) {
      rethrow;
    }
  }
}
