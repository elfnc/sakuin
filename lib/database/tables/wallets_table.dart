import 'package:drift/drift.dart';
import 'users_table.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get type => text()(); // cash, bank, ewallet, savings
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get icon => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
