import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../data/database/database.dart';
import 'meal_form_screen.dart';
import 'symptom_form_screen.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  DateTime _selectedDate = DateTime.now();
  String _filter = 'all'; // all, meals, symptoms

  @override
  Widget build(BuildContext context) {
    final allMeals = ref.watch(allMealsProvider);
    final allSymptoms = ref.watch(allSymptomLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zaman Çizelgesi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 1)),
              );
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tarih navigasyonu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.primaryGreen.withOpacity(0.05),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(
                      () => _selectedDate = _selectedDate.subtract(const Duration(days: 1))),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('dd MMMM yyyy, EEEE').format(_selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(
                      () => _selectedDate = _selectedDate.add(const Duration(days: 1))),
                ),
              ],
            ),
          ),

          // Filtre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('Tümü', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Öğünler', 'meals'),
                const SizedBox(width: 8),
                _buildFilterChip('Semptomlar', 'symptoms'),
              ],
            ),
          ),

          // Timeline içeriği
          Expanded(
            child: allMeals.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (meals) => allSymptoms.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Hata: $e')),
                data: (symptoms) {
                  final items = _buildTimelineItems(meals, symptoms);
                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 64, color: AppTheme.textSecondary.withOpacity(0.3)),
                          const SizedBox(height: 12),
                          const Text('Bu tarihte kayıt yok',
                              style: TextStyle(color: AppTheme.textSecondary)),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _buildTimelineCard(context, items[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final selected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _filter = value),
      selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryGreen,
    );
  }

  List<dynamic> _buildTimelineItems(List<Meal> meals, List<SymptomLog> symptoms) {
    final items = <dynamic>[];

    final dayStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    if (_filter == 'all' || _filter == 'meals') {
      final dayMeals = meals.where((m) =>
          m.eatenAt.isAfter(dayStart) && m.eatenAt.isBefore(dayEnd));
      items.addAll(dayMeals.map((m) => {'type': 'meal', 'data': m, 'time': m.eatenAt}));
    }

    if (_filter == 'all' || _filter == 'symptoms') {
      final daySymptoms = symptoms.where((s) =>
          s.loggedAt.isAfter(dayStart) && s.loggedAt.isBefore(dayEnd));
      items.addAll(daySymptoms.map((s) => {'type': 'symptom', 'data': s, 'time': s.loggedAt}));
    }

    items.sort((a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime));
    return items;
  }

  Widget _buildTimelineCard(BuildContext context, dynamic item) {
    final type = item['type'] as String;
    final time = item['time'] as DateTime;

    if (type == 'meal') {
      final meal = item['data'] as Meal;
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
            child: Icon(AppTheme.getMealTypeIcon(meal.mealType),
                color: AppTheme.primaryGreen, size: 20),
          ),
          title: Text(meal.name),
          subtitle: Text(
              '${AppTheme.getMealTypeLabel(meal.mealType)} • ${DateFormat('HH:mm').format(time)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  meal.portionSize == 'kucuk'
                      ? 'Küçük'
                      : meal.portionSize == 'buyuk'
                          ? 'Büyük'
                          : 'Orta',
                  style: const TextStyle(fontSize: 12, color: AppTheme.primaryGreen),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (action) async {
                  if (action == 'edit') {
                    final repo = ref.read(repositoryProvider);
                    final ingredients = await repo.getMealIngredients(meal.id);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealFormScreen(
                            existingMeal: meal,
                            existingIngredients: ingredients,
                          ),
                        ),
                      );
                    }
                  } else if (action == 'delete') {
                    final repo = ref.read(repositoryProvider);
                    await repo.deleteMeal(meal.id);
                    ref.invalidate(allMealsProvider);
                    ref.invalidate(todayMealsProvider);
                    ref.invalidate(correlationResultsProvider);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                  const PopupMenuItem(value: 'delete', child: Text('Sil')),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      final log = item['data'] as SymptomLog;
      return Card(
        color: AppTheme.warning.withOpacity(0.05),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.warning.withOpacity(0.2),
            child: const Icon(Icons.sick_outlined, color: AppTheme.warning, size: 20),
          ),
          title: Text(
              'Genel İyilik: ${log.overallFeeling?.toStringAsFixed(0) ?? '-'} / 10'),
          subtitle: Text(DateFormat('HH:mm').format(time)),
          trailing: PopupMenuButton<String>(
            onSelected: (action) async {
              if (action == 'edit') {
                final repo = ref.read(repositoryProvider);
                final entries = await repo.getSymptomEntries(log.id);
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SymptomFormScreen(
                        existingLog: log,
                        existingEntries: entries,
                      ),
                    ),
                  );
                }
              } else if (action == 'delete') {
                final repo = ref.read(repositoryProvider);
                await repo.deleteSymptomLog(log.id);
                ref.invalidate(allSymptomLogsProvider);
                ref.invalidate(todaySymptomsProvider);
                ref.invalidate(correlationResultsProvider);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
              const PopupMenuItem(value: 'delete', child: Text('Sil')),
            ],
          ),
        ),
      );
    }
  }
}
