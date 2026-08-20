import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

/// Veri dışa aktarma servisi
class ExportService {
  static const _dateFormat = 'dd.MM.yyyy HH:mm';

  /// CSV olarak dışa aktar
  static Future<String> exportToCsv({
    required List<MealExportData> meals,
    required List<SymptomExportData> symptoms,
  }) async {
    final rows = <List<String>>[
      ['Tür', 'Tarih', 'Detay', 'Notlar'],
    ];

    for (final meal in meals) {
      rows.add([
        'Öğün (${meal.mealType})',
        DateFormat(_dateFormat).format(meal.eatenAt),
        '${meal.name} - Malzemeler: ${meal.ingredients.join(", ")}',
        meal.notes ?? '',
      ]);
    }

    for (final symptom in symptoms) {
      rows.add([
        'Semptom',
        DateFormat(_dateFormat).format(symptom.loggedAt),
        symptom.symptoms.entries.map((e) => '${e.key}: ${e.value}/10').join(' | '),
        'Genel: ${symptom.overallFeeling}/10 ${symptom.notes ?? ""}',
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/ibs_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  /// PDF olarak dışa aktar
  static Future<String> exportToPdf({
    required List<MealExportData> meals,
    required List<SymptomExportData> symptoms,
    required List<CorrelationExportData> correlations,
  }) async {
    final pdf = pw.Document();
    final trFont = pw.Font.courier();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('IBS Semptom Takip - Rapor',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Paragraph(
                text: 'Oluşturulma: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}'),
            pw.SizedBox(height: 16),

            // Şüpheli gıdalar
            pw.Header(level: 1, child: pw.Text('Şüpheli Gıdalar',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
            if (correlations.where((c) => c.hasEnoughData && c.suspicionScore >= 0.15).isEmpty)
              pw.Paragraph(text: 'Henüz yeterli veri yok veya şüpheli gıda tespit edilmedi.')
            else
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Malzeme', 'FODMAP', 'Yenme', 'Semptom', 'Oran', 'Durum'],
                data: correlations
                    .where((c) => c.hasEnoughData && c.suspicionScore >= 0.15)
                    .map((c) => [
                          c.ingredientName,
                          c.fodmapLevel,
                          c.totalEaten.toString(),
                          c.symptomCount.toString(),
                          '%${(c.symptomRate * 100).toStringAsFixed(0)}',
                          c.suspicionLabel,
                        ])
                    .toList(),
              ),
            pw.SizedBox(height: 16),

            // Öğün kayıtları
            pw.Header(level: 1, child: pw.Text('Öğün Kayıtları',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
            if (meals.isEmpty)
              pw.Paragraph(text: 'Henüz öğün kaydı yok.')
            else
              ...meals.map((m) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${DateFormat(_dateFormat).format(m.eatenAt)} - ${m.mealType}: ${m.name}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('  Malzemeler: ${m.ingredients.join(", ")}'),
                      if (m.notes != null && m.notes!.isNotEmpty) pw.Text('  Not: ${m.notes}'),
                      pw.SizedBox(height: 4),
                    ],
                  )),
            pw.SizedBox(height: 16),

            // Semptom kayıtları
            pw.Header(level: 1, child: pw.Text('Semptom Kayıtları',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))),
            if (symptoms.isEmpty)
              pw.Paragraph(text: 'Henüz semptom kaydı yok.')
            else
              ...symptoms.map((s) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${DateFormat(_dateFormat).format(s.loggedAt)} - Genel: ${s.overallFeeling}/10',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ...s.symptoms.entries.map((e) => pw.Text('  ${e.key}: ${e.value}/10')),
                      if (s.notes != null && s.notes!.isNotEmpty) pw.Text('  Not: ${s.notes}'),
                      pw.SizedBox(height: 4),
                    ],
                  )),

            pw.SizedBox(height: 24),
            pw.Paragraph(
                text: 'Bu rapor IBS Semptom Takip uygulaması tarafından oluşturulmuştur. '
                    'Tıbbi teşhis niteliği taşımaz.'),
          ];
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/ibs_rapor_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }

  /// Paylaşım sayfasını açar
  static Future<void> shareFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }
}

/// Dışa aktarma için veri modelleri
class MealExportData {
  final String name;
  final String mealType;
  final DateTime eatenAt;
  final List<String> ingredients;
  final String? notes;

  const MealExportData({
    required this.name,
    required this.mealType,
    required this.eatenAt,
    required this.ingredients,
    this.notes,
  });
}

class SymptomExportData {
  final DateTime loggedAt;
  final double overallFeeling;
  final Map<String, double> symptoms; // tip -> şiddet
  final String? notes;

  const SymptomExportData({
    required this.loggedAt,
    required this.overallFeeling,
    required this.symptoms,
    this.notes,
  });
}

class CorrelationExportData {
  final String ingredientName;
  final String fodmapLevel;
  final int totalEaten;
  final int symptomCount;
  final double suspicionScore;
  final double symptomRate;
  final bool hasEnoughData;
  final String suspicionLabel;

  const CorrelationExportData({
    required this.ingredientName,
    required this.fodmapLevel,
    required this.totalEaten,
    required this.symptomCount,
    required this.suspicionScore,
    required this.symptomRate,
    required this.hasEnoughData,
    required this.suspicionLabel,
  });
}
