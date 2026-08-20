import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Ingredients,
    MealTemplates,
    Meals,
    MealIngredients,
    SymptomLogs,
    SymptomEntries,
    CorrelationCache,
    Reminders,
    DietPlans,
    DietPlanMeals,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(dietPlans);
            await m.createTable(dietPlanMeals);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'ibs_takip.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
