import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database.dart';
import '../../data/repositories/app_repository.dart';
import '../../domain/services/correlation_service.dart';
import '../../domain/services/export_service.dart';

/// Veritabanı singleton provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Repository provider
final repositoryProvider = Provider<AppRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AppRepository(db);
});

/// Seed data yüklendi mi?
final seedDataLoadedProvider = StateProvider<bool>((ref) => false);

/// Tüm malzemeler
final allIngredientsProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.getAllIngredients();
});

/// Öğün listesi
final allMealsProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.getAllMeals();
});

/// Semptom kayıtları
final allSymptomLogsProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.getAllSymptomLogs();
});

/// Hatırlatıcılar
final remindersProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.getAllReminders();
});

/// Seçili zaman penceresi (korelasyon analizi için)
final selectedTimeWindowProvider = StateProvider<int>((ref) => 24);

/// Korelasyon sonuçları
final correlationResultsProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  final timeWindow = ref.watch(selectedTimeWindowProvider);

  final ingredients = await repo.getAllIngredients();
  final mealEvents = await repo.getAllMealIngredientEvents();
  final symptomEvents = await repo.getAllSymptomEvents();

  final ingredientInfos = ingredients
      .map((i) => IngredientInfo(
            id: i.id,
            name: i.name,
            fodmapLevel: i.fodmapLevel,
            category: i.category,
            isLactose: i.isLactose,
            isGluten: i.isGluten,
          ))
      .toList();

  final mealIngredientEvents = mealEvents
      .map((e) => MealIngredientEvent(
            ingredientId: e.ingredientId,
            eatenAt: e.eatenAt,
          ))
      .toList();

  final symptomEventList = symptomEvents
      .map((e) => SymptomEvent(
            loggedAt: e.loggedAt,
            maxSeverity: e.maxSeverity,
          ))
      .toList();

  final results = CorrelationService.calculateCorrelations(
    ingredients: ingredientInfos,
    mealIngredients: mealIngredientEvents,
    symptomEvents: symptomEventList,
    timeWindowHours: timeWindow,
  );

  // Önbelleğe kaydet
  for (final r in results) {
    if (r.totalEaten > 0) {
      await repo.updateCorrelationCache(
        r.ingredientId,
        timeWindow,
        r.totalEaten,
        r.symptomCount,
        r.symptomRate,
        r.suspicionScore,
      );
    }
  }

  return results;
});

/// Bugünün öğünleri
final todayMealsProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return repo.getMealsBetween(start, end);
});

/// Bugünün semptomları
final todaySymptomsProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return repo.getSymptomLogsBetween(start, end);
});

/// Haftalık ortalama iyilik hali
final weeklyWellbeingProvider = FutureProvider((ref) async {
  final repo = ref.watch(repositoryProvider);
  final now = DateTime.now();
  final start = now.subtract(const Duration(days: 7));
  return repo.getAverageWellbeing(start, now);
});
