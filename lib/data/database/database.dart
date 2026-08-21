import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    IngredientCategories,
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
    UserSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
          if (from < 3) {
            // P0.3: Kategori tablosu
            await m.createTable(ingredientCategories);
            // P0.3: Ingredients'a categoryId alanı
            await m.addColumn(ingredients, ingredients.categoryId);
            // P1.1: UserSettings tablosu
            await m.createTable(userSettings);
            // P0.4/P0.5: CorrelationCache'e yeni alanlar
            await m.addColumn(correlationCache, correlationCache.baselineRate);
            await m.addColumn(correlationCache, correlationCache.liftScore);
            await m.addColumn(correlationCache, correlationCache.confidence);
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
