import 'package:drift/drift.dart';
import 'users_table.dart';
import 'categories_table.dart';

class MonthlySnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  RealColumn get totalIncome => real().withDefault(const Constant(0.0))();
  RealColumn get totalExpense => real().withDefault(const Constant(0.0))();
  RealColumn get totalSaving => real().withDefault(const Constant(0.0))();
  IntColumn get topCategoryId => integer().nullable().references(Categories, #id)();
  RealColumn get endingBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
