import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wrench_and_bolts/core/services/storage/database/database_helpers/my_profile_helper.dart';
import 'package:wrench_and_bolts/core/services/storage/database/tables/my_profile_table.dart';

part 'database.g.dart';

final databaseProvider = Provider((ref) {
  final database = AppDatabase();
  ref.onDispose(() {
    try {
      // database.close();
    } catch (error, stackTrace) {
      Zone.current.handleUncaughtError(error, stackTrace);
    }
  });

  return database;
});

final myProfileHelperProvider = Provider((ref) {
  final database = ref.watch(databaseProvider);
  return MyProfileHelper(database);
});

@DriftDatabase(tables: [
  MyProfileTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );

  Future<void> clearAllTables() async {
    await delete(myProfileTable).go();
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'groov_database',
      native: const DriftNativeOptions(
        shareAcrossIsolates: false,
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
