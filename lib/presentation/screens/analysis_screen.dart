import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../domain/services/correlation_service.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correlations = ref.watch(correlationResultsProvider);
    final timeWindow = ref.watch(selectedTimeWindowProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz & Rapor'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Zaman penceresi seçici
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Analiz Penceresi',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text(
                      'Yemekten sonraki kaç saat içindeki semptomlar sayılsın?',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [6, 24, 48, 72].map((hours) {
                      final selected = timeWindow == hours;
                      return ChoiceChip(
                        label: Text('$hours saat'),
                        selected: selected,
                        onSelected: (_) => ref
                            .read(selectedTimeWindowProvider.notifier)
                            .state = hours,
                        selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Şüpheli gıdalar
          const Text('🔍 Şüpheli Gıdalar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          correlations.when(
            loading: () => const Center(
                child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.textSecondary),
                    const SizedBox(height: 8),
                    Text(
                      'Analiz için yeterli veri yok.\nDüzenli olarak öğün ve semptom kaydı ekleyin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            data: (results) {
              if (results.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Henüz analiz edilecek veri yok.\nÖğün ve semptom kayıtları ekleyin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                );
              }

              final suspicious =
                  results.where((r) => r.hasEnoughData).toList();

              if (suspicious.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 48, color: AppTheme.primaryGreen),
                        const SizedBox(height: 12),
                        const Text('Henüz şüpheli gıda tespit edilmedi.',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          'En az ${CorrelationService.minOccurrenceThreshold} kez yenen malzemeler analiz edilir.',
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: suspicious
                    .take(15)
                    .map((r) => _buildSuspicionCard(context, r))
                    .toList(),
              );
            },
          ),

          // Efsane
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📊 Skor Açıklaması',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildLegendRow(AppTheme.danger, '≥ %70 Yüksek Şüpheli'),
                  _buildLegendRow(AppTheme.warning, '%40-69 Orta Şüpheli'),
                  _buildLegendRow(AppTheme.symptomBloating, '%15-39 Düşük Şüpheli'),
                  _buildLegendRow(AppTheme.primaryGreen, '< %15 Güvenli'),
                  _buildLegendRow(AppTheme.textSecondary,
                      '< ${CorrelationService.minOccurrenceThreshold}x Yetersiz Veri'),
                ],
              ),
            ),
          ),

          // Feragatname
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.warning, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Bu analiz tıbbi teşhis niteliği taşımaz. Sonuçları doktorunuz veya diyetisyeninizle paylaşın.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSuspicionCard(BuildContext context, IngredientCorrelation r) {
    final scorePercent = (r.suspicionScore * 100).toInt();
    Color scoreColor;
    if (scorePercent >= 70) {
      scoreColor = AppTheme.danger;
    } else if (scorePercent >= 40) {
      scoreColor = AppTheme.warning;
    } else if (scorePercent >= 15) {
      scoreColor = AppTheme.symptomBloating;
    } else {
      scoreColor = AppTheme.primaryGreen;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(r.ingredientName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '%$scorePercent',
                    style: TextStyle(
                        color: scoreColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // İlerleme çubuğu
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: r.suspicionScore.clamp(0, 1),
                backgroundColor: Colors.grey.shade200,
                color: scoreColor,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                _buildStatChip('${r.totalEaten}x yendi', Icons.restaurant),
                const SizedBox(width: 8),
                _buildStatChip('${r.symptomCount}x semptom', Icons.sick_outlined),
                const SizedBox(width: 8),
                _buildStatChip(
                    'FODMAP: ${AppTheme.getFodmapLabel(r.fodmapLevel)}',
                    Icons.info_outline),
              ],
            ),
            const SizedBox(height: 4),
            Text(r.suspicionLabel,
                style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
              width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
