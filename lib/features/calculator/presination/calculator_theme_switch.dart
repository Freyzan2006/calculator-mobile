import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/data/calculator_provider.dart';

class CalculatorThemeSwitch extends ConsumerWidget {
  const CalculatorThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
      ),
      child: IconButton(
        icon: Icon(
          isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: isDarkMode ? Colors.yellow : Colors.grey.shade700,
        ),
        onPressed: () {
          ref.read(themeProvider.notifier).state = !isDarkMode;
        },
        tooltip: isDarkMode ? 'Светлая тема' : 'Тёмная тема',
      ),
    );
  }
}
