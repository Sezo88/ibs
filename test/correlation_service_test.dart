import 'package:flutter_test/flutter_test.dart';
import 'package:ibs_semptom_takip/domain/services/correlation_service.dart';

void main() {
  group('CorrelationService Tests', () {
    final now = DateTime.now();

    final testIngredients = [
      const IngredientInfo(
        id: 1,
        name: 'Soğan',
        fodmapLevel: 'high',
        category: 'sebze',
        isLactose: false,
        isGluten: false,
        categoryId: 3,
        categoryName: 'Yüksek FODMAP Sebzeler',
      ),
      const IngredientInfo(
        id: 2,
        name: 'Sarımsak',
        fodmapLevel: 'high',
        category: 'sebze',
        isLactose: false,
        isGluten: false,
        categoryId: 3,
        categoryName: 'Yüksek FODMAP Sebzeler',
      ),
      const IngredientInfo(
        id: 3,
        name: 'Havuç',
        fodmapLevel: 'low',
        category: 'sebze',
        isLactose: false,
        isGluten: false,
        categoryId: 8,
        categoryName: 'Düşük FODMAP Sebzeler',
      ),
    ];

    test('P0.4 & P0.5: Baseline rate, Lift ve Confidence doğru hesaplanır', () {
      // 4 kez Soğan yendi, her seferinde semptom görüldü
      final mealEvents = [
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 48))),
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 36))),
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 24))),
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 12))),
        // Havuç da yendi ama semptom görülmedi
        MealIngredientEvent(ingredientId: 3, eatenAt: now.subtract(const Duration(hours: 100))),
        MealIngredientEvent(ingredientId: 3, eatenAt: now.subtract(const Duration(hours: 80))),
        MealIngredientEvent(ingredientId: 3, eatenAt: now.subtract(const Duration(hours: 60))),
      ];

      final symptomEvents = [
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 46)), maxSeverity: 6.0),
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 34)), maxSeverity: 5.0),
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 22)), maxSeverity: 7.0),
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 10)), maxSeverity: 8.0),
      ];

      final result = CorrelationService.calculateAllCorrelations(
        ingredients: testIngredients,
        mealIngredients: mealEvents,
        symptomEvents: symptomEvents,
        timeWindowHours: 6,
      );

      final soganResult = result.ingredientCorrelations.firstWhere((r) => r.ingredientId == 1);
      expect(soganResult.totalEaten, 4);
      expect(soganResult.symptomCount, 4);
      expect(soganResult.hasEnoughData, true);
      expect(soganResult.symptomRate, 1.0);
      expect(soganResult.liftScore, greaterThan(1.0));
      expect(soganResult.confidence, 0.4); // 4 / 10
      expect(soganResult.compositeScore, greaterThan(0.5));
    });

    test('P0.3: Kategori bazlı korelasyon aynı gruptaki malzemeleri birleştirir', () {
      final mealEvents = [
        // 2 kez Soğan
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 20))),
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 15))),
        // 2 kez Sarımsak (Aynı kategori: Yüksek FODMAP Sebzeler)
        MealIngredientEvent(ingredientId: 2, eatenAt: now.subtract(const Duration(hours: 10))),
        MealIngredientEvent(ingredientId: 2, eatenAt: now.subtract(const Duration(hours: 5))),
      ];

      final symptomEvents = [
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 18)), maxSeverity: 6.0),
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 13)), maxSeverity: 5.0),
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 8)), maxSeverity: 7.0),
        SymptomEvent(loggedAt: now.subtract(const Duration(hours: 3)), maxSeverity: 8.0),
      ];

      final result = CorrelationService.calculateAllCorrelations(
        ingredients: testIngredients,
        mealIngredients: mealEvents,
        symptomEvents: symptomEvents,
        timeWindowHours: 6,
      );

      // Tekil malzemeler eşiği (3) geçemese de kategori birleşince 4 kez yenmiş olur ve hasEnoughData true döner
      final catResult = result.categoryCorrelations.firstWhere((c) => c.categoryId == 3);
      expect(catResult.totalEaten, 4);
      expect(catResult.hasEnoughData, true);
      expect(catResult.symptomCount, 4);
    });

    test('P2.2: Semptom filtresi sadece seçili semptomları sayar', () {
      final mealEvents = [
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 20))),
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 15))),
        MealIngredientEvent(ingredientId: 1, eatenAt: now.subtract(const Duration(hours: 10))),
      ];

      // Sadece 'reflu' olan semptom olayları
      final symptomEvents = [
        SymptomEvent(
          loggedAt: now.subtract(const Duration(hours: 18)),
          maxSeverity: 6.0,
          symptomTypes: ['reflu'],
        ),
        SymptomEvent(
          loggedAt: now.subtract(const Duration(hours: 13)),
          maxSeverity: 5.0,
          symptomTypes: ['reflu'],
        ),
      ];

      // 'ishal' filtrelenirse reaksiyon sayısı 0 olmalı
      final resultWithFilter = CorrelationService.calculateAllCorrelations(
        ingredients: testIngredients,
        mealIngredients: mealEvents,
        symptomEvents: symptomEvents,
        timeWindowHours: 6,
        symptomTypeFilter: {'ishal'},
      );

      final soganFiltered = resultWithFilter.ingredientCorrelations.firstWhere((r) => r.ingredientId == 1);
      expect(soganFiltered.symptomCount, 0);

      // 'reflu' filtrelenirse reaksiyon sayısı 2 olmalı
      final resultWithReflux = CorrelationService.calculateAllCorrelations(
        ingredients: testIngredients,
        mealIngredients: mealEvents,
        symptomEvents: symptomEvents,
        timeWindowHours: 6,
        symptomTypeFilter: {'reflu'},
      );

      final soganReflux = resultWithReflux.ingredientCorrelations.firstWhere((r) => r.ingredientId == 1);
      expect(soganReflux.symptomCount, 2);
    });
  });
}
