import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';

class SymptomFormScreen extends ConsumerStatefulWidget {
  final dynamic existingLog;
  final List<dynamic>? existingEntries;

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
  double _overallFeeling = 5;
  final Map<String, double> _symptoms = {};
  bool _showSymptomDetails = false;

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
          _symptoms[entry.symptomType as String] =
              (entry.severity as double?) ?? 5;
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
    final notes =
        _notesController.text.isNotEmpty ? _notesController.text : null;
    final symptoms = _symptoms.entries
        .map((e) => <String, dynamic>{'type': e.key, 'severity': e.value})
        .toList();

    if (_isEditing) {
      await repo.updateSymptomLog(
        id: widget.existingLog!.id,
        loggedAt: _loggedAt,
        overallFeeling: _overallFeeling,
        notes: notes,
        symptoms: symptoms,
      );
    } else {
      await repo.addSymptomLog(
        loggedAt: _loggedAt,
        overallFeeling: _overallFeeling,
        notes: notes,
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
                    children: [
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

          // Semptom detayları toggle
          SwitchListTile(
            title: const Text('Semptom Detayları Ekle',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Şişkinlik, kramp, ishal vb.'),
            value: _showSymptomDetails,
            activeColor: AppTheme.primaryGreen,
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
                      setState(() => _loggedAt = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            _loggedAt.hour,
                            _loggedAt.minute,
                          ));
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(DateFormat('dd.MM.yyyy').format(_loggedAt)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_loggedAt),
                    );
                    if (time != null) {
                      setState(() => _loggedAt = DateTime(
                            _loggedAt.year,
                            _loggedAt.month,
                            _loggedAt.day,
                            time.hour,
                            time.minute,
                          ));
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(DateFormat('HH:mm').format(_loggedAt)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notlar
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notlar (opsiyonel)',
              hintText: 'örn: Stresli bir gündü, az su içtim...',
              prefixIcon: Icon(Icons.notes),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 30),

          // Kaydet
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(_isEditing ? 'Güncelle' : 'Semptomu Kaydet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
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

  IconData _getSymptomIcon(String type) {
    switch (type) {
      case 'sislik':
        return Icons.air;
      case 'kramp':
        return Icons.pinch;
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
      default:
        return Icons.help;
    }
  }
}
