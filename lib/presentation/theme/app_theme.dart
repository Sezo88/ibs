import 'package:flutter/material.dart';

class AppTheme {
  // Ana renk paleti - sindirim sağlığı tonları (yumuşak yeşil/mavi)
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF2E7D32);
  static const Color accent = Color(0xFF64B5F6);
  static const Color warning = Color(0xFFFFA726);
  static const Color danger = Color(0xFFEF5350);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);

  // Semptom renkleri
  static const Color symptomBloating = Color(0xFFFFB74D);
  static const Color symptomCramp = Color(0xFFE57373);
  static const Color symptomDiarrhea = Color(0xFFBA68C8);
  static const Color symptomConstipation = Color(0xFF8D6E63);
  static const Color symptomGas = Color(0xFF90A4AE);
  static const Color symptomNausea = Color(0xFF4DD0E1);
  static const Color symptomReflux = Color(0xFFFF8A65);
  static const Color symptomFatigue = Color(0xFFBDBDBD);

  // FODMAP seviye renkleri
  static const Color fodmapHigh = Color(0xFFEF5350);
  static const Color fodmapMedium = Color(0xFFFFA726);
  static const Color fodmapLow = Color(0xFF66BB6A);
  static const Color fodmapUnknown = Color(0xFFBDBDBD);

  /// Semptom tipine göre renk döndürür
  static Color getSymptomColor(String type) {
    switch (type) {
      case 'sislik':
        return symptomBloating;
      case 'kramp':
        return symptomCramp;
      case 'ishal':
        return symptomDiarrhea;
      case 'kabizlik':
        return symptomConstipation;
      case 'gaz':
        return symptomGas;
      case 'bulanti':
        return symptomNausea;
      case 'reflu':
        return symptomReflux;
      case 'yorgunluk':
        return symptomFatigue;
      default:
        return textSecondary;
    }
  }

  /// Semptom tipi için Türkçe etiket
  static String getSymptomLabel(String type) {
    switch (type) {
      case 'sislik':
        return 'Şişkinlik';
      case 'kramp':
        return 'Kramp';
      case 'ishal':
        return 'İshal';
      case 'kabizlik':
        return 'Kabızlık';
      case 'gaz':
        return 'Gaz';
      case 'bulanti':
        return 'Bulantı';
      case 'reflu':
        return 'Reflü';
      case 'yorgunluk':
        return 'Yorgunluk';
      default:
        return type;
    }
  }

  /// FODMAP seviyesi için Türkçe etiket ve renk
  static String getFodmapLabel(String level) {
    switch (level) {
      case 'high':
        return 'Yüksek';
      case 'medium':
        return 'Orta';
      case 'low':
        return 'Düşük';
      default:
        return 'Bilinmiyor';
    }
  }

  static Color getFodmapColor(String level) {
    switch (level) {
      case 'high':
        return fodmapHigh;
      case 'medium':
        return fodmapMedium;
      case 'low':
        return fodmapLow;
      default:
        return fodmapUnknown;
    }
  }

  /// Öğün tipi için Türkçe etiket ve ikon
  static String getMealTypeLabel(String type) {
    switch (type) {
      case 'kahvalti':
        return 'Kahvaltı';
      case 'ogle':
        return 'Öğle';
      case 'aksam':
        return 'Akşam';
      case 'atistirma':
        return 'Atıştırma';
      case 'ara_ogun':
        return 'Ara Öğün';
      default:
        return type;
    }
  }

  static IconData getMealTypeIcon(String type) {
    switch (type) {
      case 'kahvalti':
        return Icons.wb_sunny;
      case 'ogle':
        return Icons.wb_cloudy;
      case 'aksam':
        return Icons.nights_stay;
      case 'atistirma':
        return Icons.cookie;
      case 'ara_ogun':
        return Icons.apple;
      default:
        return Icons.restaurant;
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        secondary: accent,
        surface: surface,
        error: danger,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.white,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}
