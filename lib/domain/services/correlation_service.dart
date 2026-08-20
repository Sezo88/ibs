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

  const IngredientCorrelation({
    required this.ingredientId,
    required this.ingredientName,
    required this.fodmapLevel,
    required this.totalEaten,
    required this.symptomCount,
    required this.suspicionScore,
    required this.timeWindowHours,
    required this.hasEnoughData,
  });

  double get symptomRate => totalEaten > 0 ? symptomCount / totalEaten : 0;
  String get suspicionLabel {
    if (!hasEnoughData) return 'Yetersiz Veri';
    if (suspicionScore >= 0.70) return 'Yüksek Şüpheli';
    if (suspicionScore >= 0.40) return 'Orta Şüpheli';
    if (suspicionScore >= 0.15) return 'Düşük Şüpheli';
    return 'Güvenli Görünüyor';
  }
}

/// Korelasyon hesaplama motoru (saf Dart, test edilebilir)
class CorrelationService {
  /// Minimum yenme sayısı eşiği (bundan az veri varsa "yetersiz veri")
  static const int minOccurrenceThreshold = 3;

  /// Semptom şiddeti eşiği (bu değerin üstündeki semptomlar sayılır)
  static const double severityThreshold = 3.0;

  /// Belirli bir zaman penceresi için malzeme bazlı korelasyon hesaplar.
  ///
  /// [ingredients]: tüm malzeme listesi (id -> isim, fodmap)
  /// [mealIngredients]: tüm zamanlardaki öğün-malzeme eşleşmeleri
  /// [symptomLogs]: tüm semptom kayıtları ve detayları
  /// [timeWindowHours]: geriye dönük analiz penceresi (6, 24, 48, 72 saat)
  static List<IngredientCorrelation> calculateCorrelations({
    required List<IngredientInfo> ingredients,
    required List<MealIngredientEvent> mealIngredients,
    required List<SymptomEvent> symptomEvents,
    required int timeWindowHours,
  }) {
    final results = <IngredientCorrelation>[];

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
        ));
        continue;
      }

      // Her yenme olayından sonra timeWindow içinde semptom var mı?
      int symptomCount = 0;
      for (final eatenAt in eatenTimes) {
        final windowEnd = eatenAt.add(Duration(hours: timeWindowHours));

        // Bu pencerede anlamlı semptom var mı?
        final hasSymptom = symptomEvents.any((se) =>
            se.loggedAt.isAfter(eatenAt) &&
            se.loggedAt.isBefore(windowEnd) &&
            se.maxSeverity >= severityThreshold);

        if (hasSymptom) {
          symptomCount++;
        }
      }

      final suspicionScore = symptomCount / totalEaten;
      final hasEnoughData = totalEaten >= minOccurrenceThreshold;

      results.add(IngredientCorrelation(
        ingredientId: ingredient.id,
        ingredientName: ingredient.name,
        fodmapLevel: ingredient.fodmapLevel,
        totalEaten: totalEaten,
        symptomCount: symptomCount,
        suspicionScore: suspicionScore,
        timeWindowHours: timeWindowHours,
        hasEnoughData: hasEnoughData,
      ));
    }

    // Şüphe skoruna göre sırala (en yüksek önce)
    results.sort((a, b) => b.suspicionScore.compareTo(a.suspicionScore));

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

  const IngredientInfo({
    required this.id,
    required this.name,
    required this.fodmapLevel,
    required this.category,
    required this.isLactose,
    required this.isGluten,
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

  const SymptomEvent({
    required this.loggedAt,
    required this.maxSeverity,
  });
}
