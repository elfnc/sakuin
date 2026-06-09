import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sakuin/database/app_database.dart';
import 'package:sakuin/database/database_provider.dart';

final currentUserProvider = StreamProvider<User>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.users).watchSingle();
});
