import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../data/database/database.dart';

/// P0.2: Kullanıcının eklediği malzemeleri düzenleme ekranı
class MyIngredientsScreen extends ConsumerWidget {
  const MyIngredientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIngredients = ref.watch(userIngredientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Malzemelerim')),
      body: userIngredients.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (ingredients) {
          if (ingredients.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.kitchen_outlined, size: 64,
                        color: AppTheme.textSecondary.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    const Text('Henüz özel malzeme eklemediniz.',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      'Öğün eklerken listede olmayan malzemeleri eklediğinizde burada görünecekler.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ing = ingredients[index];
              return _buildIngredientCard(context, ref, ing);
            },
          );
        },
      ),
    );
  }

  Widget _buildIngredientCard(
      BuildContext context, WidgetRef ref, Ingredient ing) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              AppTheme.getFodmapColor(ing.fodmapLevel).withOpacity(0.2),
          child: Text(
            ing.name.isNotEmpty ? ing.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: AppTheme.getFodmapColor(ing.fodmapLevel),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(ing.name,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Row(
          children: [
            _buildBadge(
                'FODMAP: ${AppTheme.getFodmapLabel(ing.fodmapLevel)}',
                AppTheme.getFodmapColor(ing.fodmapLevel)),
            if (ing.isGluten) ...[
              const SizedBox(width: 4),
              _buildBadge('Gluten', AppTheme.warning),
            ],
            if (ing.isLactose) ...[
              const SizedBox(width: 4),
              _buildBadge('Laktoz', AppTheme.accent),
            ],
          ],
        ),
        trailing: const Icon(Icons.edit, size: 20, color: AppTheme.primaryGreen),
        onTap: () => _showEditSheet(context, ref, ing),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, Ingredient ing) {
    String fodmapLevel = ing.fodmapLevel;
    String glutenChoice =
        ing.isGluten ? 'evet' : 'hayir';
    String lactoseChoice =
        ing.isLactose ? 'evet' : 'hayir';

    showModalBottomSheet(
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
              Text('"${ing.name}" Düzenle',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // FODMAP
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
              const Text('Gluten İçerir mi?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTagChip('Evet', 'evet', glutenChoice,
                      AppTheme.danger, (v) => setSheetState(() => glutenChoice = v)),
                  _buildTagChip('Hayır', 'hayir', glutenChoice,
                      AppTheme.primaryGreen, (v) => setSheetState(() => glutenChoice = v)),
                ],
              ),
              const SizedBox(height: 16),

              // Laktoz
              const Text('Laktoz İçerir mi?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildTagChip('Evet', 'evet', lactoseChoice,
                      AppTheme.danger, (v) => setSheetState(() => lactoseChoice = v)),
                  _buildTagChip('Hayır', 'hayir', lactoseChoice,
                      AppTheme.primaryGreen, (v) => setSheetState(() => lactoseChoice = v)),
                ],
              ),
              const SizedBox(height: 20),

              // Kaydet
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final repo = ref.read(repositoryProvider);
                    await repo.updateIngredient(
                      id: ing.id,
                      fodmapLevel: fodmapLevel,
                      isGluten: glutenChoice == 'evet',
                      isLactose: lactoseChoice == 'evet',
                    );
                    ref.invalidate(userIngredientsProvider);
                    ref.invalidate(allIngredientsProvider);
                    ref.invalidate(correlationResultsProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Güncelle'),
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
}
