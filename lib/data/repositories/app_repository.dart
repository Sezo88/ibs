import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../database/tables.dart';

/// Ana repository - tüm veritabanı işlemlerini yönetir
class AppRepository {
  final AppDatabase _db;

  AppRepository(this._db);

  // ==================== INGREDIENT ====================

  /// Seed veriyi JSON'dan yükler ve eksik şablonları senkronize eder
  Future<void> loadSeedData() async {
    final jsonStr = await rootBundle.loadString('assets/ingredients_seed.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    // Kategori seed verisi yükle (P0.3)
    if (data.containsKey('ingredient_categories')) {
      final catCount = await _db.ingredientCategories.count().getSingle();
      if (catCount == 0) {
        final categories = data['ingredient_categories'] as List<dynamic>;
        for (final cat in categories) {
          await _db.into(_db.ingredientCategories).insert(
                IngredientCategoriesCompanion(
                  id: drift.Value(cat['id'] as int),
                  name: drift.Value(cat['name'] as String),
                  parentCategoryId: drift.Value(cat['parent_category_id'] as int?),
                ),
              );
        }
      }
    }

    final count = await _db.ingredients.count().getSingle();
    if (count == 0) {
      // Malzemeleri ilk kez yükle
      final ingredients = data['ingredients'] as List<dynamic>;
      for (final ing in ingredients) {
        int? catId = ing['category_id'] as int?;
        catId ??= _inferCategoryId(
          isGluten: ing['is_gluten'] as bool? ?? false,
          isLactose: ing['is_lactose'] as bool? ?? false,
          fodmapLevel: ing['fodmap_level'] as String? ?? 'unknown',
          category: ing['category'] as String? ?? 'diger',
          isCaffeine: ing['is_caffeine'] as bool? ?? false,
          isHighHistamine: ing['is_high_histamine'] as bool? ?? false,
        );

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
                categoryId: drift.Value(catId),
              ),
            );
      }
    } else {
      // Mevcut veride categoryId null olanları backfill et
      final uncategorized = await (_db.select(_db.ingredients)
            ..where((tbl) => tbl.categoryId.isNull()))
          .get();
      for (final ing in uncategorized) {
        final catId = _inferCategoryId(
          isGluten: ing.isGluten,
          isLactose: ing.isLactose,
          fodmapLevel: ing.fodmapLevel,
          category: ing.category,
          isCaffeine: ing.isCaffeine,
          isHighHistamine: ing.isHighHistamine,
        );
        if (catId != null) {
          await (_db.update(_db.ingredients)..where((t) => t.id.equals(ing.id)))
              .write(IngredientsCompanion(categoryId: drift.Value(catId)));
        }
      }
    }

    // Yemek şablonlarını senkronize et (yeni eklenen şablonlar da yüklensin)
    final templates = data['mealTemplates'] as List<dynamic>;
    for (final tpl in templates) {
      final tplName = tpl['name'] as String;
      final existing = await searchMealTemplate(tplName);
      if (existing == null) {
        final ingredientNames = tpl['ingredients'] as List<dynamic>;
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
                name: drift.Value(tplName),
                nameNormalized: drift.Value(_normalize(tplName)),
                ingredientsJson: drift.Value(json.encode(ingredientEntries)),
                isBuiltin: const drift.Value(true),
              ),
            );
      }
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

  /// P1.3: Fuzzy arama — Levenshtein mesafesi ile yazım hatası toleransı
  Future<List<Ingredient>> searchIngredientsFuzzy(String query) async {
    // Önce normal arama
    final exactResults = await searchIngredients(query);
    if (exactResults.isNotEmpty) return exactResults;

    // Normal arama boşsa, tüm malzemeleri çekip fuzzy eşleştirme yap
    final allIngredients = await getAllIngredients();
    final normalizedQuery = _normalize(query);

    final fuzzyResults = <Ingredient>[];
    for (final ing in allIngredients) {
      final distance = _levenshteinDistance(normalizedQuery, ing.nameNormalized);
      if (distance <= 2) {
        fuzzyResults.add(ing);
      }
    }

    // Mesafeye göre sırala
    fuzzyResults.sort((a, b) {
      final da = _levenshteinDistance(normalizedQuery, a.nameNormalized);
      final db = _levenshteinDistance(normalizedQuery, b.nameNormalized);
      return da.compareTo(db);
    });

    return fuzzyResults.take(10).toList();
  }

  /// Levenshtein mesafesi hesaplama
  int _levenshteinDistance(String s, String t) {
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    // Kısa string'in alt-string eşleşmesini kontrol et
    if (t.contains(s) || s.contains(t)) return 0;

    final sLen = s.length;
    final tLen = t.length;

    // Çok farklı uzunluktaysa hızlı ret
    if ((sLen - tLen).abs() > 3) return 99;

    var prev = List<int>.generate(tLen + 1, (i) => i);
    var curr = List<int>.filled(tLen + 1, 0);

    for (var i = 1; i <= sLen; i++) {
      curr[0] = i;
      for (var j = 1; j <= tLen; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        curr[j] = [
          prev[j] + 1,     // silme
          curr[j - 1] + 1, // ekleme
          prev[j - 1] + cost, // değiştirme
        ].reduce(min);
      }
      final temp = prev;
      prev = curr;
      curr = temp;
    }

    return prev[tLen];
  }

  /// Tüm malzemeleri getir
  Future<List<Ingredient>> getAllIngredients() async {
    return (_db.select(_db.ingredients)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
        .get();
  }

  /// P0.2: Kullanıcının eklediği malzemeleri getir
  Future<List<Ingredient>> getUserIngredients() async {
    return (_db.select(_db.ingredients)
          ..where((tbl) => tbl.source.equals('user'))
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

  /// P0.2: Malzeme güncelle
  Future<void> updateIngredient({
    required int id,
    String? name,
    String? fodmapLevel,
    String? category,
    bool? isLactose,
    bool? isGluten,
    int? categoryId,
  }) async {
    final companion = IngredientsCompanion(
      name: name != null ? drift.Value(name) : const drift.Value.absent(),
      nameNormalized: name != null ? drift.Value(_normalize(name)) : const drift.Value.absent(),
      fodmapLevel: fodmapLevel != null ? drift.Value(fodmapLevel) : const drift.Value.absent(),
      category: category != null ? drift.Value(category) : const drift.Value.absent(),
      isLactose: isLactose != null ? drift.Value(isLactose) : const drift.Value.absent(),
      isGluten: isGluten != null ? drift.Value(isGluten) : const drift.Value.absent(),
      categoryId: categoryId != null ? drift.Value(categoryId) : const drift.Value.absent(),
    );

    await (_db.update(_db.ingredients)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
  }

  // ==================== INGREDIENT CATEGORIES (P0.3) ====================

  /// Tüm kategorileri getir
  Future<List<IngredientCategory>> getAllCategories() async {
    return (_db.select(_db.ingredientCategories)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Kategori adı ile getir
  Future<IngredientCategory?> getCategoryByName(String name) async {
    return (_db.select(_db.ingredientCategories)
          ..where((tbl) => tbl.name.equals(name))
          ..limit(1))
        .getSingleOrNull();
  }

  // ==================== USER SETTINGS (P1.1) ====================

  /// Kullanıcı ayarını getir
  Future<String?> getUserSetting(String key) async {
    final result = await (_db.select(_db.userSettings)
          ..where((tbl) => tbl.key.equals(key)))
        .getSingleOrNull();
    return result?.value;
  }

  /// Kullanıcı ayarını kaydet/güncelle
  Future<void> setUserSetting(String key, String value) async {
    await _db.into(_db.userSettings).insertOnConflictUpdate(
          UserSettingsCompanion(
            key: drift.Value(key),
            value: drift.Value(value),
          ),
        );
  }

  /// Varsayılan öğün saatlerini getir
  Future<Map<String, String>> getDefaultMealTimes() async {
    final defaults = {
      'kahvalti': '08:00',
      'ogle': '13:00',
      'aksam': '19:00',
      'atistirma': '',
      'ara_ogun': '',
    };

    for (final type in defaults.keys) {
      final saved = await getUserSetting('default_meal_time_$type');
      if (saved != null) {
        defaults[type] = saved;
      }
    }

    return defaults;
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

  /// Tüm yemek şablonlarını getir
  Future<List<MealTemplate>> getAllMealTemplates() async {
    return (_db.select(_db.mealTemplates)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Yemek şablonundaki malzemeleri çözümle ve Ingredient nesneleri olarak döndür
  Future<List<Ingredient>> getTemplateIngredients(MealTemplate template) async {
    final List<dynamic> ingredientEntries =
        json.decode(template.ingredientsJson) as List<dynamic>;
    final ingredients = <Ingredient>[];

    for (final entry in ingredientEntries) {
      final map = entry as Map<String, dynamic>;
      final ingredientId = map['ingredient_id'];
      if (ingredientId != null) {
        final ing = await (_db.select(_db.ingredients)
              ..where((tbl) => tbl.id.equals(ingredientId as int)))
            .getSingleOrNull();
        if (ing != null) {
          ingredients.add(ing);
          continue;
        }
      }
      // ID yoksa veya bulunamadıysa isimle ara
      final name = map['name'] as String?;
      if (name != null) {
        final ing = await (_db.select(_db.ingredients)
              ..where((tbl) => tbl.name.equals(name))
              ..limit(1))
            .getSingleOrNull();
        if (ing != null) {
          ingredients.add(ing);
        }
      }
    }

    return ingredients;
  }

  /// ID ile malzeme getir
  Future<Ingredient?> getIngredientById(int id) async {
    return (_db.select(_db.ingredients)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
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

  /// Tüm semptom olaylarını getir (P2.2: semptom tipleri dahil)
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
        symptomTypes: entries.map((e) => e.symptomType).toList(),
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
    double suspicionScore, {
    double baselineRate = 0,
    double liftScore = 0,
    double confidence = 0,
  }) async {
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
            baselineRate: drift.Value(baselineRate),
            liftScore: drift.Value(liftScore),
            confidence: drift.Value(confidence),
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

  // ==================== BACKUP / RESTORE (P1.4) ====================

  /// Tüm veritabanını JSON'a dök
  Future<Map<String, dynamic>> exportAllDataToJson() async {
    final meals = await getAllMeals();
    final symptomLogs = await getAllSymptomLogs();
    final ingredients = await getUserIngredients(); // sadece kullanıcı malzemeleri
    final templates = await getAllMealTemplates();
    final reminders = await getAllReminders();
    final categories = await getAllCategories();

    final mealsJson = <Map<String, dynamic>>[];
    for (final meal in meals) {
      final mealIngs = await getMealIngredients(meal.id);
      mealsJson.add({
        'name': meal.name,
        'mealType': meal.mealType,
        'eatenAt': meal.eatenAt.toIso8601String(),
        'portionSize': meal.portionSize,
        'notes': meal.notes,
        'ingredients': mealIngs.map((i) => {'id': i.id, 'name': i.name}).toList(),
      });
    }

    final symptomLogsJson = <Map<String, dynamic>>[];
    for (final log in symptomLogs) {
      final entries = await getSymptomEntries(log.id);
      symptomLogsJson.add({
        'loggedAt': log.loggedAt.toIso8601String(),
        'overallFeeling': log.overallFeeling,
        'notes': log.notes,
        'entries': entries
            .map((e) => {'type': e.symptomType, 'severity': e.severity})
            .toList(),
      });
    }

    return {
      'version': 3,
      'exportedAt': DateTime.now().toIso8601String(),
      'meals': mealsJson,
      'symptomLogs': symptomLogsJson,
      'userIngredients': ingredients
          .map((i) => {
                'name': i.name,
                'fodmapLevel': i.fodmapLevel,
                'isLactose': i.isLactose,
                'isGluten': i.isGluten,
                'category': i.category,
              })
          .toList(),
      'templates': templates
          .where((t) => !t.isBuiltin)
          .map((t) => {
                'name': t.name,
                'ingredientsJson': t.ingredientsJson,
              })
          .toList(),
      'reminders': reminders
          .map((r) => {
                'hour': r.hour,
                'minute': r.minute,
                'daysOfWeek': r.daysOfWeek,
                'enabled': r.enabled,
                'reminderType': r.reminderType,
                'message': r.message,
              })
          .toList(),
    };
  }

  /// JSON'dan veritabanına yaz
  Future<void> importDataFromJson(Map<String, dynamic> data,
      {bool overwrite = false}) async {
    if (overwrite) {
      // Mevcut veriyi temizle
      await _db.delete(_db.mealIngredients).go();
      await _db.delete(_db.meals).go();
      await _db.delete(_db.symptomEntries).go();
      await _db.delete(_db.symptomLogs).go();
      await _db.delete(_db.reminders).go();
    }

    // Öğünleri içe aktar
    final mealsData = data['meals'] as List<dynamic>? ?? [];
    for (final mealData in mealsData) {
      final m = mealData as Map<String, dynamic>;
      final ingredientNames = (m['ingredients'] as List<dynamic>?)
              ?.map((i) => (i as Map<String, dynamic>)['name'] as String)
              .toList() ??
          [];

      final ingredientIds = <int>[];
      for (final name in ingredientNames) {
        final ing = await (_db.select(_db.ingredients)
              ..where((tbl) => tbl.name.equals(name))
              ..limit(1))
            .getSingleOrNull();
        if (ing != null) ingredientIds.add(ing.id);
      }

      await addMeal(
        name: m['name'] as String,
        mealType: m['mealType'] as String? ?? 'aksam',
        eatenAt: DateTime.parse(m['eatenAt'] as String),
        portionSize: m['portionSize'] as String? ?? 'orta',
        notes: m['notes'] as String?,
        ingredientIds: ingredientIds,
      );
    }

    // Semptom kayıtlarını içe aktar
    final symptomsData = data['symptomLogs'] as List<dynamic>? ?? [];
    for (final symData in symptomsData) {
      final s = symData as Map<String, dynamic>;
      await addSymptomLog(
        loggedAt: DateTime.parse(s['loggedAt'] as String),
        overallFeeling: (s['overallFeeling'] as num?)?.toDouble(),
        notes: s['notes'] as String?,
        symptoms: (s['entries'] as List<dynamic>? ?? [])
            .map((e) => e as Map<String, dynamic>)
            .toList(),
      );
    }

    // Kullanıcı malzemelerini içe aktar
    final userIngs = data['userIngredients'] as List<dynamic>? ?? [];
    for (final ingData in userIngs) {
      final i = ingData as Map<String, dynamic>;
      final existing = await (_db.select(_db.ingredients)
            ..where((tbl) => tbl.name.equals(i['name'] as String))
            ..limit(1))
          .getSingleOrNull();
      if (existing == null) {
        await addIngredient(
          name: i['name'] as String,
          fodmapLevel: i['fodmapLevel'] as String? ?? 'unknown',
          isLactose: i['isLactose'] as bool? ?? false,
          isGluten: i['isGluten'] as bool? ?? false,
          category: i['category'] as String? ?? 'diger',
        );
      }
    }

    // Hatırlatıcıları içe aktar
    if (overwrite) {
      final remindersData = data['reminders'] as List<dynamic>? ?? [];
      for (final rData in remindersData) {
        final r = rData as Map<String, dynamic>;
        await addReminder(
          hour: r['hour'] as int,
          minute: r['minute'] as int,
          daysOfWeek: r['daysOfWeek'] as String? ?? '1,2,3,4,5,6,7',
          enabled: r['enabled'] as bool? ?? true,
          reminderType: r['reminderType'] as String? ?? 'symptom',
          message: r['message'] as String? ?? 'Hatırlatma',
        );
      }
    }
  }

  // ==================== HELPERS ====================

  int? _inferCategoryId({
    required bool isGluten,
    required bool isLactose,
    required String fodmapLevel,
    required String category,
    required bool isCaffeine,
    required bool isHighHistamine,
  }) {
    if (isGluten) return 1;
    if (isLactose) return 2;
    if (fodmapLevel == 'high' && category == 'sebze') return 3;
    if (fodmapLevel == 'high' && category == 'meyve') return 4;
    if (category == 'bakliyat') return 5;
    if (isCaffeine) return 6;
    if (isHighHistamine) return 7;
    if (fodmapLevel == 'low' && category == 'sebze') return 8;
    if (fodmapLevel == 'low' && category == 'meyve') return 9;
    return null;
  }

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
  final List<String> symptomTypes; // P2.2: semptom tipleri

  const SymptomEventData({
    required this.loggedAt,
    required this.maxSeverity,
    this.symptomTypes = const [],
  });
}
