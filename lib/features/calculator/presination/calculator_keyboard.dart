import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/data/models/calculator_button_model.dart';
import 'package:state_manager/features/calculator/presination/calculator_button.dart';

class CalculatorKeyboard extends ConsumerWidget {
  const CalculatorKeyboard({super.key});

  // Конфигурация кнопок
  static const List<List<CalculatorButtonModel>> keyboardLayout = [
    // Ряд 1
    [
      CalculatorButtonModel(label: 'C', type: ButtonType.clear),
      CalculatorButtonModel(label: '⌫', type: ButtonType.delete),
      CalculatorButtonModel(label: '%', type: ButtonType.operator),
      CalculatorButtonModel(label: '÷', type: ButtonType.operator),
    ],
    // Ряд 2
    [
      CalculatorButtonModel(label: '7', type: ButtonType.number),
      CalculatorButtonModel(label: '8', type: ButtonType.number),
      CalculatorButtonModel(label: '9', type: ButtonType.number),
      CalculatorButtonModel(label: '×', type: ButtonType.operator),
    ],
    // Ряд 3
    [
      CalculatorButtonModel(label: '4', type: ButtonType.number),
      CalculatorButtonModel(label: '5', type: ButtonType.number),
      CalculatorButtonModel(label: '6', type: ButtonType.number),
      CalculatorButtonModel(label: '-', type: ButtonType.operator),
    ],
    // Ряд 4
    [
      CalculatorButtonModel(label: '1', type: ButtonType.number),
      CalculatorButtonModel(label: '2', type: ButtonType.number),
      CalculatorButtonModel(label: '3', type: ButtonType.number),
      CalculatorButtonModel(label: '+', type: ButtonType.operator),
    ],
    // Ряд 5
    [
      CalculatorButtonModel(label: '0', type: ButtonType.number, isWide: true),
      CalculatorButtonModel(label: '.', type: ButtonType.number),
      CalculatorButtonModel(label: '=', type: ButtonType.equals),
    ],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Рассчитываем размер кнопки на основе ширины экрана
        final buttonSize = (constraints.maxWidth - 8) / 4; // 4 колонки

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: keyboardLayout.map((row) {
              return Expanded(
                child: Row(
                  children: row.map((button) {
                    return Container(
                      margin: const EdgeInsets.all(1), // Минимальный отступ
                      width: button.isWide
                          ? buttonSize * 2 - 2
                          : buttonSize - 2,
                      height: buttonSize - 2,
                      child: CalculatorButton(model: button),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
