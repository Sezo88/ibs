/// Hazır diyet planı verileri — IBS hastaları için önerilen diyet şablonları
class DietPlanData {
  final String name;
  final String type; // fodmap_elimination, fodmap_reintro, ibs_friendly
  final String description;
  final List<DietDayData> days;

  const DietPlanData({
    required this.name,
    required this.type,
    required this.description,
    required this.days,
  });
}

class DietDayData {
  final int dayNumber;
  final String label; // "1. Gün", "Pazartesi" vs.
  final List<DietMealData> meals;

  const DietDayData({
    required this.dayNumber,
    required this.label,
    required this.meals,
  });
}

class DietMealData {
  final String mealType; // kahvalti, ogle, aksam, ara_ogun
  final String recipeName; // MealTemplate adı
  final String? note;

  const DietMealData({
    required this.mealType,
    required this.recipeName,
    this.note,
  });
}

/// Hazır diyet planları
final List<DietPlanData> availableDietPlans = [
  // ==================== DÜŞÜK FODMAP ELİMİNASYON DİYETİ ====================
  DietPlanData(
    name: 'Düşük FODMAP Eliminasyon Diyeti',
    type: 'fodmap_elimination',
    description:
        '6 haftalık eliminasyon diyeti. Yüksek FODMAP besinlerden kaçınarak semptomları azaltmayı hedefler. '
        'Bu sürede sadece düşük FODMAP yiyecekler tüketilir.',
    days: [
      DietDayData(dayNumber: 1, label: '1. Gün', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Omlet (sade)', note: 'Glütensiz ekmekle'),
        DietMealData(mealType: 'ogle', recipeName: 'Tavuk Izgara', note: 'Salata ile'),
        DietMealData(mealType: 'aksam', recipeName: 'Pilav (sade)', note: 'Tavuk ile'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 2, label: '2. Gün', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Menemen', note: 'Soğansız yapın'),
        DietMealData(mealType: 'ogle', recipeName: 'Zeytinyağlı Taze Fasulye'),
        DietMealData(mealType: 'aksam', recipeName: 'Balık Izgara'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Salata (mevsim)'),
      ]),
      DietDayData(dayNumber: 3, label: '3. Gün', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Kahvaltı Tabağı', note: 'Bal yerine reçel'),
        DietMealData(mealType: 'ogle', recipeName: 'Sebze Çorbası', note: 'Soğansız'),
        DietMealData(mealType: 'aksam', recipeName: 'Fırında Tavuk'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 4, label: '4. Gün', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Peynirli Omlet'),
        DietMealData(mealType: 'ogle', recipeName: 'Pilav Üstü Tavuk'),
        DietMealData(mealType: 'aksam', recipeName: 'Zeytinyağlı Kabak'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Salata (mevsim)'),
      ]),
      DietDayData(dayNumber: 5, label: '5. Gün', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Menemen'),
        DietMealData(mealType: 'ogle', recipeName: 'Tavuk Sote', note: 'Soğan az'),
        DietMealData(mealType: 'aksam', recipeName: 'Makarna', note: 'Glütensiz makarna önerilir'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 6, label: '6. Gün', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Yumurta + Kabak', note: 'Glütensiz alternatif'),
        DietMealData(mealType: 'ogle', recipeName: 'Çorba (Tavuk Suyu)'),
        DietMealData(mealType: 'aksam', recipeName: 'Fırında Patates'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Salata (mevsim)'),
      ]),
      DietDayData(dayNumber: 7, label: '7. Gün', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Kahvaltı Tabağı'),
        DietMealData(mealType: 'ogle', recipeName: 'Pilav (sade)', note: 'Tavuk ile'),
        DietMealData(mealType: 'aksam', recipeName: 'Balık Izgara'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
    ],
  ),

  // ==================== GENEL IBS DOSTU DİYET ====================
  DietPlanData(
    name: 'Genel IBS Dostu Diyet',
    type: 'ibs_friendly',
    description:
        'IBS semptomlarını tetiklemeden doyurucu ve dengeli beslenme planı. '
        'Orta FODMAP seviyeli yiyecekler kontrollü eklenir.',
    days: [
      DietDayData(dayNumber: 1, label: 'Pazartesi', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Kahvaltı Tabağı'),
        DietMealData(mealType: 'ogle', recipeName: 'Mercimek Çorbası', note: 'Az soğan ile'),
        DietMealData(mealType: 'aksam', recipeName: 'Tavuk Izgara'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 2, label: 'Salı', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Menemen'),
        DietMealData(mealType: 'ogle', recipeName: 'Pilav Üstü Tavuk'),
        DietMealData(mealType: 'aksam', recipeName: 'Zeytinyağlı Taze Fasulye'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Çoban Salata'),
      ]),
      DietDayData(dayNumber: 3, label: 'Çarşamba', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Peynirli Omlet'),
        DietMealData(mealType: 'ogle', recipeName: 'Çorba (Ezogelin)'),
        DietMealData(mealType: 'aksam', recipeName: 'Köfte'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Salata (mevsim)'),
      ]),
      DietDayData(dayNumber: 4, label: 'Perşembe', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Simit + Peynir'),
        DietMealData(mealType: 'ogle', recipeName: 'Sebze Çorbası'),
        DietMealData(mealType: 'aksam', recipeName: 'Fırında Tavuk'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 5, label: 'Cuma', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Kahvaltı Tabağı'),
        DietMealData(mealType: 'ogle', recipeName: 'Makarna'),
        DietMealData(mealType: 'aksam', recipeName: 'Balık Izgara'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Salata (mevsim)'),
      ]),
      DietDayData(dayNumber: 6, label: 'Cumartesi', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Sucuklu Yumurta'),
        DietMealData(mealType: 'ogle', recipeName: 'Kısır'),
        DietMealData(mealType: 'aksam', recipeName: 'Pilav (sade)', note: 'Et sote ile'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 7, label: 'Pazar', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Kahvaltı Tabağı'),
        DietMealData(mealType: 'ogle', recipeName: 'Çorba (Domates)'),
        DietMealData(mealType: 'aksam', recipeName: 'Karnıyarık', note: 'Soğan az'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Çoban Salata'),
      ]),
    ],
  ),

  // ==================== FODMAP YENİDEN TANITMA DİYETİ ====================
  DietPlanData(
    name: 'FODMAP Yeniden Tanıtma Diyeti',
    type: 'fodmap_reintro',
    description:
        'Eliminasyon döneminden sonra, her hafta bir FODMAP grubunu yeniden deneyin. '
        'Semptom çıkmazsa o grubu güvenle diyetinize ekleyebilirsiniz.',
    days: [
      DietDayData(dayNumber: 1, label: 'Hafta 1: Fruktoz Testi', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Kahvaltı Tabağı', note: 'Bal ekleyerek fruktoz testi'),
        DietMealData(mealType: 'ogle', recipeName: 'Pilav Üstü Tavuk'),
        DietMealData(mealType: 'aksam', recipeName: 'Salata (mevsim)', note: 'Elma dilimi ekle'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 2, label: 'Hafta 2: Laktoz Testi', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Peynirli Omlet'),
        DietMealData(mealType: 'ogle', recipeName: 'Yoğurtlu Makarna', note: 'Laktoz testi'),
        DietMealData(mealType: 'aksam', recipeName: 'Tavuk Izgara'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran', note: 'Süt ile dene'),
      ]),
      DietDayData(dayNumber: 3, label: 'Hafta 3: Fruktan Testi', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Simit + Peynir', note: 'Buğday fruktan testi'),
        DietMealData(mealType: 'ogle', recipeName: 'Mercimek Çorbası', note: 'Normal soğanla'),
        DietMealData(mealType: 'aksam', recipeName: 'Makarna', note: 'Normal makarna ile'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Salata (mevsim)'),
      ]),
      DietDayData(dayNumber: 4, label: 'Hafta 4: GOS Testi', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Kahvaltı Tabağı'),
        DietMealData(mealType: 'ogle', recipeName: 'Nohut Yemeği', note: 'GOS testi - küçük porsiyon'),
        DietMealData(mealType: 'aksam', recipeName: 'Pilav (sade)'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Ayran'),
      ]),
      DietDayData(dayNumber: 5, label: 'Hafta 5: Polyol Testi', meals: [
        DietMealData(mealType: 'kahvalti', recipeName: 'Menemen'),
        DietMealData(mealType: 'ogle', recipeName: 'Sebze Çorbası', note: 'Karnabahar ekle - polyol testi'),
        DietMealData(mealType: 'aksam', recipeName: 'Tavuk Sote', note: 'Mantar ekle'),
        DietMealData(mealType: 'ara_ogun', recipeName: 'Salata (mevsim)'),
      ]),
    ],
  ),
];
