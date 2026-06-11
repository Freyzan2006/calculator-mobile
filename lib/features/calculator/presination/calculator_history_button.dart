import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/data/calculator_provider.dart';

class CalculatorHistoryButton extends ConsumerWidget {
  const CalculatorHistoryButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(calculatorProvider).history;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.history),
          iconSize: 28,
          onPressed: () {
            _showHistoryDialog(context, ref, history);
          },
          tooltip: 'История вычислений',
        ),
        if (history.isNotEmpty)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                history.length.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showHistoryDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> history,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'История вычислений',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.history),
              ],
            ),
          ),
          content: history.isEmpty
              ? const SizedBox(
                  width: 300,
                  height: 200,
                  child: Center(
                    child: Text(
                      'История пуста',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : SizedBox(
                  width: 300,
                  height: 400,
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            (history.length - index).toString(),
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        title: Text(
                          history[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () {
                            ref
                                .read(calculatorProvider.notifier)
                                .clearHistory();
                            Navigator.pop(context);
                          },
                        ),
                        onTap: () {
                          final calculation = history[index];
                          final result = calculation.split(' = ')[1];
                          ref.read(calculatorProvider.notifier).clearAll();
                          ref
                              .read(calculatorProvider.notifier)
                              .processInput(result);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
            if (history.isNotEmpty)
              TextButton(
                onPressed: () {
                  ref.read(calculatorProvider.notifier).clearHistory();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Очистить всё'),
              ),
          ],
        );
      },
    );
  }
}
