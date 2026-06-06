import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Import tables
import 'tables/users_table.dart';
import 'tables/wallets_table.dart';
import 'tables/categories_table.dart';
import 'tables/transactions_table.dart';
import 'tables/savings_goals_table.dart';
import 'tables/savings_contributions_table.dart';
import 'tables/receipt_scans_table.dart';
import 'tables/monthly_snapshots_table.dart';
import 'tables/app_settings_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Users,
  Wallets,
  Categories,
  Transactions,
  SavingsGoals,
  SavingsContributions,
  ReceiptScans,
  MonthlySnapshots,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // Default user
          final userId = await into(users).insert(
            UsersCompanion.insert(
              name: 'Sakuin User',
            ),
          );

          // Seed default settings
          await into(appSettings).insert(
            AppSettingsCompanion.insert(
              userId: userId,
              currency: const Value('IDR'),
              isOnboardingCompleted: const Value(false),
            ),
          );

          // Seed default wallet
          await into(wallets).insert(
            WalletsCompanion.insert(
              userId: userId,
              name: 'Dompet Utama',
              type: 'cash',
              isDefault: const Value(true),
            ),
          );

          // Seed default categories
          final defaultCategories = [
            CategoriesCompanion.insert(userId: userId, name: 'Makan', type: 'expense', isDefault: const Value(true)),
            CategoriesCompanion.insert(userId: userId, name: 'Transportasi', type: 'expense', isDefault: const Value(true)),
            CategoriesCompanion.insert(userId: userId, name: 'Gaji', type: 'income', isDefault: const Value(true)),
            CategoriesCompanion.insert(userId: userId, name: 'Tabungan', type: 'savings', isDefault: const Value(true)),
          ];
          for (final category in defaultCategories) {
            await into(categories).insert(category);
          }
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sakuin_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
