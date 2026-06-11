import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/data/models/calculator_button_model.dart';
import 'package:state_manager/features/calculator/data/calculator_provider.dart';

class CalculatorButton extends ConsumerWidget {
  final CalculatorButtonModel model;

  const CalculatorButton({super.key, required this.model});

  Color _getButtonColor(BuildContext context, bool isDark) {
    switch (model.type) {
      case ButtonType.clear:
        return isDark ? Colors.red.shade900 : Colors.red.shade100;
      case ButtonType.delete:
        return isDark ? Colors.orange.shade900 : Colors.orange.shade100;
      case ButtonType.operator:
        return isDark ? Colors.yellow.shade800 : Colors.yellow.shade100;
      case ButtonType.equals:
        return isDark ? Colors.green.shade800 : Colors.green.shade100;
      default:
        return isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    }
  }

  Color _getTextColor(BuildContext context, bool isDark) {
    switch (model.type) {
      case ButtonType.clear:
      case ButtonType.delete:
      case ButtonType.operator:
      case ButtonType.equals:
        return isDark ? Colors.white : Colors.black87;
      default:
        return isDark ? Colors.white : Colors.black87;
    }
  }

  double _getFontSize() {
    switch (model.type) {
      case ButtonType.delete:
        return 24;
      case ButtonType.equals:
        return 32;
      default:
        return 28;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox.expand(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonColor(context, isDark),
          foregroundColor: _getTextColor(context, isDark),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.zero, // Убираем скругление для квадратных кнопок
          ),
          elevation: 0, // Убираем тень
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          final notifier = ref.read(calculatorProvider.notifier);
          notifier.processInput(model.label);
        },
        child: Text(
          model.label,
          style: TextStyle(
            fontSize: _getFontSize(),
            fontWeight: model.type == ButtonType.equals
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
