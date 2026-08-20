import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import 'meal_form_screen.dart';
import 'symptom_form_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayMeals = ref.watch(todayMealsProvider);
    final todaySymptoms = ref.watch(todaySymptomsProvider);
    final weeklyWellbeing = ref.watch(weeklyWellbeingProvider);
    final allIngredients = ref.watch(allIngredientsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('İBS Semptom Takip'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MealFormScreen()),
            ),
            tooltip: 'Öğün Ekle',
          ),
          IconButton(
            icon: const Icon(Icons.sick_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SymptomFormScreen()),
            ),
            tooltip: 'Semptom Ekle',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayMealsProvider);
          ref.invalidate(todaySymptomsProvider);
          ref.invalidate(weeklyWellbeingProvider);
          ref.invalidate(allIngredientsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Genel durum kartı
            _buildWellbeingCard(context, ref, weeklyWellbeing),
            const SizedBox(height: 16),

            // Hızlı istatistikler
            _buildQuickStats(context, todayMeals, todaySymptoms),
            const SizedBox(height: 16),

            // Bugünün öğünleri
            _buildSectionHeader(context, 'Bugünün Öğünleri', Icons.restaurant,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MealFormScreen()))),
            const SizedBox(height: 8),
            todayMeals.when(
              data: (meals) => meals.isEmpty
                  ? _buildEmptyCard('Henüz öğün kaydı yok.\n+ butonuyla ilk öğününü ekle!')
                  : Column(
                      children: meals.map((m) => _buildMealCard(context, m)).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),
            const SizedBox(height: 16),

            // Bugünün semptomları
            _buildSectionHeader(context, 'Bugünün Semptomları', Icons.sick_outlined,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SymptomFormScreen()))),
            const SizedBox(height: 8),
            todaySymptoms.when(
              data: (logs) => logs.isEmpty
                  ? _buildEmptyCard('Henüz semptom kaydı yok.')
                  : Column(
                      children: logs.map((l) => _buildSymptomCard(context, ref, l)).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildWellbeingCard(
      BuildContext context, WidgetRef ref, AsyncValue<double> weekly) {
    return Card(
      color: AppTheme.primaryGreen.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Bu Hafta Genel Durumun',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            weekly.when(
              data: (avg) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(avg > 0 ? avg.toStringAsFixed(1) : '-',
                      style: const TextStyle(
                          fontSize: 42, fontWeight: FontWeight.bold, color: AppTheme.primaryDark)),
                  const Text(' / 10',
                      style: TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('- / 10',
                  style: TextStyle(fontSize: 42, color: AppTheme.textSecondary)),
            ),
            const SizedBox(height: 4),
            Text(weekly.valueOrNull != null && weekly.valueOrNull! >= 7
                ? 'Harika gidiyorsun! 🎉'
                : 'Veri toplanıyor... 📊',
                style: const TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(
      BuildContext context,
      AsyncValue<List<dynamic>> meals,
      AsyncValue<List<dynamic>> symptoms) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.restaurant, color: AppTheme.primaryGreen, size: 28),
                  const SizedBox(height: 4),
                  meals.when(
                    data: (m) => Text('${m.length}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    loading: () => const Text('...'),
                    error: (_, __) => const Text('0'),
                  ),
                  const Text('Öğün', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.sick_outlined, color: AppTheme.warning, size: 28),
                  const SizedBox(height: 4),
                  symptoms.when(
                    data: (s) => Text('${s.length}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    loading: () => const Text('...'),
                    error: (_, __) => const Text('0'),
                  ),
                  const Text('Semptom', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.warning_amber, color: AppTheme.danger, size: 28),
                  const SizedBox(height: 4),
                  const Text('?',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Şüpheli', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon,
      {VoidCallback? onTap}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryGreen),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Spacer(),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: const Text('+ Ekle'),
          ),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, dynamic meal) {
    // meal is a Meal object from the database
    final mealType = meal.mealType as String? ?? 'aksam';
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
          child: Icon(AppTheme.getMealTypeIcon(mealType),
              color: AppTheme.primaryGreen),
        ),
        title: Text(meal.name as String? ?? 'Öğün'),
        subtitle: Text(
            '${AppTheme.getMealTypeLabel(mealType)} • ${DateFormat('HH:mm').format(meal.eatenAt as DateTime)}'),
        trailing: meal.photoPath != null
            ? const Icon(Icons.photo_camera, size: 18)
            : null,
      ),
    );
  }

  Widget _buildSymptomCard(
      BuildContext context, WidgetRef ref, dynamic log) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.warning.withOpacity(0.2),
          child: const Icon(Icons.sick_outlined, color: AppTheme.warning),
        ),
        title: Text(
            'Genel: ${log.overallFeeling?.toStringAsFixed(0) ?? '-'} / 10'),
        subtitle: Text(DateFormat('HH:mm').format(log.loggedAt as DateTime)),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Hata: $error',
            style: const TextStyle(color: AppTheme.danger)),
      ),
    );
  }
}
