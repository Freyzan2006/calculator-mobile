import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/presination/calculator_view.dart';

import 'package:state_manager/features/calculator/data/calculator_provider.dart';
import 'package:state_manager/features/history/history_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Calculator App',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const TabBarApp(),
    );
  }
}

// Цвета
const Color primaryYellow = Color(0xFFFFD600);
const Color darkGrey = Color(0xFF1E1E1E);

// Светлая тема
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryYellow,
  scaffoldBackgroundColor: Colors.white,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: primaryYellow,
    foregroundColor: Colors.black87,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryYellow,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);

// Тёмная тема
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryYellow,
  scaffoldBackgroundColor: darkGrey,
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: darkGrey,
    foregroundColor: primaryYellow,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryYellow,
      foregroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);

class TabBarApp extends ConsumerStatefulWidget {
  const TabBarApp({super.key});

  @override
  ConsumerState<TabBarApp> createState() => _TabBarAppState();
}

class _TabBarAppState extends ConsumerState<TabBarApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.calculate), text: 'Calculator'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.light_mode,
                    size: 20,
                    color: isDarkMode ? Colors.grey : primaryYellow,
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).state = value;
                    },
                    activeColor: primaryYellow,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.dark_mode,
                    size: 20,
                    color: isDarkMode ? primaryYellow : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [CalculatorView(), HistoryView()],
      ),
    );
  }
}
