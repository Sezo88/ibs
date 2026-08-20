import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/meal_form_screen.dart';
import 'presentation/screens/symptom_form_screen.dart';
import 'presentation/screens/timeline_screen.dart';
import 'presentation/screens/analysis_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/diet_plans_screen.dart';
import 'presentation/providers/app_providers.dart';
import 'data/repositories/app_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: IBSApp()));
}

class IBSApp extends StatelessWidget {
  const IBSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IBS Semptom Takip',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}

/// Ana shell - bottom navigation bar ile
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  bool _seedLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSeed();
  }

  Future<void> _loadSeed() async {
    final repo = ref.read(repositoryProvider);
    await repo.loadSeedData();
    setState(() => _seedLoaded = true);
    ref.read(seedDataLoadedProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_seedLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Veritabanı hazırlanıyor...',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    final screens = [
      const DashboardScreen(),
      const TimelineScreen(),
      const DietPlansScreen(),
      const AnalysisScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            selectedIcon: Icon(Icons.timeline),
            label: 'Zaman Çizelgesi',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Diyet',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
      floatingActionButton: _currentIndex != 4
          ? FloatingActionButton.extended(
              onPressed: () => _showQuickAdd(context),
              icon: const Icon(Icons.add),
              label: const Text('Hızlı Ekle'),
            )
          : null,
    );
  }

  void _showQuickAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Hızlı Kayıt Ekle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryGreen,
                  child: Icon(Icons.restaurant, color: Colors.white),
                ),
                title: const Text('Öğün Ekle'),
                subtitle: const Text('Yemek ve malzeme kaydı'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MealFormScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.warning,
                  child: Icon(Icons.sick_outlined, color: Colors.white),
                ),
                title: const Text('Semptom Ekle'),
                subtitle: const Text('Nasıl hissediyorsun?'),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SymptomFormScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
