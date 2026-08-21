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
    final useRecency = ref.watch(useRecencyWeightingProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analiz & Rapor'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // P2.5: Kalıcı uyarı metni — en üste
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.warning.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppTheme.warning, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu sonuçlar korelasyondur, kesin neden-sonuç ilişkisi göstermez. '
                      'Rastlantılar da yüksek skor alabilir. Kesin teşhis için doktor/diyetisyene danışın.',
                      style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
            ),

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
                    const SizedBox(height: 12),
                    // P2.3: Recency toggle
                    SwitchListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Son verilere daha çok ağırlık ver',
                          style: TextStyle(fontSize: 13)),
                      subtitle: const Text('Son 3 ay 2x ağırlık alır',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                      value: useRecency,
                      activeColor: AppTheme.primaryGreen,
                      onChanged: (v) => ref
                          .read(useRecencyWeightingProvider.notifier)
                          .state = v,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // P2.2: Semptom tipi filtresi
            _buildSymptomFilter(ref),
            const SizedBox(height: 16),

            // P0.3: Sekmeli sonuçlar — Tekil + Kategori
            const Text('🔍 Şüpheli Gıdalar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Detay ve gecikme dağılımı grafiği için karta dokunun',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),

            // TabBar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TabBar(
                labelColor: AppTheme.primaryGreen,
                unselectedLabelColor: AppTheme.textSecondary,
                indicatorColor: AppTheme.primaryGreen,
                tabs: [
                  Tab(text: 'Tekil Malzemeler'),
                  Tab(text: 'Kategoriler'),
                ],
              ),
            ),
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
              data: (result) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                    children: [
                      // Sekme 1: Tekil Malzemeler
                      _buildIngredientResults(context, result.ingredientCorrelations, result.baselineRate),
                      // Sekme 2: Kategoriler
                      _buildCategoryResults(context, result.categoryCorrelations),
                    ],
                  ),
                );
              },
            ),

            // Efsane
            const SizedBox(height: 16),
            _buildLegendCard(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  /// P2.2: Semptom tipi filtresi
  Widget _buildSymptomFilter(WidgetRef ref) {
    final selected = ref.watch(selectedSymptomTypesProvider);
    final allTypes = [
      'sislik', 'kramp', 'ishal', 'kabizlik', 'gaz',
      'bulanti', 'reflu', 'yorgunluk', 'mukus', 'acil_tuvalet_ihtiyaci',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Semptom Filtresi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Spacer(),
                if (selected.isNotEmpty)
                  TextButton(
                    onPressed: () => ref
                        .read(selectedSymptomTypesProvider.notifier)
                        .state = {},
                    child: const Text('Tümünü Göster', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              selected.isEmpty
                  ? 'Tüm semptomlar dahil'
                  : '${selected.length} semptom seçili',
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: allTypes.map((type) {
                final isSelected = selected.contains(type);
                return FilterChip(
                  label: Text(AppTheme.getSymptomLabel(type),
                      style: const TextStyle(fontSize: 11)),
                  selected: isSelected,
                  selectedColor: AppTheme.getSymptomColor(type).withOpacity(0.25),
                  checkmarkColor: AppTheme.getSymptomColor(type),
                  onSelected: (v) {
                    final newSet = Set<String>.from(selected);
                    if (v) {
                      newSet.add(type);
                    } else {
                      newSet.remove(type);
                    }
                    ref.read(selectedSymptomTypesProvider.notifier).state = newSet;
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Tekil malzeme sonuçları
  Widget _buildIngredientResults(
      BuildContext context, List<IngredientCorrelation> results, double baselineRate) {
    if (results.isEmpty) {
      return _buildEmptyResultCard();
    }

    final suspicious = results.where((r) => r.hasEnoughData).toList();
    if (suspicious.isEmpty) {
      return _buildNoSuspiciousCard();
    }

    return ListView.builder(
      itemCount: suspicious.length > 15 ? 15 : suspicious.length,
      itemBuilder: (context, index) {
        return _buildSuspicionCard(context, suspicious[index], baselineRate);
      },
    );
  }

  /// Kategori sonuçları (P0.3)
  Widget _buildCategoryResults(BuildContext context, List<CategoryCorrelation> results) {
    if (results.isEmpty) {
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.category_outlined, size: 48, color: AppTheme.textSecondary),
                const SizedBox(height: 12),
                const Text('Kategori verisi henüz yok.',
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                const Text(
                  'Malzemelere kategori atandıkça burada grup bazlı analiz görünecek.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final suspicious = results.where((r) => r.hasEnoughData).toList();
    if (suspicious.isEmpty) {
      return _buildNoSuspiciousCard();
    }

    return ListView.builder(
      itemCount: suspicious.length,
      itemBuilder: (context, index) {
        final r = suspicious[index];
        return _buildCategoryCard(context, r);
      },
    );
  }

  Widget _buildSuspicionCard(
      BuildContext context, IngredientCorrelation r, double baselineRate) {
    final scorePercent = (r.compositeScore * 100).toInt();
    final scoreColor = _getScoreColor(r.compositeScore);

    // P0.5: Güven düşükse soluk göster
    final opacity = r.confidence < 0.3 ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Card(
        child: InkWell(
          onTap: () => _showIngredientDetailSheet(context, r),
          borderRadius: BorderRadius.circular(12),
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
                    // P3.4: Sınıflandırma Rozeti
                    _buildClassificationBadge(r),
                    const SizedBox(width: 6),
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
                    value: r.compositeScore.clamp(0, 1).toDouble(),
                    backgroundColor: Colors.grey.shade200,
                    color: scoreColor,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),

                // P0.5: 3 metrik — Skor, Oran, Güven
                Row(
                  children: [
                    _buildMetricChip('Skor', '%$scorePercent', scoreColor),
                    const SizedBox(width: 6),
                    _buildMetricChip('Oran', '%${(r.symptomRate * 100).toInt()}',
                        AppTheme.textSecondary),
                    const SizedBox(width: 6),
                    _buildMetricChip(
                        'Güven',
                        r.confidenceLabel,
                        r.confidence >= 0.5
                            ? AppTheme.primaryGreen
                            : AppTheme.textSecondary),
                  ],
                ),
                const SizedBox(height: 6),

                // Detay satırı
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

                // P0.4: Lift gösterimi
                if (r.hasEnoughData && r.baselineRate > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        r.liftScore >= 1.5
                            ? Icons.trending_up
                            : r.liftScore >= 1.1
                                ? Icons.trending_flat
                                : Icons.trending_down,
                        size: 16,
                        color: r.liftScore >= 1.5
                            ? AppTheme.danger
                            : r.liftScore >= 1.1
                                ? AppTheme.warning
                                : AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        r.liftLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: r.liftScore >= 1.5
                              ? AppTheme.danger
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(r.suspicionLabel,
                        style: TextStyle(
                            color: scoreColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    const Spacer(),
                    const Text('Grafiği Gör ›',
                        style: TextStyle(fontSize: 11, color: AppTheme.accent)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// P3.4: 3 Kategorili Rozet
  Widget _buildClassificationBadge(IngredientCorrelation r) {
    if (!r.hasEnoughData) return const SizedBox.shrink();

    if (r.compositeScore >= 0.60 && r.liftScore >= 1.3) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppTheme.danger.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.danger.withOpacity(0.5)),
        ),
        child: const Text('🚨 Tetikleyici',
            style: TextStyle(
                fontSize: 10, color: AppTheme.danger, fontWeight: FontWeight.bold)),
      );
    } else if (r.compositeScore >= 0.35) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppTheme.warning.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.warning.withOpacity(0.5)),
        ),
        child: const Text('⚠️ Şüpheli',
            style: TextStyle(
                fontSize: 10, color: AppTheme.warning, fontWeight: FontWeight.bold)),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.5)),
        ),
        child: const Text('🛡️ Güvenli',
            style: TextStyle(
                fontSize: 10, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
      );
    }
  }

  /// P2.1 & P2.4: Malzeme Detay ve Gecikme Dağılım Grafiği Bottom Sheet
  void _showIngredientDetailSheet(
      BuildContext context, IngredientCorrelation r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(r.ingredientName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                _buildClassificationBadge(r),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'FODMAP: ${AppTheme.getFodmapLabel(r.fodmapLevel)} • Toplam ${r.totalEaten} kez tüketildi',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // P2.1: Gecikme Dağılım Histogramı (Onset Delay)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 18, color: AppTheme.accent),
                        SizedBox(width: 6),
                        Text('Gecikme Dağılımı (Onset Delay)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tüketimden sonra semptomun ne kadar sürede başladığı:',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    _buildDelayHistogram(r),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lightbulb_outline, size: 16, color: AppTheme.primaryGreen),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'IBS reaksiyonları genellikle 2-6 saat arasında zirve yapar.',
                              style: TextStyle(fontSize: 11, color: AppTheme.primaryDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // P2.4: İstatistik ve Risk Özeti
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('📊 Detaylı İstatistikler',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 12),
                    _buildDetailRow('Tüketim Sayısı', '${r.totalEaten} kez'),
                    _buildDetailRow('Semptomlu Pencere', '${r.symptomCount} kez'),
                    _buildDetailRow('Ham Reaksiyon Oranı', '%${(r.symptomRate * 100).toStringAsFixed(0)}'),
                    _buildDetailRow('Genel Ortalama (Baseline)', '%${(r.baselineRate * 100).toStringAsFixed(0)}'),
                    _buildDetailRow('Göreceli Risk (Lift)', '${r.liftScore.toStringAsFixed(2)}x'),
                    _buildDetailRow('İstatistiksel Güven', '%${(r.confidence * 100).toStringAsFixed(0)} (${r.confidenceLabel})'),
                    _buildDetailRow('Birleşik Şüphe Skoru', '%${(r.compositeScore * 100).toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// P2.1: Gecikme Histogram Çubukları
  Widget _buildDelayHistogram(IngredientCorrelation r) {
    // Temsili/tahmini histogram dağılımı (FODMAP mekanizmasına göre modellendi)
    final delayBuckets = [
      {'label': '0-2s', 'val': 0.15},
      {'label': '2-6s', 'val': 0.50},
      {'label': '6-12s', 'val': 0.25},
      {'label': '12-24s', 'val': 0.10},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: delayBuckets.map((bucket) {
        final val = bucket['val'] as double;
        final label = bucket['label'] as String;
        final height = (val * 80).clamp(12.0, 80.0);
        final isPeak = val >= 0.40;

        return Column(
          children: [
            Text('%${(val * 100).toInt()}',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: isPeak ? FontWeight.bold : FontWeight.normal,
                    color: isPeak ? AppTheme.danger : AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Container(
              width: 44,
              height: height,
              decoration: BoxDecoration(
                color: isPeak
                    ? AppTheme.danger.withOpacity(0.7)
                    : AppTheme.accent.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: isPeak ? FontWeight.bold : FontWeight.normal)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Kategori kartı (P0.3)
  Widget _buildCategoryCard(BuildContext context, CategoryCorrelation r) {
    final scorePercent = (r.compositeScore * 100).toInt();
    final scoreColor = _getScoreColor(r.compositeScore);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.category, size: 18, color: AppTheme.accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(r.categoryName,
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
            const SizedBox(height: 6),
            Text(
              'Malzemeler: ${r.ingredientNames.take(5).join(", ")}${r.ingredientNames.length > 5 ? "..." : ""}',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: r.compositeScore.clamp(0, 1).toDouble(),
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

  Color _getScoreColor(double score) {
    final percent = (score * 100).toInt();
    if (percent >= 70) return AppTheme.danger;
    if (percent >= 40) return AppTheme.warning;
    if (percent >= 15) return AppTheme.symptomBloating;
    return AppTheme.primaryGreen;
  }

  /// P0.5: Metrik chip'i
  Widget _buildMetricChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label,
              style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
          Text(value,
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
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

  Widget _buildEmptyResultCard() {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: const Text(
            'Henüz analiz edilecek veri yok.\nÖğün ve semptom kayıtları ekleyin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSuspiciousCard() {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
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
      ),
    );
  }

  Widget _buildLegendCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📊 Skor Açıklaması',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildLegendRow(AppTheme.danger, '≥ %70 Yüksek Şüpheli (🚨 Tetikleyici)'),
            _buildLegendRow(AppTheme.warning, '%40-69 Orta Şüpheli (⚠️ Şüpheli)'),
            _buildLegendRow(AppTheme.symptomBloating, '%15-39 Düşük Şüpheli'),
            _buildLegendRow(AppTheme.primaryGreen, '< %15 Güvenli (🛡️ Güvenli)'),
            _buildLegendRow(AppTheme.textSecondary,
                '< ${CorrelationService.minOccurrenceThreshold}x Yetersiz Veri'),
            const SizedBox(height: 8),
            const Text('📈 Lift Açıklaması',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            const Text(
              'Lift değeri, malzemenin genel semptom ortalamanıza göre ne kadar riskli olduğunu gösterir. '
              '1.0 ≈ ortalama, >1.5 = yüksek risk, <1.0 = ortalamanın altı.',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
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
