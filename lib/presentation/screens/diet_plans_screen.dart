import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../data/diet_plans_data.dart';
import '../../data/database/database.dart';
import 'meal_form_screen.dart';
import 'recipe_form_screen.dart';

class DietPlansScreen extends ConsumerStatefulWidget {
  const DietPlansScreen({super.key});

  @override
  ConsumerState<DietPlansScreen> createState() => _DietPlansScreenState();
}

class _DietPlansScreenState extends ConsumerState<DietPlansScreen> {
  int? _expandedPlanIndex;
  int? _expandedDayIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diyet Planları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Yemek Tarifi Oluştur',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecipeFormScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Üst bilgi kartı
          Card(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant_menu, color: AppTheme.primaryGreen),
                      SizedBox(width: 8),
                      Text('Hazır Diyet Listeleri',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bir plan seçin, günlük öğünleri inceleyin. '
                    'Tek tıkla bugünkü öğünlerinize ekleyin veya tüm günü başlatın!',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Yemek Tarifi Oluştur butonu
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecipeFormScreen()),
            ),
            icon: const Icon(Icons.menu_book),
            label: const Text('Kendi Yemek Tarifini Oluştur'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppTheme.primaryGreen),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),

          // Diyet planları listesi
          ...List.generate(availableDietPlans.length, (planIndex) {
            final plan = availableDietPlans[planIndex];
            final isExpanded = _expandedPlanIndex == planIndex;

            return Column(
              children: [
                _buildPlanCard(plan, planIndex, isExpanded),
                if (isExpanded) _buildPlanDays(plan, planIndex),
                const SizedBox(height: 12),
              ],
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPlanCard(DietPlanData plan, int planIndex, bool isExpanded) {
    IconData planIcon;
    Color planColor;
    switch (plan.type) {
      case 'fodmap_elimination':
        planIcon = Icons.block;
        planColor = AppTheme.danger;
        break;
      case 'fodmap_reintro':
        planIcon = Icons.science;
        planColor = AppTheme.warning;
        break;
      default:
        planIcon = Icons.favorite;
        planColor = AppTheme.primaryGreen;
    }

    return Card(
      elevation: isExpanded ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isExpanded
            ? BorderSide(color: planColor.withOpacity(0.5), width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _expandedPlanIndex = isExpanded ? null : planIndex;
            _expandedDayIndex = null;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: planColor.withOpacity(0.2),
                    child: Icon(planIcon, color: planColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('${plan.days.length} günlük plan',
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                Text(plan.description,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
                const SizedBox(height: 12),
                // Tüm günü başlat butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _startFullDay(plan, 0),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('1. Günü Bugüne Ekle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: planColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanDays(DietPlanData plan, int planIndex) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: List.generate(plan.days.length, (dayIndex) {
          final day = plan.days[dayIndex];
          final isDayExpanded = _expandedDayIndex == dayIndex;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
                    child: Text('${day.dayNumber}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGreen,
                            fontSize: 12)),
                  ),
                  title: Text(day.label,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${day.meals.length} öğün',
                      style: const TextStyle(fontSize: 11)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tüm günü ekle
                      IconButton(
                        icon: const Icon(Icons.add_task,
                            color: AppTheme.primaryGreen, size: 20),
                        tooltip: 'Tüm günü bugüne ekle',
                        onPressed: () => _startFullDay(plan, dayIndex),
                      ),
                      Icon(isDayExpanded
                          ? Icons.expand_less
                          : Icons.expand_more),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _expandedDayIndex = isDayExpanded ? null : dayIndex;
                    });
                  },
                ),
                if (isDayExpanded)
                  ...day.meals.map((meal) => _buildMealTile(meal)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMealTile(DietMealData meal) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(AppTheme.getMealTypeIcon(meal.mealType),
          size: 18, color: AppTheme.textSecondary),
      title: Text(meal.recipeName, style: const TextStyle(fontSize: 14)),
      subtitle: meal.note != null
          ? Text(meal.note!,
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))
          : Text(AppTheme.getMealTypeLabel(meal.mealType),
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 22),
        tooltip: 'Bu öğünü ekle',
        onPressed: () => _addSingleMeal(meal),
      ),
    );
  }

  /// Tek bir öğünü bugüne ekle
  Future<void> _addSingleMeal(DietMealData meal) async {
    final repo = ref.read(repositoryProvider);

    // Şablonu bul
    final template = await repo.searchMealTemplate(meal.recipeName);
    List<Ingredient> ingredients = [];
    if (template != null) {
      ingredients = await repo.getTemplateIngredients(template);
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealFormScreen(
            presetMealName: meal.recipeName,
            presetMealType: meal.mealType,
            presetIngredients: ingredients,
          ),
        ),
      );
    }
  }

  /// Tüm günü bugüne ekle
  Future<void> _startFullDay(DietPlanData plan, int dayIndex) async {
    final day = plan.days[dayIndex];
    final repo = ref.read(repositoryProvider);
    int addedCount = 0;

    final now = DateTime.now();
    // Her öğün tipine uygun saat ata
    final mealTimes = {
      'kahvalti': const TimeOfDay(hour: 8, minute: 0),
      'ogle': const TimeOfDay(hour: 12, minute: 30),
      'aksam': const TimeOfDay(hour: 19, minute: 0),
      'ara_ogun': const TimeOfDay(hour: 15, minute: 30),
      'atistirma': const TimeOfDay(hour: 16, minute: 0),
    };

    for (final meal in day.meals) {
      final template = await repo.searchMealTemplate(meal.recipeName);
      List<int> ingredientIds = [];
      if (template != null) {
        final ingredients = await repo.getTemplateIngredients(template);
        ingredientIds = ingredients.map((i) => i.id).toList();
      }

      final time = mealTimes[meal.mealType] ?? const TimeOfDay(hour: 12, minute: 0);
      final eatenAt = DateTime(now.year, now.month, now.day, time.hour, time.minute);

      await repo.addMeal(
        name: meal.recipeName,
        mealType: meal.mealType,
        eatenAt: eatenAt,
        notes: meal.note,
        ingredientIds: ingredientIds,
      );
      addedCount++;
    }

    ref.invalidate(allMealsProvider);
    ref.invalidate(todayMealsProvider);
    ref.invalidate(correlationResultsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${day.label} - $addedCount öğün bugüne eklendi! 🎉'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    }
  }
}
