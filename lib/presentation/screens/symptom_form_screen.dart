import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../../data/database/database.dart';

class SymptomFormScreen extends ConsumerStatefulWidget {
  final SymptomLog? existingLog;
  final List<SymptomEntry>? existingEntries;

  const SymptomFormScreen({
    super.key,
    this.existingLog,
    this.existingEntries,
  });

  @override
  ConsumerState<SymptomFormScreen> createState() => _SymptomFormScreenState();
}

class _SymptomFormScreenState extends ConsumerState<SymptomFormScreen> {
  final _notesController = TextEditingController();
  DateTime _loggedAt = DateTime.now();
  double _overallFeeling = 5; // 0-10
  final Map<String, double> _symptoms = {}; // type -> severity
  bool _showSymptomDetails = false;

  // P3.1: Bristol Dışkı Skalası
  int? _bristolStoolType; // 1-7

  // P3.2: Enerji & Uyku
  double _energyLevel = 5;
  double _sleepQuality = 5;
  bool _showLifestyle = false;

  // P3.3: Semptom Süresi
  String _symptomDuration = ''; // "< 1 saat", "1-3 saat", "3-6 saat", "Tüm gün"

  bool get _isEditing => widget.existingLog != null;

  static const _symptomTypes = [
    'sislik',
    'kramp',
    'ishal',
    'kabizlik',
    'gaz',
    'bulanti',
    'reflu',
    'yorgunluk',
    'mukus',
    'acil_tuvalet_ihtiyaci',
  ];

  static const _bristolTypes = [
    {
      'type': 1,
      'title': 'Tip 1: Ayrı Sert Topaklar',
      'desc': 'Fındık gibi, geçmesi zor (Şiddetli kabızlık)',
      'icon': '🌰',
    },
    {
      'type': 2,
      'title': 'Tip 2: Sosis Şeklinde, Topaklı',
      'desc': 'Parçalı sosis görünümü (Hafif kabızlık)',
      'icon': '🥖',
    },
    {
      'type': 3,
      'title': 'Tip 3: Sosis Şeklinde, Çatlaklı',
      'desc': 'Yüzeyinde çatlaklar var (Normal)',
      'icon': '🌭',
    },
    {
      'type': 4,
      'title': 'Tip 4: Pürüzsüz & Yumuşak',
      'desc': 'Yılan/sosis gibi, ideal form (İdeal)',
      'icon': '✨',
    },
    {
      'type': 5,
      'title': 'Tip 5: Yumuşak Kenarlı Parçalar',
      'desc': 'Kolay geçen yumuşak parçalar (Lif eksikliği)',
      'icon': '☁️',
    },
    {
      'type': 6,
      'title': 'Tip 6: Püre Kıvamında',
      'desc': 'Kabarık, cıvık parçalar (Hafif ishal)',
      'icon': '🥣',
    },
    {
      'type': 7,
      'title': 'Tip 7: Tamamen Sıvı',
      'desc': 'Katı parça yok, tamamen su (Şiddetli ishal)',
      'icon': '💧',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final log = widget.existingLog!;
      _notesController.text = log.notes ?? '';
      _loggedAt = log.loggedAt;
      _overallFeeling = (log.overallFeeling ?? 5).toDouble();
      if (widget.existingEntries != null) {
        for (final entry in widget.existingEntries!) {
          _symptoms[entry.symptomType] = entry.severity;
        }
        _showSymptomDetails = _symptoms.isNotEmpty;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final repo = ref.read(repositoryProvider);

    // Notlara ek metadata'ları ekleyelim
    final extraNotes = <String>[];
    if (_bristolStoolType != null) {
      extraNotes.add('Bristol: Tip $_bristolStoolType');
    }
    if (_symptomDuration.isNotEmpty) {
      extraNotes.add('Süre: $_symptomDuration');
    }
    if (_showLifestyle) {
      extraNotes.add('Enerji: ${_energyLevel.toInt()}/10, Uyku: ${_sleepQuality.toInt()}/10');
    }

    String? fullNotes = _notesController.text.trim();
    if (extraNotes.isNotEmpty) {
      final metadataStr = '[${extraNotes.join(" | ")}]';
      fullNotes = fullNotes.isNotEmpty ? '$fullNotes\n$metadataStr' : metadataStr;
    }

    final symptoms = _symptoms.entries
        .map((e) => <String, dynamic>{'type': e.key, 'severity': e.value})
        .toList();

    if (_isEditing) {
      await repo.updateSymptomLog(
        id: widget.existingLog!.id,
        loggedAt: _loggedAt,
        overallFeeling: _overallFeeling,
        notes: fullNotes.isNotEmpty ? fullNotes : null,
        symptoms: symptoms,
      );
    } else {
      await repo.addSymptomLog(
        loggedAt: _loggedAt,
        overallFeeling: _overallFeeling,
        notes: fullNotes.isNotEmpty ? fullNotes : null,
        symptoms: symptoms,
      );
    }

    ref.invalidate(allSymptomLogsProvider);
    ref.invalidate(todaySymptomsProvider);
    ref.invalidate(weeklyWellbeingProvider);
    ref.invalidate(correlationResultsProvider);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(_isEditing ? 'Semptom güncellendi' : 'Semptom kaydedildi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Semptom Düzenle' : 'Semptom Ekle'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Kaydet',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Genel iyilik hali
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Genel İyilik Halin',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    _overallFeeling.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: _overallFeeling >= 7
                          ? AppTheme.primaryGreen
                          : _overallFeeling >= 4
                              ? AppTheme.warning
                              : AppTheme.danger,
                    ),
                  ),
                  const Text('/ 10', style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 12),
                  Slider(
                    value: _overallFeeling,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: _overallFeeling >= 7
                        ? AppTheme.primaryGreen
                        : _overallFeeling >= 4
                            ? AppTheme.warning
                            : AppTheme.danger,
                    onChanged: (v) => setState(() => _overallFeeling = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('0 😫', style: TextStyle(color: AppTheme.danger, fontSize: 12)),
                      Text('5 😐', style: TextStyle(color: AppTheme.warning, fontSize: 12)),
                      Text('10 😊', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // P3.1: Bristol Dışkı Skalası
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💩 Bristol Dışkı Skalası',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      if (_bristolStoolType != null)
                        TextButton(
                          onPressed: () =>
                              setState(() => _bristolStoolType = null),
                          child: const Text('Temizle',
                              style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bağırsak hareket tipinizi seçin (IBS-C / IBS-D takibi için)',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _bristolTypes.map((item) {
                      final type = item['type'] as int;
                      final isSelected = _bristolStoolType == type;
                      return InkWell(
                        onTap: () => setState(() => _bristolStoolType = isSelected ? null : type),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 72) / 2,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryGreen.withOpacity(0.15)
                                : AppTheme.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : AppTheme.divider,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(item['icon'] as String, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Tip $type',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: isSelected ? AppTheme.primaryGreen : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['desc'] as String,
                                style: const TextStyle(
                                    fontSize: 10, color: AppTheme.textSecondary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // P3.3: Semptom Süresi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('⏱️ Ne Kadar Sürdü?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['< 1 saat', '1-3 saat', '3-6 saat', 'Tüm gün'].map((dur) {
                      final selected = _symptomDuration == dur;
                      return ChoiceChip(
                        label: Text(dur),
                        selected: selected,
                        selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                        onSelected: (v) => setState(() => _symptomDuration = v ? dur : ''),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // P3.2: Enerji & Uyku Kalitesi
          SwitchListTile(
            title: const Text('Enerji & Uyku Takibi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Günlük enerji ve uyku kaliteni kaydet'),
            value: _showLifestyle,
            onChanged: (v) => setState(() => _showLifestyle = v),
          ),
          if (_showLifestyle) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('⚡ Enerji Seviyesi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_energyLevel.toInt()} / 10',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _energyLevel,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      activeColor: Colors.amber,
                      onChanged: (v) => setState(() => _energyLevel = v),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('🌙 Uyku Kalitesi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${_sleepQuality.toInt()} / 10',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Slider(
                      value: _sleepQuality,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      activeColor: Colors.indigo,
                      onChanged: (v) => setState(() => _sleepQuality = v),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Semptom detayları toggle
          SwitchListTile(
            title: const Text('Semptom Detayları Ekle',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Şişkinlik, kramp, ishal, mukus vb.'),
            value: _showSymptomDetails,
            onChanged: (v) => setState(() => _showSymptomDetails = v),
          ),

          if (_showSymptomDetails) ...[
            const SizedBox(height: 8),
            ...(_symptomTypes.map((type) {
              final severity = _symptoms[type];
              final hasSymptom = severity != null;
              return Card(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppTheme.getSymptomColor(type).withOpacity(0.2),
                    child: Icon(
                      _getSymptomIcon(type),
                      color: AppTheme.getSymptomColor(type),
                      size: 20,
                    ),
                  ),
                  title: Text(AppTheme.getSymptomLabel(type)),
                  subtitle: hasSymptom
                      ? Text('Şiddet: ${severity.toInt()}/10',
                          style: TextStyle(
                              color: AppTheme.getSymptomColor(type)))
                      : const Text('Ekle',
                          style: TextStyle(color: AppTheme.textSecondary)),
                  initiallyExpanded: hasSymptom,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Column(
                        children: [
                          Slider(
                            value: severity ?? 5,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            activeColor: AppTheme.getSymptomColor(type),
                            onChanged: (v) => setState(
                                () => _symptoms[type] = v),
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() => _symptoms.remove(type));
                                },
                                child: const Text('Kaldır',
                                    style:
                                        TextStyle(color: AppTheme.danger)),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(
                                      () => _symptoms[type] = severity ?? 5);
                                },
                                child: Text(
                                    'Ekle (${(severity ?? 5).toInt()}/10)'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })),
          ],

          const SizedBox(height: 16),

          // Tarih & Saat
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _loggedAt,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                    );
                    if (date != null) {
                      setState(() {
                        _loggedAt = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          _loggedAt.hour,
                          _loggedAt.minute,
                        );
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(DateFormat('dd.MM.yyyy').format(_loggedAt)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_loggedAt),
                    );
                    if (time != null) {
                      setState(() {
                        _loggedAt = DateTime(
                          _loggedAt.year,
                          _loggedAt.month,
                          _loggedAt.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                  icon: const Icon(Icons.access_time, size: 16),
                  label: Text(DateFormat('HH:mm').format(_loggedAt)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notlar
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notlar (isteğe bağlı)',
              hintText: 'Bugün özel bir durum var mıydı? Stres, hareket vs.',
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  IconData _getSymptomIcon(String type) {
    switch (type) {
      case 'sislik':
        return Icons.circle_outlined;
      case 'kramp':
        return Icons.flash_on;
      case 'ishal':
        return Icons.water_drop;
      case 'kabizlik':
        return Icons.block;
      case 'gaz':
        return Icons.air;
      case 'bulanti':
        return Icons.sentiment_very_dissatisfied;
      case 'reflu':
        return Icons.local_fire_department;
      case 'yorgunluk':
        return Icons.battery_alert;
      case 'mukus':
        return Icons.opacity;
      case 'acil_tuvalet_ihtiyaci':
        return Icons.directions_run;
      default:
        return Icons.help;
    }
  }
}
