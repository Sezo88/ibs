import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../data/database/database.dart';

class MealFormScreen extends ConsumerStatefulWidget {
  final Meal? existingMeal;
  final List<Ingredient>? existingIngredients;
  /// Diyet planından direkt yemek eklerken kullanılır
  final String? presetMealName;
  final String? presetMealType;
  final List<Ingredient>? presetIngredients;

  const MealFormScreen({
    super.key,
    this.existingMeal,
    this.existingIngredients,
    this.presetMealName,
    this.presetMealType,
    this.presetIngredients,
  });

  @override
  ConsumerState<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends ConsumerState<MealFormScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _ingredientSearchController = TextEditingController();
  final _recipeSearchController = TextEditingController();
  DateTime _eatenAt = DateTime.now();
  String _mealType = 'aksam';
  String _portionSize = 'orta';
  final List<Ingredient> _selectedIngredients = [];

  // Malzeme arama
  String _ingredientSearchQuery = '';
  List<Ingredient> _ingredientSearchResults = [];
  List<Ingredient> _fuzzySearchResults = []; // P1.3: fuzzy sonuçlar
  bool _isSearchingIngredient = false;

  // Yemek şablonu arama
  String _recipeSearchQuery = '';
  List<MealTemplate> _recipeSearchResults = [];
  bool _isSearchingRecipe = false;

  bool get _isEditing => widget.existingMeal != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final meal = widget.existingMeal!;
      _nameController.text = meal.name;
      _notesController.text = meal.notes ?? '';
      _eatenAt = meal.eatenAt;
      _mealType = meal.mealType;
      _portionSize = meal.portionSize;
      if (widget.existingIngredients != null) {
        _selectedIngredients.addAll(widget.existingIngredients!);
      }
    }

    // Diyet planından preset geliyorsa
    if (widget.presetMealName != null) {
      _nameController.text = widget.presetMealName!;
    }
    if (widget.presetMealType != null) {
      _mealType = widget.presetMealType!;
    }
    if (widget.presetIngredients != null) {
      _selectedIngredients.addAll(widget.presetIngredients!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _ingredientSearchController.dispose();
    _recipeSearchController.dispose();
    super.dispose();
  }

  // ==================== MALZEME ARAMA ====================

  // P1.1: Öğün tipine göre varsayılan saat ayarla
  void _setDefaultTimeForMealType(String mealType) {
    if (_isEditing) return; // Düzenleme modunda otomatik değiştirme
    final now = DateTime.now();
    int hour;
    int minute = 0;
    switch (mealType) {
      case 'kahvalti':
        hour = 8;
        break;
      case 'ogle':
        hour = 13;
        break;
      case 'aksam':
        hour = 19;
        break;
      default:
        hour = now.hour;
        minute = now.minute;
    }
    setState(() {
      _eatenAt = DateTime(
        _eatenAt.year,
        _eatenAt.month,
        _eatenAt.day,
        hour,
        minute,
      );
    });
  }

  Future<void> _searchIngredients(String query) async {
    setState(() => _ingredientSearchQuery = query);
    if (query.length < 2) {
      setState(() {
        _ingredientSearchResults = [];
        _fuzzySearchResults = [];
        _isSearchingIngredient = false;
      });
      return;
    }
    setState(() => _isSearchingIngredient = true);
    final repo = ref.read(repositoryProvider);
    final results = await repo.searchIngredients(query);
    
    // P1.3: Normal arama boşsa fuzzy dene
    List<Ingredient> fuzzyResults = [];
    if (results.isEmpty) {
      fuzzyResults = await repo.searchIngredientsFuzzy(query);
    }
    
    setState(() {
      _ingredientSearchResults = results;
      _fuzzySearchResults = fuzzyResults;
      _isSearchingIngredient = false;
    });
  }

  void _addIngredient(Ingredient ingredient) {
    if (!_selectedIngredients.any((i) => i.id == ingredient.id)) {
      setState(() {
        _selectedIngredients.add(ingredient);
        _ingredientSearchQuery = '';
        _ingredientSearchResults = [];
        _ingredientSearchController.clear();
      });
    }
  }

  void _removeIngredient(Ingredient ingredient) {
    setState(() {
      _selectedIngredients.removeWhere((i) => i.id == ingredient.id);
    });
  }

  /// Listede olmayan malzemeyi veritabanına ekle — önce etiketleme sor
  Future<void> _addCustomIngredient(String name) async {
    final trimmedName = name.trim();
    
    // Akıllı ön-doldurma: isimden gluten/laktoz tahmini
    final lowerName = trimmedName.toLowerCase();
    final glutenKeywords = ['ekmek', 'makarna', 'un', 'bulgur', 'bira', 'simit', 'börek', 'poğaça', 'pide', 'kraker', 'bisküvi', 'erişte', 'mantı'];
    final lactoseKeywords = ['süt', 'yoğurt', 'peynir', 'krema', 'kaymak', 'dondurma', 'lor'];
    
    bool? suggestedGluten;
    bool? suggestedLactose;
    
    for (final kw in glutenKeywords) {
      if (lowerName.contains(kw)) {
        suggestedGluten = true;
        break;
      }
    }
    for (final kw in lactoseKeywords) {
      if (lowerName.contains(kw)) {
        suggestedLactose = true;
        break;
      }
    }
    
    // Bottom-sheet ile etiketleme
    final result = await _showIngredientTaggingSheet(
      trimmedName,
      suggestedGluten: suggestedGluten,
      suggestedLactose: suggestedLactose,
    );
    
    if (result == null) return; // İptal edildi
    
    final repo = ref.read(repositoryProvider);
    final id = await repo.addIngredient(
      name: trimmedName,
      fodmapLevel: result['fodmapLevel'] as String,
      isGluten: result['isGluten'] as bool,
      isLactose: result['isLactose'] as bool,
    );
    final newIngredient = await repo.getIngredientById(id);
    if (newIngredient != null) {
      _addIngredient(newIngredient);
      ref.invalidate(allIngredientsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"$trimmedName" malzeme olarak eklendi!')),
        );
      }
    }
  }

  /// Malzeme etiketleme bottom-sheet'i
  Future<Map<String, dynamic>?> _showIngredientTaggingSheet(
    String ingredientName, {
    bool? suggestedGluten,
    bool? suggestedLactose,
  }) async {
    String fodmapLevel = 'unknown';
    String glutenChoice = suggestedGluten == true ? 'evet' : 'bilmiyorum';
    String lactoseChoice = suggestedLactose == true ? 'evet' : 'bilmiyorum';

    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('"$ingredientName" Etiketle',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Bu bilgiler analiz doğruluğunu artırır.',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 16),

              // FODMAP Seviyesi
              const Text('FODMAP Seviyesi',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTagChip('Düşük', 'low', fodmapLevel,
                      AppTheme.fodmapLow, (v) => setSheetState(() => fodmapLevel = v)),
                  _buildTagChip('Orta', 'medium', fodmapLevel,
                      AppTheme.fodmapMedium, (v) => setSheetState(() => fodmapLevel = v)),
                  _buildTagChip('Yüksek', 'high', fodmapLevel,
                      AppTheme.fodmapHigh, (v) => setSheetState(() => fodmapLevel = v)),
                  _buildTagChip('Bilmiyorum', 'unknown', fodmapLevel,
                      AppTheme.textSecondary, (v) => setSheetState(() => fodmapLevel = v)),
                ],
              ),
              const SizedBox(height: 16),

              // Gluten
              Row(
                children: [
                  const Text('Gluten İçerir mi?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (suggestedGluten == true) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Tahmini: Evet',
                          style: TextStyle(
                              fontSize: 10, color: AppTheme.warning)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTagChip('Evet', 'evet', glutenChoice,
                      AppTheme.danger, (v) => setSheetState(() => glutenChoice = v)),
                  _buildTagChip('Hayır', 'hayir', glutenChoice,
                      AppTheme.primaryGreen, (v) => setSheetState(() => glutenChoice = v)),
                  _buildTagChip('Bilmiyorum', 'bilmiyorum', glutenChoice,
                      AppTheme.textSecondary, (v) => setSheetState(() => glutenChoice = v)),
                ],
              ),
              const SizedBox(height: 16),

              // Laktoz
              Row(
                children: [
                  const Text('Laktoz İçerir mi?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (suggestedLactose == true) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Tahmini: Evet',
                          style: TextStyle(
                              fontSize: 10, color: AppTheme.warning)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTagChip('Evet', 'evet', lactoseChoice,
                      AppTheme.danger, (v) => setSheetState(() => lactoseChoice = v)),
                  _buildTagChip('Hayır', 'hayir', lactoseChoice,
                      AppTheme.primaryGreen, (v) => setSheetState(() => lactoseChoice = v)),
                  _buildTagChip('Bilmiyorum', 'bilmiyorum', lactoseChoice,
                      AppTheme.textSecondary, (v) => setSheetState(() => lactoseChoice = v)),
                ],
              ),
              const SizedBox(height: 20),

              // Kaydet butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx, {
                      'fodmapLevel': fodmapLevel,
                      'isGluten': glutenChoice == 'evet',
                      'isLactose': lactoseChoice == 'evet',
                    });
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Malzemeyi Kaydet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Etiketleme chip'i
  Widget _buildTagChip(String label, String value, String currentValue,
      Color color, ValueChanged<String> onSelected) {
    final selected = currentValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(value),
      selectedColor: color.withOpacity(0.25),
      avatar: selected ? Icon(Icons.check, size: 16, color: color) : null,
      labelStyle: TextStyle(
        color: selected ? color : AppTheme.textSecondary,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  // ==================== YEMEK ŞABLONU ARAMA ====================

  Future<void> _searchRecipes(String query) async {
    setState(() => _recipeSearchQuery = query);
    if (query.length < 2) {
      setState(() {
        _recipeSearchResults = [];
        _isSearchingRecipe = false;
      });
      return;
    }
    setState(() => _isSearchingRecipe = true);
    final repo = ref.read(repositoryProvider);
    final results = await repo.searchMealTemplates(query);
    setState(() {
      _recipeSearchResults = results;
      _isSearchingRecipe = false;
    });
  }

  /// Yemek şablonu seçildiğinde malzemeleri otomatik doldur
  Future<void> _selectRecipe(MealTemplate template) async {
    final repo = ref.read(repositoryProvider);
    final ingredients = await repo.getTemplateIngredients(template);

    setState(() {
      _nameController.text = template.name;
      // Mevcut malzemeleri koruyarak yenilerini ekle
      for (final ing in ingredients) {
        if (!_selectedIngredients.any((i) => i.id == ing.id)) {
          _selectedIngredients.add(ing);
        }
      }
      _recipeSearchQuery = '';
      _recipeSearchResults = [];
      _recipeSearchController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${template.name} - ${ingredients.length} malzeme eklendi'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ==================== KAYDET ====================

  Future<void> _save() async {
    final repo = ref.read(repositoryProvider);

    // Öğün adı boşsa otomatik oluştur
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      final typeLabel = AppTheme.getMealTypeLabel(_mealType);
      final dateStr = DateFormat('dd.MM').format(_eatenAt);
      name = '$typeLabel - $dateStr';
    }

    final ingredientIds = _selectedIngredients.map((i) => i.id).toList();

    if (_isEditing) {
      await repo.updateMeal(
        id: widget.existingMeal!.id,
        name: name,
        mealType: _mealType,
        eatenAt: _eatenAt,
        portionSize: _portionSize,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        ingredientIds: ingredientIds,
      );
    } else {
      await repo.addMeal(
        name: name,
        mealType: _mealType,
        eatenAt: _eatenAt,
        portionSize: _portionSize,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        ingredientIds: ingredientIds,
      );

      // Kişisel şablona kaydet
      if (_selectedIngredients.isNotEmpty) {
        await repo.saveMealTemplate(
          name: name,
          ingredients: _selectedIngredients
              .map((i) => {'ingredient_id': i.id, 'name': i.name})
              .toList(),
        );
      }
    }

    ref.invalidate(allMealsProvider);
    ref.invalidate(todayMealsProvider);
    ref.invalidate(correlationResultsProvider);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Öğün güncellendi' : 'Öğün kaydedildi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Öğünü Düzenle' : 'Öğün Ekle'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Kaydet',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== ÖĞÜN TİPİ =====
          const Text('Öğün Tipi', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['kahvalti', 'ogle', 'aksam', 'atistirma', 'ara_ogun'].map((type) {
              final selected = _mealType == type;
              return ChoiceChip(
                label: Text(AppTheme.getMealTypeLabel(type)),
                selected: selected,
                onSelected: (_) {
                  setState(() => _mealType = type);
                  _setDefaultTimeForMealType(type);
                },
                selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                avatar: Icon(AppTheme.getMealTypeIcon(type), size: 18),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // ===== TARİH & SAAT =====
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _eatenAt,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                    );
                    if (date != null) {
                      setState(() => _eatenAt = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _eatenAt.hour,
                            _eatenAt.minute,
                          ));
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('dd.MM.yyyy').format(_eatenAt)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_eatenAt),
                    );
                    if (time != null) {
                      setState(() => _eatenAt = DateTime(
                            _eatenAt.year,
                            _eatenAt.month,
                            _eatenAt.day,
                            time.hour,
                            time.minute,
                          ));
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(DateFormat('HH:mm').format(_eatenAt)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ===== PORSİYON =====
          const Text('Porsiyon', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['kucuk', 'orta', 'buyuk'].map((size) {
              final selected = _portionSize == size;
              final label = size == 'kucuk'
                  ? 'Küçük'
                  : size == 'orta'
                      ? 'Orta'
                      : 'Büyük';
              return ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) => setState(() => _portionSize = size),
                selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // ===== YEMEK SEÇ (ŞABLON) =====
          _buildRecipeSection(),
          const SizedBox(height: 20),

          // ===== ÖĞÜN ADI (OPSİYONEL) =====
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Öğün Adı (opsiyonel)',
              hintText: 'Boş bırakırsan otomatik oluşturulur',
              prefixIcon: const Icon(Icons.restaurant),
              suffixIcon: _nameController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _nameController.clear()),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 20),

          // ===== MALZEMELER =====
          _buildIngredientsSection(),
          const SizedBox(height: 20),

          // ===== NOTLAR =====
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notlar (opsiyonel)',
              hintText: 'örn: Dışarıda yedim, çok yağlıydı...',
              prefixIcon: Icon(Icons.notes),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 30),

          // ===== KAYDET =====
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(_isEditing ? 'Güncelle' : 'Öğünü Kaydet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== YEMEK ŞABLONU SEÇ BÖLÜMÜ ====================

  Widget _buildRecipeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book, size: 20, color: AppTheme.primaryGreen),
            const SizedBox(width: 8),
            const Text('Yemek Seç', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('Şablondan otomatik malzeme ekle',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _recipeSearchController,
          decoration: InputDecoration(
            labelText: 'Yemek ara...',
            hintText: 'örn: Bamya, Mercimek, Köfte',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSearchingRecipe
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : _recipeSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _recipeSearchController.clear();
                          _searchRecipes('');
                        },
                      )
                    : null,
          ),
          onChanged: _searchRecipes,
        ),
        if (_recipeSearchResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.primaryGreen.withOpacity(0.05),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _recipeSearchResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final template = _recipeSearchResults[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.restaurant_menu,
                      color: AppTheme.primaryGreen, size: 20),
                  title: Text(template.name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(template.isBuiltin ? 'Hazır tarif' : 'Kişisel tarif',
                      style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  trailing: const Icon(Icons.add_circle_outline,
                      color: AppTheme.primaryGreen),
                  onTap: () => _selectRecipe(template),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // ==================== MALZEME SEÇ BÖLÜMÜ ====================

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Malzemeler', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        // P3.7: Öğün tipine göre hızlı öneriler
        _buildMealTypeQuickFavorites(),
        const SizedBox(height: 8),
        TextField(
          controller: _ingredientSearchController,
          decoration: InputDecoration(
            labelText: 'Malzeme ara...',
            hintText: 'örn: soğan, mercimek, domates',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSearchingIngredient
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : _ingredientSearchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _ingredientSearchController.clear();
                          _searchIngredients('');
                        },
                      )
                    : null,
          ),
          onChanged: _searchIngredients,
        ),

        // Arama sonuçları
        if (_ingredientSearchQuery.length >= 2) ...[
          const SizedBox(height: 8),
          if (_ingredientSearchResults.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.divider),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _ingredientSearchResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ing = _ingredientSearchResults[index];
                  final alreadyAdded =
                      _selectedIngredients.any((i) => i.id == ing.id);
                  return ListTile(
                    dense: true,
                    title: Text(ing.name),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.getFodmapColor(ing.fodmapLevel)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FODMAP: ${AppTheme.getFodmapLabel(ing.fodmapLevel)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.getFodmapColor(ing.fodmapLevel),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: alreadyAdded
                        ? const Icon(Icons.check, color: AppTheme.primaryGreen)
                        : const Icon(Icons.add),
                    enabled: !alreadyAdded,
                    onTap: () => _addIngredient(ing),
                  );
                },
              ),
            ),

          // P1.3: Fuzzy arama sonuçları
          if (_fuzzySearchResults.isNotEmpty && _ingredientSearchResults.isEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.help_outline, size: 16, color: AppTheme.accent),
                      SizedBox(width: 4),
                      Text('Bunu mu demek istediniz?',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accent)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...(_fuzzySearchResults.take(5).map((ing) {
                    final alreadyAdded =
                        _selectedIngredients.any((i) => i.id == ing.id);
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(ing.name),
                      trailing: alreadyAdded
                          ? const Icon(Icons.check, color: AppTheme.primaryGreen, size: 18)
                          : const Icon(Icons.add, size: 18),
                      enabled: !alreadyAdded,
                      onTap: () => _addIngredient(ing),
                    );
                  })),
                ],
              ),
            ),
          ],

          // Yeni malzeme ekle butonu (listede yoksa)
          if (!_isSearchingIngredient &&
              _ingredientSearchResults.isEmpty &&
              _fuzzySearchResults.isEmpty &&
              _ingredientSearchQuery.length >= 2)
            _buildNoResultsAddButton()
          else if (!_isSearchingIngredient &&
              _ingredientSearchResults.isNotEmpty &&
              !_ingredientSearchResults.any((ing) =>
                  ing.name.toLowerCase() ==
                  _ingredientSearchQuery.toLowerCase()))
            _buildNoResultsAddButton(),
        ],
        const SizedBox(height: 12),

        // Seçilen malzemeler
        if (_selectedIngredients.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _selectedIngredients.map((ing) {
              return Chip(
                label: Text(ing.name),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeIngredient(ing),
                backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                side: BorderSide(
                  color: AppTheme.getFodmapColor(ing.fodmapLevel).withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ] else
          Text('Henüz malzeme eklenmedi. Yukarıdan arayıp ekleyin veya yemek seçin.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      ],
    );
  }

  /// "Veritabanına Ekle" butonu — listede olmayan malzeme için
  /// P3.7: Öğün tipine göre sık kullanılan malzemeler
  Widget _buildMealTypeQuickFavorites() {
    List<String> suggestions;
    switch (_mealType) {
      case 'kahvalti':
        suggestions = ['Yumurta', 'Peynir (beyaz)', 'Zeytin', 'Domates', 'Salatalık', 'Ekmek (beyaz)', 'Çay'];
        break;
      case 'ogle':
      case 'aksam':
        suggestions = ['Pirinç', 'Tavuk', 'Kıyma (dana)', 'Zeytinyağı', 'Soğan', 'Salça (domates)', 'Yoğurt', 'Patates'];
        break;
      default:
        suggestions = ['Muz', 'Ceviz', 'Badem', 'Elma', 'Ayran', 'Kahve'];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flash_on, size: 14, color: AppTheme.accent),
            const SizedBox(width: 4),
            Text(
              '${AppTheme.getMealTypeLabel(_mealType)} için Sık Kullanılanlar:',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: suggestions.map((name) {
              final alreadyAdded =
                  _selectedIngredients.any((i) => i.name.toLowerCase() == name.toLowerCase());
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(name, style: const TextStyle(fontSize: 11)),
                  avatar: Icon(alreadyAdded ? Icons.check : Icons.add, size: 14),
                  backgroundColor: alreadyAdded
                      ? AppTheme.primaryGreen.withOpacity(0.15)
                      : AppTheme.background,
                  onPressed: () async {
                    if (alreadyAdded) return;
                    final repo = ref.read(repositoryProvider);
                    final results = await repo.searchIngredients(name);
                    if (results.isNotEmpty) {
                      _addIngredient(results.first);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultsAddButton() {
    final trimmedQuery = _ingredientSearchQuery.trim();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.accent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.accent.withOpacity(0.05),
      ),
      child: ListTile(
        dense: true,
        leading: const CircleAvatar(
          radius: 16,
          backgroundColor: AppTheme.accent,
          child: Icon(Icons.add, color: Colors.white, size: 18),
        ),
        title: Text('"$trimmedQuery" veritabanına ekle',
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: const Text('Listede yok — yeni malzeme olarak kaydet',
            style: TextStyle(fontSize: 11)),
        onTap: () => _addCustomIngredient(trimmedQuery),
      ),
    );
  }
}
