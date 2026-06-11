import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/presination/calculator_display.dart';
import 'package:state_manager/features/calculator/presination/calculator_history_button.dart';
import 'package:state_manager/features/calculator/presination/calculator_keyboard.dart';
import 'package:state_manager/features/calculator/presination/calculator_theme_switch.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            // Верхняя панель с переключателем темы и историей
            CalculatorTopBar(),

            // Дисплей калькулятора
            Expanded(flex: 2, child: CalculatorDisplay()),

            // Клавиатура калькулятора
            Expanded(flex: 5, child: CalculatorKeyboard()),
          ],
        ),
      ),
    );
  }
}

// Верхняя панель
class CalculatorTopBar extends ConsumerWidget {
  const CalculatorTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Здесь можно добавить логотип или название
          Text(
            'Калькулятор',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              CalculatorHistoryButton(),
              SizedBox(width: 8),
              CalculatorThemeSwitch(),
            ],
          ),
        ],
      ),
    );
  }
}
