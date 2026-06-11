import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:math_expressions/math_expressions.dart';

// Состояние калькулятора
class CalculatorState {
  final String expression;
  final String result;
  final List<String> history;
  final bool isError;

  const CalculatorState({
    required this.expression,
    required this.result,
    required this.history,
    this.isError = false,
  });

  CalculatorState copyWith({
    String? expression,
    String? result,
    List<String>? history,
    bool? isError,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
      isError: isError ?? this.isError,
    );
  }

  factory CalculatorState.initial() {
    return const CalculatorState(
      expression: '',
      result: '0',
      history: [],
      isError: false,
    );
  }
}

// Провайдер состояния калькулятора
final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
      return CalculatorNotifier();
    });

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(CalculatorState.initial());

  // Обработка ввода кнопок
  void processInput(String input) {
    if (state.isError && input != 'C') {
      clearAll();
      return;
    }

    switch (input) {
      case 'C':
        clearAll();
        break;
      case '⌫':
        deleteLast();
        break;
      case '=':
        calculateResult();
        break;
      default:
        addToExpression(input);
        break;
    }
  }

  // Добавление символа в выражение
  void addToExpression(String value) {
    final newExpression = state.expression + value;

    // Выражение ещё не закончено (заканчивается оператором или точкой) -
    // не пытаемся вычислить, иначе получим ошибку парсинга
    if (_isIncomplete(newExpression)) {
      state = state.copyWith(expression: newExpression, isError: false);
      return;
    }

    final newResult = _evaluateExpression(newExpression);

    state = state.copyWith(
      expression: newExpression,
      result: newResult,
      isError: newResult == 'Ошибка',
    );
  }

  // Удаление последнего символа
  void deleteLast() {
    if (state.expression.isEmpty) return;

    final newExpression = state.expression.substring(
      0,
      state.expression.length - 1,
    );

    if (newExpression.isEmpty) {
      state = state.copyWith(
        expression: newExpression,
        result: '0',
        isError: false,
      );
      return;
    }

    if (_isIncomplete(newExpression)) {
      state = state.copyWith(expression: newExpression, isError: false);
      return;
    }

    final newResult = _evaluateExpression(newExpression);

    state = state.copyWith(
      expression: newExpression,
      result: newResult,
      isError: newResult == 'Ошибка',
    );
  }

  // Проверка, является ли выражение незавершённым
  // (заканчивается оператором или точкой)
  bool _isIncomplete(String expression) {
    if (expression.isEmpty) return false;
    const operators = ['+', '-', '×', '÷', '%', '.'];
    return operators.contains(expression[expression.length - 1]);
  }

  // Полная очистка
  void clearAll() {
    state = state.copyWith(expression: '', result: '0', isError: false);
  }

  // Вычисление результата
  void calculateResult() {
    if (state.expression.isEmpty) return;

    // Убираем незавершённый оператор/точку в конце перед вычислением
    String expression = state.expression;
    while (_isIncomplete(expression)) {
      expression = expression.substring(0, expression.length - 1);
    }
    if (expression.isEmpty) return;

    final result = _evaluateExpression(expression);

    if (result != 'Ошибка') {
      // Сохраняем в историю
      _addToHistory('$expression = $result');

      state = state.copyWith(
        expression: result,
        result: result,
        isError: false,
      );
    } else {
      state = state.copyWith(isError: true);
    }
  }

  // Добавление в историю
  void _addToHistory(String calculation) {
    final newHistory = [calculation, ...state.history];
    // Оставляем только последние 20 записей
    if (newHistory.length > 20) {
      newHistory.removeLast();
    }
    state = state.copyWith(history: newHistory);
  }

  // Очистка истории
  void clearHistory() {
    state = state.copyWith(history: []);
  }

  // Вычисление выражения
  String _evaluateExpression(String expression) {
    try {
      if (expression.isEmpty) return '0';

      // Подготавливаем выражение
      String formattedExpression = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100');

      // Проверка на деление на ноль
      if (formattedExpression.contains('/0')) {
        return 'Ошибка';
      }

      final parser = Parser();
      final Expression exp = parser.parse(formattedExpression);
      final ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Форматируем результат
      if (eval.isNaN || eval.isInfinite) {
        return 'Ошибка';
      }

      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      } else {
        // Округляем до 8 знаков
        String result = eval.toStringAsFixed(8);
        // Убираем лишние нули
        result = result.replaceAll(RegExp(r'0+$'), '');
        result = result.replaceAll(RegExp(r'\.$'), '');
        return result;
      }
    } catch (e) {
      return 'Ошибка';
    }
  }
}

// Провайдер для темы
final themeProvider = StateProvider<bool>((ref) => false);
