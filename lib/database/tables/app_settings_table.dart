import 'package:drift/drift.dart';
import 'users_table.dart';

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get currency => text().withDefault(const Constant('IDR'))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))(); // light, dark, system
  BoolColumn get isOnboardingCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isBiometricEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
