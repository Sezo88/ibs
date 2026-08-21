import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../domain/services/export_service.dart';
import '../../data/database/database.dart';
import 'my_ingredients_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // P0.2: Malzemelerim
          const Text('🥗 Malzeme Yönetimi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.primaryGreen,
                child: Icon(Icons.kitchen, color: Colors.white),
              ),
              title: const Text('Malzemelerim'),
              subtitle: const Text('Eklediğin malzemeleri düzenle (FODMAP, gluten, laktoz)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyIngredientsScreen()),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // P1.1: Varsayılan Öğün Saatleri
          const Text('🕐 Varsayılan Öğün Saatleri',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildMealTimeRow('Kahvaltı', 'kahvalti', Icons.wb_sunny),
                  const Divider(height: 1),
                  _buildMealTimeRow('Öğle', 'ogle', Icons.wb_cloudy),
                  const Divider(height: 1),
                  _buildMealTimeRow('Akşam', 'aksam', Icons.nights_stay),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Hatırlatıcılar
          const Text('⏰ Hatırlatıcılar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          reminders.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Hata: $e'),
            data: (list) => Column(
              children: [
                ...list.map((r) => _buildReminderCard(r)),
                if (list.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Henüz hatırlatıcı eklenmedi.',
                          textAlign: TextAlign.center),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showReminderDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Hatırlatıcı Ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Veri Dışa Aktarma
          const Text('📤 Veri Dışa Aktarma',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.primaryGreen,
                      child: Icon(Icons.picture_as_pdf, color: Colors.white),
                    ),
                    title: const Text('PDF Raporu'),
                    subtitle: const Text('Doktora götürmek için detaylı rapor'),
                    onTap: () => _exportPdf(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.accent,
                      child: Icon(Icons.table_chart, color: Colors.white),
                    ),
                    title: const Text('CSV Dışa Aktar'),
                    subtitle: const Text('Tüm verileri CSV olarak kaydet'),
                    onTap: () => _exportCsv(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // P1.4: Yedekleme/Geri Yükleme
          const Text('💾 Yedekleme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.primaryDark,
                      child: Icon(Icons.backup, color: Colors.white),
                    ),
                    title: const Text('Verilerimi Yedekle'),
                    subtitle: const Text('Tüm verileri JSON olarak dışa aktar'),
                    onTap: () => _backupData(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppTheme.warning,
                      child: Icon(Icons.restore, color: Colors.white),
                    ),
                    title: const Text('Yedekten Geri Yükle'),
                    subtitle: const Text('JSON yedek dosyasından veri yükle'),
                    onTap: () => _restoreData(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Uygulama Hakkında
          const Text('ℹ️ Uygulama Hakkında',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline, color: AppTheme.primaryGreen),
                  title: Text('Sürüm'),
                  subtitle: Text('v1.1.0'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.medical_services_outlined,
                      color: AppTheme.warning),
                  title: Text('Tıbbi Yasal Uyarı'),
                  subtitle: Text(
                      'Bu uygulama tıbbi teşhis koymaz. Doktor veya diyetisyen tavsiyesinin yerine geçmez.'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                      const Icon(Icons.shield_outlined, color: AppTheme.primaryGreen),
                  title: const Text('Gizlilik'),
                  subtitle: const Text('Tüm verileriniz cihazınızda kalır. Hiçbir sunucuya gönderilmez.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // P1.1: Varsayılan öğün saati satırı
  Widget _buildMealTimeRow(String label, String mealType, IconData icon) {
    return FutureBuilder<String?>(
      future: ref.read(repositoryProvider).getUserSetting('default_meal_time_$mealType'),
      builder: (context, snapshot) {
        final defaultTimes = {
          'kahvalti': '08:00',
          'ogle': '13:00',
          'aksam': '19:00',
        };
        final currentTime = snapshot.data ?? defaultTimes[mealType] ?? '12:00';

        return ListTile(
          leading: Icon(icon, color: AppTheme.primaryGreen),
          title: Text(label),
          trailing: TextButton(
            onPressed: () async {
              final parts = currentTime.split(':');
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: int.tryParse(parts[0]) ?? 12,
                  minute: int.tryParse(parts[1]) ?? 0,
                ),
              );
              if (time != null) {
                final timeStr =
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                await ref
                    .read(repositoryProvider)
                    .setUserSetting('default_meal_time_$mealType', timeStr);
                setState(() {}); // Yenile
              }
            },
            child: Text(currentTime,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: reminder.enabled
              ? AppTheme.primaryGreen.withOpacity(0.2)
              : AppTheme.textSecondary.withOpacity(0.2),
          child: Icon(
            reminder.enabled ? Icons.notifications_active : Icons.notifications_off,
            color: reminder.enabled ? AppTheme.primaryGreen : AppTheme.textSecondary,
          ),
        ),
        title: Text(
          '${reminder.hour.toString().padLeft(2, '0')}:${reminder.minute.toString().padLeft(2, '0')}'),
        subtitle: Text(reminder.message),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: reminder.enabled,
              onChanged: (v) async {
                final repo = ref.read(repositoryProvider);
                await repo.updateReminder(
                  id: reminder.id,
                  hour: reminder.hour,
                  minute: reminder.minute,
                  daysOfWeek: reminder.daysOfWeek,
                  enabled: v,
                  reminderType: reminder.reminderType,
                  message: reminder.message,
                );
                ref.invalidate(remindersProvider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.danger, size: 20),
              onPressed: () async {
                final repo = ref.read(repositoryProvider);
                await repo.deleteReminder(reminder.id);
                ref.invalidate(remindersProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDialog() {
    final hourController = TextEditingController(text: '20');
    final minuteController = TextEditingController(text: '00');
    final messageController =
        TextEditingController(text: 'Bugün nasıl hissediyorsun?');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hatırlatıcı Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hourController,
                    decoration: const InputDecoration(labelText: 'Saat'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: minuteController,
                    decoration: const InputDecoration(labelText: 'Dakika'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Mesaj'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final hour = int.tryParse(hourController.text) ?? 20;
              final minute = int.tryParse(minuteController.text) ?? 0;
              if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
                final repo = ref.read(repositoryProvider);
                await repo.addReminder(
                  hour: hour,
                  minute: minute,
                  message: messageController.text,
                );
                ref.invalidate(remindersProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  // P1.4: Veri yedekleme
  Future<void> _backupData() async {
    try {
      final repo = ref.read(repositoryProvider);
      final data = await repo.exportAllDataToJson();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);

      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'ibs_yedek_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(jsonStr);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yedek dosyası oluşturuldu!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yedekleme hatası: $e')),
        );
      }
    }
  }

  // P1.4: Veri geri yükleme
  Future<void> _restoreData() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Yedekten Geri Yükle'),
        content: const Text(
          'Yedek dosyasından veri yüklenecek.\n\n'
          'Mevcut verilere ne yapılsın?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, 'merge'),
            child: const Text('Birleştir'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, 'overwrite'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Üzerine Yaz',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == null) return;

    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (picked == null || picked.files.isEmpty) return;

      final file = File(picked.files.first.path!);
      final jsonStr = await file.readAsString();
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      final repo = ref.read(repositoryProvider);
      await repo.importDataFromJson(data, overwrite: result == 'overwrite');

      // Provider'ları yenile
      ref.invalidate(allMealsProvider);
      ref.invalidate(allSymptomLogsProvider);
      ref.invalidate(todayMealsProvider);
      ref.invalidate(todaySymptomsProvider);
      ref.invalidate(correlationResultsProvider);
      ref.invalidate(allIngredientsProvider);
      ref.invalidate(remindersProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veriler başarıyla geri yüklendi!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geri yükleme hatası: $e')),
        );
      }
    }
  }

  Future<void> _exportPdf() async {
    final repo = ref.read(repositoryProvider);
    final allMeals = await repo.getAllMeals();
    final allSymptoms = await repo.getAllSymptomLogs();

    final mealExportData = <MealExportData>[];
    for (final meal in allMeals) {
      final ingredients = await repo.getMealIngredients(meal.id);
      mealExportData.add(MealExportData(
        name: meal.name,
        mealType: AppTheme.getMealTypeLabel(meal.mealType),
        eatenAt: meal.eatenAt,
        ingredients: ingredients.map((i) => i.name).toList(),
        notes: meal.notes,
      ));
    }

    final symptomExportData = <SymptomExportData>[];
    for (final log in allSymptoms) {
      final entries = await repo.getSymptomEntries(log.id);
      final symptomsMap = <String, double>{};
      for (final e in entries) {
        symptomsMap[AppTheme.getSymptomLabel(e.symptomType)] = e.severity;
      }
      symptomExportData.add(SymptomExportData(
        loggedAt: log.loggedAt,
        overallFeeling: log.overallFeeling ?? 0,
        symptoms: symptomsMap,
        notes: log.notes,
      ));
    }

    // Korelasyon verisi
    final allIngredients = await repo.getAllIngredients();
    final correlations = <CorrelationExportData>[];
    for (final ing in allIngredients.take(15)) {
      correlations.add(CorrelationExportData(
        ingredientName: ing.name,
        fodmapLevel: ing.fodmapLevel,
        totalEaten: 0,
        symptomCount: 0,
        suspicionScore: 0,
        symptomRate: 0,
        hasEnoughData: false,
        suspicionLabel: 'Veri yok',
      ));
    }

    try {
      final path = await ExportService.exportToPdf(
        meals: mealExportData,
        symptoms: symptomExportData,
        correlations: correlations,
      );
      if (mounted) {
        await ExportService.shareFile(path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF oluşturulamadı: $e')),
        );
      }
    }
  }

  Future<void> _exportCsv() async {
    final repo = ref.read(repositoryProvider);
    final allMeals = await repo.getAllMeals();
    final allSymptoms = await repo.getAllSymptomLogs();

    final mealExportData = <MealExportData>[];
    for (final meal in allMeals) {
      final ingredients = await repo.getMealIngredients(meal.id);
      mealExportData.add(MealExportData(
        name: meal.name,
        mealType: AppTheme.getMealTypeLabel(meal.mealType),
        eatenAt: meal.eatenAt,
        ingredients: ingredients.map((i) => i.name).toList(),
        notes: meal.notes,
      ));
    }

    final symptomExportData = <SymptomExportData>[];
    for (final log in allSymptoms) {
      final entries = await repo.getSymptomEntries(log.id);
      final symptomsMap = <String, double>{};
      for (final e in entries) {
        symptomsMap[AppTheme.getSymptomLabel(e.symptomType)] = e.severity;
      }
      symptomExportData.add(SymptomExportData(
        loggedAt: log.loggedAt,
        overallFeeling: log.overallFeeling ?? 0,
        symptoms: symptomsMap,
        notes: log.notes,
      ));
    }

    try {
      final path = await ExportService.exportToCsv(
        meals: mealExportData,
        symptoms: symptomExportData,
      );
      if (mounted) {
        await ExportService.shareFile(path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV oluşturulamadı: $e')),
        );
      }
    }
  }
}
