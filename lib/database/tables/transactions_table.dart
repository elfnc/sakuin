import 'package:drift/drift.dart';
import 'users_table.dart';
import 'wallets_table.dart';
import 'categories_table.dart';
import 'receipt_scans_table.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get walletId => integer().references(Wallets, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get type => text()(); // income, expense
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get source => text().withDefault(const Constant('manual'))(); // manual, ocr, savings_goal
  IntColumn get receiptScanId => integer().nullable().references(ReceiptScans, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
