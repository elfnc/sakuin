import 'package:drift/drift.dart';
import 'savings_goals_table.dart';
import 'transactions_table.dart';

class SavingsContributions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get savingsGoalId => integer().references(SavingsGoals, #id)();
  IntColumn get transactionId => integer().nullable().references(Transactions, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get contributionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
