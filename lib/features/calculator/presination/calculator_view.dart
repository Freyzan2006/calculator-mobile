import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/presination/calculator_display.dart';
import 'package:state_manager/features/calculator/presination/calculator_history_button.dart';
import 'package:state_manager/features/calculator/presination/calculator_keyboard.dart';

class CalculatorView extends ConsumerWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя панель с историей
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: CalculatorHistoryButton(),
              ),
            ),
            // Дисплей калькулятора
            const Expanded(flex: 2, child: CalculatorDisplay()),
            // Клавиатура калькулятора
            const Expanded(flex: 5, child: CalculatorKeyboard()),
          ],
        ),
      ),
    );
  }
}
