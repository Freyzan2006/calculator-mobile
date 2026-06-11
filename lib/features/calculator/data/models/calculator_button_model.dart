enum ButtonType { number, operator, clear, delete, equals }

class CalculatorButtonModel {
  final String label;
  final ButtonType type;
  final bool isWide;

  const CalculatorButtonModel({
    required this.label,
    required this.type,
    this.isWide = false,
  });
}
