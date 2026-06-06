import 'package:drift/drift.dart';
import 'users_table.dart';

class ReceiptScans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get imagePath => text()();
  TextColumn get rawText => text().nullable()();
  RealColumn get detectedAmount => real().nullable()();
  TextColumn get merchantName => text().nullable()();
  DateTimeColumn get receiptDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, processed, failed
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
