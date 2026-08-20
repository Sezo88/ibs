import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../data/database/database.dart';

class MealFormScreen extends ConsumerStatefulWidget {
  final Meal? existingMeal;
  final List<Ingredient>? existingIngredients;

  const MealFormScreen({
    super.key,
    this.existingMeal,
    this.existingIngredients,
  });

  @override
  ConsumerState<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends ConsumerState<MealFormScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _eatenAt = DateTime.now();
  String _mealType = 'aksam';
  String _portionSize = 'orta';
  final List<Ingredient> _selectedIngredients = [];
  String _searchQuery = '';
  List<Ingredient> _searchResults = [];
  bool _isSearching = false;

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _searchIngredients(String query) async {
    setState(() => _searchQuery = query);
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    final repo = ref.read(repositoryProvider);
    final results = await repo.searchIngredients(query);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _addIngredient(Ingredient ingredient) {
    if (!_selectedIngredients.any((i) => i.id == ingredient.id)) {
      setState(() {
        _selectedIngredients.add(ingredient);
        _searchQuery = '';
        _searchResults = [];
      });
    }
  }

  void _removeIngredient(Ingredient ingredient) {
    setState(() {
      _selectedIngredients.removeWhere((i) => i.id == ingredient.id);
    });
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen öğün adını girin')),
      );
      return;
    }

    final repo = ref.read(repositoryProvider);
    final name = _nameController.text.trim();
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
          // Öğün adı
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Öğün Adı',
              hintText: 'örn: Mercimek çorbası + pilav',
              prefixIcon: Icon(Icons.restaurant),
            ),
          ),
          const SizedBox(height: 16),

          // Öğün tipi
          const Text('Öğün Tipi', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['kahvalti', 'ogle', 'aksam', 'atistirma'].map((type) {
              final selected = _mealType == type;
              return ChoiceChip(
                label: Text(AppTheme.getMealTypeLabel(type)),
                selected: selected,
                onSelected: (_) => setState(() => _mealType = type),
                selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Tarih & Saat
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

          // Porsiyon
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

          // Malzeme arama
          const Text('Malzemeler', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Malzeme ara...',
              hintText: 'örn: soğan, mercimek, domates',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : null,
            ),
            onChanged: _searchIngredients,
          ),
          if (_searchResults.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.divider),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ing = _searchResults[index];
                  final alreadyAdded =
                      _selectedIngredients.any((i) => i.id == ing.id);
                  return ListTile(
                    dense: true,
                    title: Text(ing.name),
                    trailing: alreadyAdded
                        ? const Icon(Icons.check, color: AppTheme.primaryGreen)
                        : const Icon(Icons.add),
                    enabled: !alreadyAdded,
                    onTap: () => _addIngredient(ing),
                  );
                },
              ),
            ),
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
                );
              }).toList(),
            ),
          ] else
            Text('Henüz malzeme eklenmedi. Yukarıdan arayıp ekleyin.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 20),

          // Notlar
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

          // Kaydet butonu
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
}
