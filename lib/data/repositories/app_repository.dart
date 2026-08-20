import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../database/tables.dart';

/// Ana repository - tüm veritabanı işlemlerini yönetir
class AppRepository {
  final AppDatabase _db;

  AppRepository(this._db);

  // ==================== INGREDIENT ====================

  /// Seed veriyi JSON'dan yükler
  Future<void> loadSeedData() async {
    final count = await _db.ingredients.count().getSingle();
    if (count > 0) return; // zaten yüklenmiş

    final jsonStr = await rootBundle.loadString('assets/ingredients_seed.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    // Malzemeleri yükle
    final ingredients = data['ingredients'] as List<dynamic>;
    for (final ing in ingredients) {
      await _db.into(_db.ingredients).insert(
            IngredientsCompanion(
              name: drift.Value(ing['name'] as String),
              nameNormalized: drift.Value(ing['name_normalized'] as String),
              fodmapLevel: drift.Value(ing['fodmap_level'] as String),
              isLactose: drift.Value(ing['is_lactose'] as bool),
              isGluten: drift.Value(ing['is_gluten'] as bool),
              isHighHistamine: drift.Value(ing['is_high_histamine'] as bool),
              isCaffeine: drift.Value(ing['is_caffeine'] as bool),
              category: drift.Value(ing['category'] as String),
              fodmapGroup: drift.Value(ing['fodmap_group'] as String),
              source: const drift.Value('builtin'),
            ),
          );
    }

    // Yemek şablonlarını yükle
    final templates = data['mealTemplates'] as List<dynamic>;
    for (final tpl in templates) {
      final ingredientNames = tpl['ingredients'] as List<dynamic>;
      // Malzeme isimlerini ID'lere çevir
      final ingredientEntries = <Map<String, dynamic>>[];
      for (final name in ingredientNames) {
        final ing = await (_db.select(_db.ingredients)
              ..where((tbl) => tbl.name.equals(name as String)))
            .getSingleOrNull();
        if (ing != null) {
          ingredientEntries.add({
            'ingredient_id': ing.id,
            'name': ing.name,
          });
        } else {
          ingredientEntries.add({
            'ingredient_id': null,
            'name': name,
          });
        }
      }

      await _db.into(_db.mealTemplates).insert(
            MealTemplatesCompanion(
              name: drift.Value(tpl['name'] as String),
              nameNormalized: drift.Value(_normalize(tpl['name'] as String)),
              ingredientsJson: drift.Value(json.encode(ingredientEntries)),
              isBuiltin: const drift.Value(true),
            ),
          );
    }
  }

  /// Malzeme arama (otomatik tamamlama için)
  Future<List<Ingredient>> searchIngredients(String query) async {
    final normalized = _normalize(query);
    return (_db.select(_db.ingredients)
          ..where((tbl) => tbl.nameNormalized.like('%$normalized%'))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)])
          ..limit(20))
        .get();
  }

  /// Tüm malzemeleri getir
  Future<List<Ingredient>> getAllIngredients() async {
    return (_db.select(_db.ingredients)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Kategoriye göre malzeme getir
  Future<List<Ingredient>> getIngredientsByCategory(String category) async {
    return (_db.select(_db.ingredients)
          ..where((tbl) => tbl.category.equals(category))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Yeni malzeme ekle (kullanıcı katkılı)
  Future<int> addIngredient({
    required String name,
    String fodmapLevel = 'unknown',
    String category = 'diger',
    bool isLactose = false,
    bool isGluten = false,
  }) async {
    final id = await _db.into(_db.ingredients).insert(
          IngredientsCompanion(
            name: drift.Value(name),
            nameNormalized: drift.Value(_normalize(name)),
            fodmapLevel: drift.Value(fodmapLevel),
            category: drift.Value(category),
            isLactose: drift.Value(isLactose),
            isGluten: drift.Value(isGluten),
            source: const drift.Value('user'),
          ),
        );
    return id;
  }

  // ==================== MEAL TEMPLATES ====================

  /// Yemek şablonu ara
  Future<MealTemplate?> searchMealTemplate(String name) async {
    final normalized = _normalize(name);
    return (_db.select(_db.mealTemplates)
          ..where((tbl) => tbl.nameNormalized.equals(normalized))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Yemek şablonlarını isimle ara (fuzzy için like)
  Future<List<MealTemplate>> searchMealTemplates(String query) async {
    final normalized = _normalize(query);
    return (_db.select(_db.mealTemplates)
          ..where((tbl) => tbl.nameNormalized.like('%$normalized%'))
          ..limit(10))
        .get();
  }

  /// Yeni yemek şablonu kaydet (kişisel sözlük büyümesi)
  Future<void> saveMealTemplate({
    required String name,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    final existing = await searchMealTemplate(name);
    if (existing != null) {
      // Güncelle
      await (_db.update(_db.mealTemplates)
            ..where((tbl) => tbl.id.equals(existing.id)))
          .write(MealTemplatesCompanion(
            ingredientsJson: drift.Value(json.encode(ingredients)),
          ));
    } else {
      await _db.into(_db.mealTemplates).insert(
            MealTemplatesCompanion(
              name: drift.Value(name),
              nameNormalized: drift.Value(_normalize(name)),
              ingredientsJson: drift.Value(json.encode(ingredients)),
              isBuiltin: const drift.Value(false),
            ),
          );
    }
  }

  // ==================== MEALS ====================

  /// Öğün ekle
  Future<int> addMeal({
    required String name,
    required String mealType,
    required DateTime eatenAt,
    String portionSize = 'orta',
    String? photoPath,
    String? notes,
    required List<int> ingredientIds,
  }) async {
    final mealId = await _db.into(_db.meals).insert(
          MealsCompanion(
            name: drift.Value(name),
            mealType: drift.Value(mealType),
            eatenAt: drift.Value(eatenAt),
            portionSize: drift.Value(portionSize),
            photoPath: drift.Value(photoPath),
            notes: drift.Value(notes),
          ),
        );

    for (final ingId in ingredientIds) {
      await _db.into(_db.mealIngredients).insert(
            MealIngredientsCompanion(
              mealId: drift.Value(mealId),
              ingredientId: drift.Value(ingId),
            ),
          );
    }

    return mealId;
  }

  /// Öğün güncelle
  Future<void> updateMeal({
    required int id,
    required String name,
    required String mealType,
    required DateTime eatenAt,
    String portionSize = 'orta',
    String? photoPath,
    String? notes,
    required List<int> ingredientIds,
  }) async {
    await (_db.update(_db.meals)..where((tbl) => tbl.id.equals(id))).write(
          MealsCompanion(
            name: drift.Value(name),
            mealType: drift.Value(mealType),
            eatenAt: drift.Value(eatenAt),
            portionSize: drift.Value(portionSize),
            photoPath: drift.Value(photoPath),
            notes: drift.Value(notes),
          ),
        );

    // Eski malzeme ilişkilerini sil, yenilerini ekle
    await (_db.delete(_db.mealIngredients)
          ..where((tbl) => tbl.mealId.equals(id)))
        .go();
    for (final ingId in ingredientIds) {
      await _db.into(_db.mealIngredients).insert(
            MealIngredientsCompanion(
              mealId: drift.Value(id),
              ingredientId: drift.Value(ingId),
            ),
          );
    }
  }

  /// Öğün sil
  Future<void> deleteMeal(int id) async {
    await (_db.delete(_db.meals)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Tüm öğünleri getir (sıralı)
  Future<List<Meal>> getAllMeals() async {
    return (_db.select(_db.meals)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.eatenAt)]))
        .get();
  }

  /// Tarih aralığında öğün getir
  Future<List<Meal>> getMealsBetween(DateTime start, DateTime end) async {
    return (_db.select(_db.meals)
          ..where((tbl) => tbl.eatenAt.isBetweenValues(start, end))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.eatenAt)]))
        .get();
  }

  /// Öğüne ait malzemeleri getir
  Future<List<Ingredient>> getMealIngredients(int mealId) async {
    final query = _db.select(_db.mealIngredients).join([
      drift.innerJoin(_db.ingredients,
          _db.ingredients.id.equalsExp(_db.mealIngredients.ingredientId))
    ])
      ..where(_db.mealIngredients.mealId.equals(mealId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(_db.ingredients)).toList();
  }

  // ==================== SYMPTOM ====================

  /// Semptom kaydı ekle
  Future<int> addSymptomLog({
    required DateTime loggedAt,
    double? overallFeeling,
    String? notes,
    required List<Map<String, dynamic>> symptoms, // [{type, severity}]
  }) async {
    final logId = await _db.into(_db.symptomLogs).insert(
          SymptomLogsCompanion(
            loggedAt: drift.Value(loggedAt),
            overallFeeling: drift.Value(overallFeeling),
            notes: drift.Value(notes),
          ),
        );

    for (final symptom in symptoms) {
      await _db.into(_db.symptomEntries).insert(
            SymptomEntriesCompanion(
              symptomLogId: drift.Value(logId),
              symptomType: drift.Value(symptom['type'] as String),
              severity: drift.Value((symptom['severity'] as num).toDouble()),
            ),
          );
    }

    return logId;
  }

  /// Semptom kaydı güncelle
  Future<void> updateSymptomLog({
    required int id,
    required DateTime loggedAt,
    double? overallFeeling,
    String? notes,
    required List<Map<String, dynamic>> symptoms,
  }) async {
    await (_db.update(_db.symptomLogs)..where((tbl) => tbl.id.equals(id)))
        .write(SymptomLogsCompanion(
          loggedAt: drift.Value(loggedAt),
          overallFeeling: drift.Value(overallFeeling),
          notes: drift.Value(notes),
        ));

    await (_db.delete(_db.symptomEntries)
          ..where((tbl) => tbl.symptomLogId.equals(id)))
        .go();
    for (final symptom in symptoms) {
      await _db.into(_db.symptomEntries).insert(
            SymptomEntriesCompanion(
              symptomLogId: drift.Value(id),
              symptomType: drift.Value(symptom['type'] as String),
              severity: drift.Value((symptom['severity'] as num).toDouble()),
            ),
          );
    }
  }

  /// Semptom kaydı sil
  Future<void> deleteSymptomLog(int id) async {
    await (_db.delete(_db.symptomLogs)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Tüm semptom kayıtlarını getir
  Future<List<SymptomLog>> getAllSymptomLogs() async {
    return (_db.select(_db.symptomLogs)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.loggedAt)]))
        .get();
  }

  /// Tarih aralığında semptom getir
  Future<List<SymptomLog>> getSymptomLogsBetween(
      DateTime start, DateTime end) async {
    return (_db.select(_db.symptomLogs)
          ..where((tbl) => tbl.loggedAt.isBetweenValues(start, end))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.loggedAt)]))
        .get();
  }

  /// Semptom kaydına ait detayları getir
  Future<List<SymptomEntry>> getSymptomEntries(int logId) async {
    return (_db.select(_db.symptomEntries)
          ..where((tbl) => tbl.symptomLogId.equals(logId)))
        .get();
  }

  // ==================== CORRELATION ====================

  /// Tüm öğün-malzeme-yenme zamanı verisini getir
  Future<List<MealIngredientEventData>> getAllMealIngredientEvents() async {
    final query = _db.select(_db.mealIngredients).join([
      drift.innerJoin(
          _db.meals, _db.meals.id.equalsExp(_db.mealIngredients.mealId))
    ]);

    final rows = await query.get();
    return rows.map((row) {
      final mi = row.readTable(_db.mealIngredients);
      final meal = row.readTable(_db.meals);
      return MealIngredientEventData(
        ingredientId: mi.ingredientId,
        eatenAt: meal.eatenAt,
      );
    }).toList();
  }

  /// Tüm semptom olaylarını getir
  Future<List<SymptomEventData>> getAllSymptomEvents() async {
    final logs = await getAllSymptomLogs();
    final events = <SymptomEventData>[];

    for (final log in logs) {
      final entries = await getSymptomEntries(log.id);
      final maxSeverity = entries.isEmpty
          ? (log.overallFeeling ?? 0)
          : entries.map((e) => e.severity).reduce(
              (a, b) => a > b ? a : b);

      events.add(SymptomEventData(
        loggedAt: log.loggedAt,
        maxSeverity: maxSeverity,
      ));
    }

    return events;
  }

  /// Korelasyon önbelleğini güncelle
  Future<void> updateCorrelationCache(
    int ingredientId,
    int timeWindowHours,
    int occurrenceCount,
    int symptomCount,
    double symptomRate,
    double suspicionScore,
  ) async {
    // Önce mevcut kaydı sil
    await (_db.delete(_db.correlationCache)
          ..where((tbl) =>
              tbl.ingredientId.equals(ingredientId) &
              tbl.timeWindowHours.equals(timeWindowHours)))
        .go();

    await _db.into(_db.correlationCache).insert(
          CorrelationCacheCompanion(
            ingredientId: drift.Value(ingredientId),
            timeWindowHours: drift.Value(timeWindowHours),
            occurrenceCount: drift.Value(occurrenceCount),
            symptomCount: drift.Value(symptomCount),
            symptomRate: drift.Value(symptomRate),
            suspicionScore: drift.Value(suspicionScore),
          ),
        );
  }

  /// Önbelleğe alınmış korelasyonları getir
  Future<List<CorrelationCacheData>> getCachedCorrelations(
      int timeWindowHours) async {
    return (_db.select(_db.correlationCache)
          ..where((tbl) => tbl.timeWindowHours.equals(timeWindowHours))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.suspicionScore)]))
        .get();
  }

  // ==================== REMINDERS ====================

  Future<List<Reminder>> getAllReminders() async {
    return _db.select(_db.reminders).get();
  }

  Future<int> addReminder({
    required int hour,
    required int minute,
    String daysOfWeek = '1,2,3,4,5,6,7',
    bool enabled = true,
    String reminderType = 'symptom',
    String message = 'Bugün nasıl hissediyorsun?',
  }) async {
    return _db.into(_db.reminders).insert(
          RemindersCompanion(
            hour: drift.Value(hour),
            minute: drift.Value(minute),
            daysOfWeek: drift.Value(daysOfWeek),
            enabled: drift.Value(enabled),
            reminderType: drift.Value(reminderType),
            message: drift.Value(message),
          ),
        );
  }

  Future<void> updateReminder({
    required int id,
    required int hour,
    required int minute,
    required String daysOfWeek,
    required bool enabled,
    required String reminderType,
    required String message,
  }) async {
    await (_db.update(_db.reminders)..where((tbl) => tbl.id.equals(id)))
        .write(RemindersCompanion(
          hour: drift.Value(hour),
          minute: drift.Value(minute),
          daysOfWeek: drift.Value(daysOfWeek),
          enabled: drift.Value(enabled),
          reminderType: drift.Value(reminderType),
          message: drift.Value(message),
        ));
  }

  Future<void> deleteReminder(int id) async {
    await (_db.delete(_db.reminders)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// İstatistik: belirli tarih aralığında ortalama iyilik hali
  Future<double> getAverageWellbeing(DateTime start, DateTime end) async {
    final query = _db.selectOnly(_db.symptomLogs)
      ..addColumns([_db.symptomLogs.overallFeeling.avg()])
      ..where(_db.symptomLogs.loggedAt.isBetweenValues(start, end));
    final row = await query.getSingle();
    return row.read(_db.symptomLogs.overallFeeling.avg()) ?? 0;
  }

  // ==================== HELPERS ====================

  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll('İ', 'i')
        .replaceAll('Ş', 's')
        .replaceAll('Ğ', 'g')
        .replaceAll('Ü', 'u')
        .replaceAll('Ö', 'o')
        .replaceAll('Ç', 'c')
        .trim();
  }
}

/// Yardımcı veri sınıfları
class MealIngredientEventData {
  final int ingredientId;
  final DateTime eatenAt;
  const MealIngredientEventData({
    required this.ingredientId,
    required this.eatenAt,
  });
}

class SymptomEventData {
  final DateTime loggedAt;
  final double maxSeverity;
  const SymptomEventData({
    required this.loggedAt,
    required this.maxSeverity,
  });
}
