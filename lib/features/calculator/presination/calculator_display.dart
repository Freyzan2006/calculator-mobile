import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/data/calculator_provider.dart';

class CalculatorDisplay extends ConsumerWidget {
  const CalculatorDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Выражение
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: calculatorState.expression.isEmpty ? 0.5 : 1,
            child: Text(
              calculatorState.expression.isEmpty
                  ? '0'
                  : calculatorState.expression,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.normal,
                color: calculatorState.isError
                    ? Colors.red
                    : Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),

          // Результат
          SizedBox(
            child: Text(
              calculatorState.result,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
