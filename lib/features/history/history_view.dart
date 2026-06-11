import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_manager/features/calculator/data/calculator_provider.dart';
import 'package:state_manager/main.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(calculatorProvider).history;
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      body: history.isEmpty
          ? _buildEmptyHistory(context, isDarkMode)
          : _buildHistoryList(context, ref, history, isDarkMode),
    );
  }

  Widget _buildEmptyHistory(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'История пуста',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Выполните вычисления на калькуляторе',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    WidgetRef ref,
    List<String> history,
    bool isDarkMode,
  ) {
    return Column(
      children: [
        // Заголовок с кнопкой очистки
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'История вычислений',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  _showClearHistoryDialog(context, ref);
                },
                tooltip: 'Очистить историю',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Список истории
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final calculation = history[index];
              return _buildHistoryItem(
                context,
                ref,
                calculation,
                index,
                history.length,
                isDarkMode,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    WidgetRef ref,
    String calculation,
    int index,
    int totalCount,
    bool isDarkMode,
  ) {
    final parts = calculation.split(' = ');
    final expression = parts[0];
    final result = parts[1];

    return Dismissible(
      key: Key(calculation),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(calculatorProvider.notifier).clearHistory();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Запись удалена'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: primaryYellow.withOpacity(0.2),
            child: Text(
              (totalCount - index).toString(),
              style: const TextStyle(
                color: primaryYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            expression,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '= $result',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  // Переключиться на калькулятор и вставить результат
                  _useResultInCalculator(ref, result);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Результат скопирован в калькулятор'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                tooltip: 'Использовать результат',
                style: IconButton.styleFrom(
                  backgroundColor: primaryYellow.withOpacity(0.1),
                  foregroundColor: primaryYellow,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  // Копировать результат в буфер обмена
                  _copyToClipboard(context, result);
                },
                tooltip: 'Копировать результат',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  foregroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          onTap: () {
            // Использовать результат при нажатии
            _useResultInCalculator(ref, result);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Результат скопирован в калькулятор'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Очистить историю'),
          content: const Text(
            'Вы уверены, что хотите удалить всю историю вычислений?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                ref.read(calculatorProvider.notifier).clearHistory();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('История очищена'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Очистить'),
            ),
          ],
        );
      },
    );
  }

  void _useResultInCalculator(WidgetRef ref, String result) {
    final notifier = ref.read(calculatorProvider.notifier);
    notifier.clearAll();
    notifier.processInput(result);
  }

  void _copyToClipboard(BuildContext context, String text) {
    // Копирование в буфер обмена
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Скопировано в буфер обмена'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
