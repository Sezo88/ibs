import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../data/database/database.dart';

/// Kullanıcının kendi yemek tarifini oluşturması için ekran
class RecipeFormScreen extends ConsumerStatefulWidget {
  final MealTemplate? existingTemplate;

  const RecipeFormScreen({super.key, this.existingTemplate});

  @override
  ConsumerState<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends ConsumerState<RecipeFormScreen> {
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  final List<Ingredient> _selectedIngredients = [];
  String _searchQuery = '';
  List<Ingredient> _searchResults = [];
  bool _isSearching = false;

  bool get _isEditing => widget.existingTemplate != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.existingTemplate!.name;
      _loadExistingIngredients();
    }
  }

  Future<void> _loadExistingIngredients() async {
    final repo = ref.read(repositoryProvider);
    final ingredients =
        await repo.getTemplateIngredients(widget.existingTemplate!);
    setState(() => _selectedIngredients.addAll(ingredients));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
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
        _searchController.clear();
      });
    }
  }

  void _removeIngredient(Ingredient ingredient) {
    setState(() {
      _selectedIngredients.removeWhere((i) => i.id == ingredient.id);
    });
  }

  Future<void> _addCustomIngredient(String name) async {
    final repo = ref.read(repositoryProvider);
    final id = await repo.addIngredient(name: name.trim());
    final newIngredient = await repo.getIngredientById(id);
    if (newIngredient != null) {
      _addIngredient(newIngredient);
      ref.invalidate(allIngredientsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"$name" malzeme olarak eklendi!')),
        );
      }
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tarif adını girin')),
      );
      return;
    }
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az bir malzeme ekleyin')),
      );
      return;
    }

    final repo = ref.read(repositoryProvider);
    await repo.saveMealTemplate(
      name: name,
      ingredients: _selectedIngredients
          .map((i) => {'ingredient_id': i.id, 'name': i.name})
          .toList(),
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _isEditing ? 'Tarif güncellendi' : '"$name" tarifi kaydedildi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Tarifi Düzenle' : 'Yemek Tarifi Oluştur'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Kaydet',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bilgilendirme kartı
          Card(
            color: AppTheme.accent.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.accent, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Oluşturduğun tarifler "Yemek Seç" kısmında çıkar. Bir daha aynı malzemeleri tek tek eklemenize gerek kalmaz!',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tarif adı
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Yemek Adı',
              hintText: 'örn: Bamya Yemeği, Anne Makarnası',
              prefixIcon: Icon(Icons.restaurant_menu),
            ),
          ),
          const SizedBox(height: 20),

          // Malzeme ekleme
          const Text('Malzemeler',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Malzeme ara...',
              hintText: 'örn: soğan, domates',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _searchIngredients('');
                          },
                        )
                      : null,
            ),
            onChanged: _searchIngredients,
          ),

          // Arama sonuçları
          if (_searchQuery.length >= 2) ...[
            const SizedBox(height: 8),
            if (_searchResults.isNotEmpty)
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
                          ? const Icon(Icons.check,
                              color: AppTheme.primaryGreen)
                          : const Icon(Icons.add),
                      enabled: !alreadyAdded,
                      onTap: () => _addIngredient(ing),
                    );
                  },
                ),
              ),

            // Listede yoksa ekle butonu
            if (!_isSearching &&
                _searchResults.isEmpty &&
                _searchQuery.length >= 2)
              _buildAddNewButton()
            else if (!_isSearching &&
                _searchResults.isNotEmpty &&
                !_searchResults.any((ing) =>
                    ing.name.toLowerCase() == _searchQuery.toLowerCase()))
              _buildAddNewButton(),
          ],
          const SizedBox(height: 16),

          // Seçilen malzemeler
          if (_selectedIngredients.isNotEmpty) ...[
            Text('${_selectedIngredients.length} malzeme seçildi',
                style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
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
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'Yukarıdan malzeme arayıp ekleyin.\nListede olmayan malzemeyi yazıp veritabanına ekleyebilirsiniz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 30),

          // Kaydet
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(_isEditing ? 'Güncelle' : 'Tarifi Kaydet'),
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

  Widget _buildAddNewButton() {
    final trimmedQuery = _searchQuery.trim();
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
        title: Text('"$trimmedQuery" veritabanına ekle'),
        subtitle: const Text('Listede yok — yeni malzeme olarak kaydet',
            style: TextStyle(fontSize: 11)),
        onTap: () => _addCustomIngredient(trimmedQuery),
      ),
    );
  }
}
