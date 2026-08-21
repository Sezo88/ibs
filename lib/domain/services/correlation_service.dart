import 'dart:math';
import '../../data/database/database.dart';

/// Korelasyon analizi için kullanılan veri modeli
class IngredientCorrelation {
  final int ingredientId;
  final String ingredientName;
  final String fodmapLevel;
  final int totalEaten;
  final int symptomCount;
  final double suspicionScore;
  final int timeWindowHours;
  final bool hasEnoughData;
  // P0.4: Baseline rate ve Lift
  final double baselineRate;
  final double liftScore;
  // P0.5: Güven göstergesi
  final double confidence;
  final double compositeScore;

  const IngredientCorrelation({
    required this.ingredientId,
    required this.ingredientName,
    required this.fodmapLevel,
    required this.totalEaten,
    required this.symptomCount,
    required this.suspicionScore,
    required this.timeWindowHours,
    required this.hasEnoughData,
    this.baselineRate = 0,
    this.liftScore = 1.0,
    this.confidence = 0,
    this.compositeScore = 0,
  });

  double get symptomRate => totalEaten > 0 ? symptomCount / totalEaten : 0;

  String get suspicionLabel {
    if (!hasEnoughData) return 'Yetersiz Veri';
    if (compositeScore >= 0.70) return 'Yüksek Şüpheli';
    if (compositeScore >= 0.40) return 'Orta Şüpheli';
    if (compositeScore >= 0.15) return 'Düşük Şüpheli';
    return 'Güvenli Görünüyor';
  }

  String get liftLabel {
    if (!hasEnoughData || baselineRate == 0) return '';
    if (liftScore >= 2.0) return '${liftScore.toStringAsFixed(1)}x daha riskli';
    if (liftScore >= 1.5) return '${liftScore.toStringAsFixed(1)}x daha riskli';
    if (liftScore >= 1.1) return 'Hafif riskli';
    return 'Muhtemelen tesadüf';
  }

  String get confidenceLabel {
    if (confidence >= 0.8) return 'Yüksek';
    if (confidence >= 0.5) return 'Orta';
    if (confidence >= 0.3) return 'Düşük';
    return 'Çok Düşük';
  }
}

/// P0.3: Kategori bazlı korelasyon veri modeli
class CategoryCorrelation {
  final int categoryId;
  final String categoryName;
  final int totalEaten;
  final int symptomCount;
  final double suspicionScore;
  final int timeWindowHours;
  final bool hasEnoughData;
  final double baselineRate;
  final double liftScore;
  final double confidence;
  final double compositeScore;
  final List<String> ingredientNames; // Bu kategorideki malzeme isimleri

  const CategoryCorrelation({
    required this.categoryId,
    required this.categoryName,
    required this.totalEaten,
    required this.symptomCount,
    required this.suspicionScore,
    required this.timeWindowHours,
    required this.hasEnoughData,
    this.baselineRate = 0,
    this.liftScore = 1.0,
    this.confidence = 0,
    this.compositeScore = 0,
    this.ingredientNames = const [],
  });

  double get symptomRate => totalEaten > 0 ? symptomCount / totalEaten : 0;

  String get suspicionLabel {
    if (!hasEnoughData) return 'Yetersiz Veri';
    if (compositeScore >= 0.70) return 'Yüksek Şüpheli';
    if (compositeScore >= 0.40) return 'Orta Şüpheli';
    if (compositeScore >= 0.15) return 'Düşük Şüpheli';
    return 'Güvenli Görünüyor';
  }
}

/// Birleşik sonuç wrapper
class CorrelationResult {
  final List<IngredientCorrelation> ingredientCorrelations;
  final List<CategoryCorrelation> categoryCorrelations;
  final double baselineRate;

  const CorrelationResult({
    required this.ingredientCorrelations,
    required this.categoryCorrelations,
    required this.baselineRate,
  });
}

/// Korelasyon hesaplama motoru (saf Dart, test edilebilir)
class CorrelationService {
  /// Minimum yenme sayısı eşiği (bundan az veri varsa "yetersiz veri")
  static const int minOccurrenceThreshold = 3;

  /// Semptom şiddeti eşiği (bu değerin üstündeki semptomlar sayılır)
  static const double severityThreshold = 3.0;

  /// İki seviyeli korelasyon hesapla: tekil malzeme + kategori bazlı
  static CorrelationResult calculateAllCorrelations({
    required List<IngredientInfo> ingredients,
    required List<MealIngredientEvent> mealIngredients,
    required List<SymptomEvent> symptomEvents,
    required int timeWindowHours,
    Set<String>? symptomTypeFilter, // P2.2: semptom tipi filtresi
    bool useRecencyWeighting = false, // P2.3: zaman ağırlıklandırma
  }) {
    // P0.4: Baseline rate hesapla
    final baselineRate = _calculateBaselineRate(
      mealIngredients,
      symptomEvents,
      timeWindowHours,
    );

    // Seviye 1: Tekil malzeme bazlı
    final ingredientResults = calculateCorrelations(
      ingredients: ingredients,
      mealIngredients: mealIngredients,
      symptomEvents: symptomEvents,
      timeWindowHours: timeWindowHours,
      baselineRate: baselineRate,
      symptomTypeFilter: symptomTypeFilter,
      useRecencyWeighting: useRecencyWeighting,
    );

    // Seviye 2: Kategori bazlı (P0.3)
    final categoryResults = _calculateCategoryCorrelations(
      ingredients: ingredients,
      mealIngredients: mealIngredients,
      symptomEvents: symptomEvents,
      timeWindowHours: timeWindowHours,
      baselineRate: baselineRate,
      symptomTypeFilter: symptomTypeFilter,
      useRecencyWeighting: useRecencyWeighting,
    );

    return CorrelationResult(
      ingredientCorrelations: ingredientResults,
      categoryCorrelations: categoryResults,
      baselineRate: baselineRate,
    );
  }

  /// P0.4: Genel semptom oranını hesapla (baseline)
  static double _calculateBaselineRate(
    List<MealIngredientEvent> mealIngredients,
    List<SymptomEvent> symptomEvents,
    int timeWindowHours,
  ) {
    if (mealIngredients.isEmpty) return 0;

    // Benzersiz yenme zamanlarını al (farklı öğünleri temsil eder)
    final uniqueEatenTimes = mealIngredients
        .map((mi) => mi.eatenAt)
        .toSet()
        .toList();

    if (uniqueEatenTimes.isEmpty) return 0;

    int windowsWithSymptom = 0;
    for (final eatenAt in uniqueEatenTimes) {
      final windowEnd = eatenAt.add(Duration(hours: timeWindowHours));
      final hasSymptom = symptomEvents.any((se) =>
          se.loggedAt.isAfter(eatenAt) &&
          se.loggedAt.isBefore(windowEnd) &&
          se.maxSeverity >= severityThreshold);
      if (hasSymptom) windowsWithSymptom++;
    }

    return windowsWithSymptom / uniqueEatenTimes.length;
  }

  /// Malzeme bazlı korelasyon hesapla
  static List<IngredientCorrelation> calculateCorrelations({
    required List<IngredientInfo> ingredients,
    required List<MealIngredientEvent> mealIngredients,
    required List<SymptomEvent> symptomEvents,
    required int timeWindowHours,
    double baselineRate = 0,
    Set<String>? symptomTypeFilter,
    bool useRecencyWeighting = false,
  }) {
    final results = <IngredientCorrelation>[];
    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));

    // P2.2: Semptom tipi filtresi uygulanmış event listesi
    final filteredSymptomEvents = symptomTypeFilter != null && symptomTypeFilter.isNotEmpty
        ? symptomEvents.where((se) {
            if (se.symptomTypes == null) return true; // eski veri uyumluluğu
            return se.symptomTypes!.any((t) => symptomTypeFilter.contains(t));
          }).toList()
        : symptomEvents;

    for (final ingredient in ingredients) {
      // Bu malzemenin tüm yenilme zamanları
      final eatenTimes = mealIngredients
          .where((mi) => mi.ingredientId == ingredient.id)
          .map((mi) => mi.eatenAt)
          .toList();

      final totalEaten = eatenTimes.length;

      if (totalEaten == 0) {
        results.add(IngredientCorrelation(
          ingredientId: ingredient.id,
          ingredientName: ingredient.name,
          fodmapLevel: ingredient.fodmapLevel,
          totalEaten: 0,
          symptomCount: 0,
          suspicionScore: 0,
          timeWindowHours: timeWindowHours,
          hasEnoughData: false,
          baselineRate: baselineRate,
        ));
        continue;
      }

      // Her yenme olayından sonra timeWindow içinde semptom var mı?
      double weightedSymptomCount = 0;
      double totalWeight = 0;
      int rawSymptomCount = 0;

      for (final eatenAt in eatenTimes) {
        final windowEnd = eatenAt.add(Duration(hours: timeWindowHours));

        final hasSymptom = filteredSymptomEvents.any((se) =>
            se.loggedAt.isAfter(eatenAt) &&
            se.loggedAt.isBefore(windowEnd) &&
            se.maxSeverity >= severityThreshold);

        // P2.3: Recency ağırlıklandırma
        double weight = 1.0;
        if (useRecencyWeighting && eatenAt.isAfter(threeMonthsAgo)) {
          weight = 2.0;
        }

        totalWeight += weight;
        if (hasSymptom) {
          weightedSymptomCount += weight;
          rawSymptomCount++;
        }
      }

      final suspicionScore = useRecencyWeighting && totalWeight > 0
          ? weightedSymptomCount / totalWeight
          : (totalEaten > 0 ? rawSymptomCount / totalEaten : 0.0);

      final hasEnoughData = totalEaten >= minOccurrenceThreshold;

      // P0.4: Lift hesabı
      final liftScore = baselineRate > 0 ? suspicionScore / baselineRate : 1.0;

      // P0.5: Güven hesabı
      final confidence = min(1.0, totalEaten / 10.0);

      // Birleşik skor: ağırlıklı
      final liftFactor = liftScore > 1.0 ? min(liftScore, 3.0) / 3.0 : 0.0;
      final compositeScore = hasEnoughData
          ? (suspicionScore * 0.5 + liftFactor * 0.3 + confidence * 0.2)
          : suspicionScore;

      results.add(IngredientCorrelation(
        ingredientId: ingredient.id,
        ingredientName: ingredient.name,
        fodmapLevel: ingredient.fodmapLevel,
        totalEaten: totalEaten,
        symptomCount: rawSymptomCount,
        suspicionScore: suspicionScore,
        timeWindowHours: timeWindowHours,
        hasEnoughData: hasEnoughData,
        baselineRate: baselineRate,
        liftScore: liftScore,
        confidence: confidence,
        compositeScore: compositeScore,
      ));
    }

    // Composite skora göre sırala
    results.sort((a, b) => b.compositeScore.compareTo(a.compositeScore));

    return results;
  }

  /// P0.3: Kategori bazlı korelasyon hesapla
  static List<CategoryCorrelation> _calculateCategoryCorrelations({
    required List<IngredientInfo> ingredients,
    required List<MealIngredientEvent> mealIngredients,
    required List<SymptomEvent> symptomEvents,
    required int timeWindowHours,
    double baselineRate = 0,
    Set<String>? symptomTypeFilter,
    bool useRecencyWeighting = false,
  }) {
    // Kategorilere göre malzemeleri grupla
    final categoryGroups = <int, List<IngredientInfo>>{};
    final categoryNames = <int, String>{};

    for (final ing in ingredients) {
      if (ing.categoryId != null) {
        categoryGroups.putIfAbsent(ing.categoryId!, () => []).add(ing);
        if (ing.categoryName != null) {
          categoryNames[ing.categoryId!] = ing.categoryName!;
        }
      }
    }

    final results = <CategoryCorrelation>[];
    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(const Duration(days: 90));

    final filteredSymptomEvents = symptomTypeFilter != null && symptomTypeFilter.isNotEmpty
        ? symptomEvents.where((se) {
            if (se.symptomTypes == null) return true;
            return se.symptomTypes!.any((t) => symptomTypeFilter.contains(t));
          }).toList()
        : symptomEvents;

    for (final entry in categoryGroups.entries) {
      final categoryId = entry.key;
      final categoryIngredients = entry.value;
      final categoryIngredientIds = categoryIngredients.map((i) => i.id).toSet();

      // Bu kategorideki tüm malzemelerin yenilme zamanlarını birleştir
      final eatenTimes = mealIngredients
          .where((mi) => categoryIngredientIds.contains(mi.ingredientId))
          .map((mi) => mi.eatenAt)
          .toList();

      final totalEaten = eatenTimes.length;

      if (totalEaten == 0) continue;

      double weightedSymptomCount = 0;
      double totalWeight = 0;
      int rawSymptomCount = 0;

      for (final eatenAt in eatenTimes) {
        final windowEnd = eatenAt.add(Duration(hours: timeWindowHours));
        final hasSymptom = filteredSymptomEvents.any((se) =>
            se.loggedAt.isAfter(eatenAt) &&
            se.loggedAt.isBefore(windowEnd) &&
            se.maxSeverity >= severityThreshold);

        double weight = 1.0;
        if (useRecencyWeighting && eatenAt.isAfter(threeMonthsAgo)) {
          weight = 2.0;
        }

        totalWeight += weight;
        if (hasSymptom) {
          weightedSymptomCount += weight;
          rawSymptomCount++;
        }
      }

      final suspicionScore = useRecencyWeighting && totalWeight > 0
          ? weightedSymptomCount / totalWeight
          : (totalEaten > 0 ? rawSymptomCount / totalEaten : 0.0);

      final hasEnoughData = totalEaten >= minOccurrenceThreshold;
      final liftScore = baselineRate > 0 ? suspicionScore / baselineRate : 1.0;
      final confidence = min(1.0, totalEaten / 10.0);
      final liftFactor = liftScore > 1.0 ? min(liftScore, 3.0) / 3.0 : 0.0;
      final compositeScore = hasEnoughData
          ? (suspicionScore * 0.5 + liftFactor * 0.3 + confidence * 0.2)
          : suspicionScore;

      results.add(CategoryCorrelation(
        categoryId: categoryId,
        categoryName: categoryNames[categoryId] ?? 'Kategori #$categoryId',
        totalEaten: totalEaten,
        symptomCount: rawSymptomCount,
        suspicionScore: suspicionScore,
        timeWindowHours: timeWindowHours,
        hasEnoughData: hasEnoughData,
        baselineRate: baselineRate,
        liftScore: liftScore,
        confidence: confidence,
        compositeScore: compositeScore,
        ingredientNames: categoryIngredients.map((i) => i.name).toList(),
      ));
    }

    results.sort((a, b) => b.compositeScore.compareTo(a.compositeScore));
    return results;
  }
}

/// Korelasyon hesaplama için yardımcı veri sınıfları
class IngredientInfo {
  final int id;
  final String name;
  final String fodmapLevel;
  final String category;
  final bool isLactose;
  final bool isGluten;
  final int? categoryId; // P0.3
  final String? categoryName; // P0.3

  const IngredientInfo({
    required this.id,
    required this.name,
    required this.fodmapLevel,
    required this.category,
    required this.isLactose,
    required this.isGluten,
    this.categoryId,
    this.categoryName,
  });
}

class MealIngredientEvent {
  final int ingredientId;
  final DateTime eatenAt;

  const MealIngredientEvent({
    required this.ingredientId,
    required this.eatenAt,
  });
}

class SymptomEvent {
  final DateTime loggedAt;
  final double maxSeverity;
  final List<String>? symptomTypes; // P2.2: filtreleme için

  const SymptomEvent({
    required this.loggedAt,
    required this.maxSeverity,
    this.symptomTypes,
  });
}
