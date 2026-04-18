import 'package:drift/drift.dart';
import 'package:wrench_and_bolts/core/services/storage/database/database.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/user_box/user_box.dart';
import 'package:wrench_and_bolts/features/profile/models/my_profile_response.dart';

class MyProfileHelper {
  final AppDatabase _db;

  MyProfileHelper(this._db);

  Future<void> insertOrUpdate(MyProfileResponseData profile) async {
    final userId = profile.id;
    if (userId == null || userId.isEmpty) return;

    await (_db.delete(_db.myProfileTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .go();

    await _db.into(_db.myProfileTable).insert(MyProfileTableCompanion(
          userId: Value(userId),
          email: Value(profile.email),
          fullName: Value(profile.fullName),
          countryId: Value(profile.countryId),
          countryCode: Value(profile.countryCode),
          country: Value(profile.country),
          countryFlag: Value(profile.countryFlag),
          profilePhoto: Value(profile.profilePhoto),
          accountStatus: Value(profile.accountStatus),
          phoneNumber: Value(profile.phoneNumber),
          createdAt: Value(profile.createdAt),
        ));
  }

  Future<void> deleteProfile() async {
    await (_db.delete(_db.myProfileTable)).go();
  }

  Future<MyProfileTableData?> getProfile() async {
    final userId = UserBox.get()?.id;
    if (userId == null || userId.isEmpty) {
      return null;
    }
    final results = await (_db.select(_db.myProfileTable)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
    return results.isEmpty ? null : results.first;
  }

  Stream<MyProfileTableData?> watchProfile() {
    return _db.select(_db.myProfileTable).watchSingleOrNull();
  }
}
