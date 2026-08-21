import 'package:drift/drift.dart';

/// Malzeme kategorileri (P0.3 — kategori bazlı korelasyon gruplama)
class IngredientCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // örn. "Gluten/Buğday", "Süt Ürünü", "Yüksek FODMAP Sebze"
  IntColumn get parentCategoryId => integer().nullable().references(IngredientCategories, #id)();
}

/// Malzeme kütüphanesi tablosu
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nameNormalized => text()(); // küçük harf, Türkçe karakter normalize
  TextColumn get fodmapLevel => text().withDefault(const Constant('unknown'))(); // low, medium, high, unknown
  BoolColumn get isLactose => boolean().withDefault(const Constant(false))();
  BoolColumn get isGluten => boolean().withDefault(const Constant(false))();
  BoolColumn get isHighHistamine => boolean().withDefault(const Constant(false))();
  BoolColumn get isCaffeine => boolean().withDefault(const Constant(false))();
  TextColumn get category => text().withDefault(const Constant('diger'))(); // sebze, meyve, sut, tahil, et, bakliyat, icecek, diger
  TextColumn get fodmapGroup => text().nullable()(); // fructose, lactose, fructan, gos, polyol, none
  TextColumn get source => text().withDefault(const Constant('builtin'))(); // builtin, user, off_api
  TextColumn get offBarcode => text().nullable()(); // Open Food Facts barkod
  IntColumn get categoryId => integer().nullable().references(IngredientCategories, #id)();
}

/// Yemek şablonları (sık kullanılan yemekler ve kişisel sözlük)
class MealTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nameNormalized => text()();
  TextColumn get ingredientsJson => text()(); // JSON: [{ingredient_id, name, amount}]
  BoolColumn get isBuiltin => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Öğün kayıtları
class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // öğün adı (örn. "Mercimek çorbası + pilav")
  TextColumn get mealType => text().withDefault(const Constant('aksam'))(); // kahvalti, ogle, aksam, atistirma
  DateTimeColumn get eatenAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get portionSize => text().withDefault(const Constant('orta'))(); // kucuk, orta, buyuk
  TextColumn get photoPath => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Öğün-malzeme ilişki tablosu
class MealIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(Meals, #id, onDelete: KeyAction.cascade)();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  TextColumn get customNote => text().nullable()();
}

/// Semptom günlüğü ana kaydı
class SymptomLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get overallFeeling => real().nullable()(); // 0-10 genel iyilik hali
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Semptom detayları (bir kayıtta çoklu semptom)
class SymptomEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get symptomLogId => integer().references(SymptomLogs, #id, onDelete: KeyAction.cascade)();
  TextColumn get symptomType => text()(); // sislik, kramp, ishal, kabizlik, gaz, bulanti, reflu, yorgunluk, mukus, acil_tuvalet_ihtiyaci
  RealColumn get severity => real()(); // 0-10
}

/// Korelasyon önbelleği (performans için)
class CorrelationCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  IntColumn get timeWindowHours => integer()(); // 6, 24, 48, 72
  IntColumn get occurrenceCount => integer()(); // toplam yenme sayısı
  IntColumn get symptomCount => integer()(); // semptomla birlikte görülme
  RealColumn get symptomRate => real()(); // oran
  RealColumn get suspicionScore => real()(); // şüphe skoru
  RealColumn get baselineRate => real().withDefault(const Constant(0.0))(); // genel semptom oranı
  RealColumn get liftScore => real().withDefault(const Constant(0.0))(); // göreli risk
  RealColumn get confidence => real().withDefault(const Constant(0.0))(); // güven (0-1)
  DateTimeColumn get lastCalculatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Hatırlatıcılar
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hour => integer()(); // 0-23
  IntColumn get minute => integer()(); // 0-59
  TextColumn get daysOfWeek => text().withDefault(const Constant('1,2,3,4,5,6,7'))(); // virgülle ayrılmış
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get reminderType => text().withDefault(const Constant('symptom'))(); // symptom, meal, custom
  TextColumn get message => text().withDefault(const Constant('Bugün nasıl hissediyorsun?'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Diyet planları
class DietPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // "Düşük FODMAP Eliminasyon Diyeti"
  TextColumn get planType => text()(); // fodmap_elimination, fodmap_reintro, ibs_friendly
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Diyet planı öğünleri (hangi gün hangi öğün eklendi)
class DietPlanMeals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dietPlanId => integer().references(DietPlans, #id, onDelete: KeyAction.cascade)();
  IntColumn get mealId => integer().references(Meals, #id, onDelete: KeyAction.cascade)();
  IntColumn get dayNumber => integer()(); // Plan içindeki gün numarası
  TextColumn get mealType => text()(); // kahvalti, ogle, aksam, ara_ogun
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Kullanıcı ayarları (key-value)
class UserSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
