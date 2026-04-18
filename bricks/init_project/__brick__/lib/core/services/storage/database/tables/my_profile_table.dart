import 'package:drift/drift.dart';

class MyProfileTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().unique()();
  TextColumn get email => text().nullable()();
  TextColumn get fullName => text().nullable()();
  TextColumn get countryId => text().nullable()();
  TextColumn get countryCode => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get countryFlag => text().nullable()();
  TextColumn get profilePhoto => text().nullable()();
  TextColumn get accountStatus => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}
