
import 'package:flutter/material.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_backoffice/presentation/widgets/design_system/stir_text.dart';
import 'package:stirred_backoffice/presentation/widgets/pagination/pagination_state.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class _StatisticsRow extends StatelessWidget {
  const _StatisticsRow({required this.data});

  final PaginationState<Drink> data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatisticCard(
            icon: Icons.local_bar,
            iconBackgroundColor: Colors.orange.shade100,
            iconColor: Colors.orange,
            title: 'Total Drinks',
            value: data.items.length.toString(),
            change: '+12% from last month',
            changeColor: Colors.green,
          ),
        ),
        const SizedBox(width: StirSpacings.small16),
        Expanded(
          child: _StatisticCard(
            icon: Icons.star,
            iconBackgroundColor: Colors.green.shade100,
            iconColor: Colors.green,
            title: 'Average Rating',
            value: _calculateAverageRating(data.items),
            change: '+18% from last month',
            changeColor: Colors.green,
          ),
        ),
        const SizedBox(width: StirSpacings.small16),
        Expanded(
          child: _StatisticCard(
            icon: Icons.category,
            iconBackgroundColor: Colors.blue.shade100,
            iconColor: Colors.blue,
            title: 'Categories',
            value: _calculateUniqueCategories(data.items).toString(),
            change: 'No change',
            changeColor: Colors.grey,
          ),
        ),
        const SizedBox(width: StirSpacings.small16),
        Expanded(
          child: _StatisticCard(
            icon: Icons.timer,
            iconBackgroundColor: Colors.red.shade100,
            iconColor: Colors.red,
            title: 'Average Time',
            value: '${_calculateAverageTime(data.items)} min',
            change: '-2 min from last month',
            changeColor: Colors.red,
          ),
        ),
      ],
    );
  }

  String _calculateAverageRating(List<Drink> drinks) {
    if (drinks.isEmpty) return '0.0';
    final totalRating = drinks.fold<double>(0.0, (sum, drink) => sum + drink.averageRating);
    return (totalRating / drinks.length).toStringAsFixed(1);
  }

  int _calculateUniqueCategories(List<Drink> drinks) {
    return drinks.map((drink) => drink.categories).toSet().length;
  }

  int _calculateAverageTime(List<Drink> drinks) {
    if (drinks.isEmpty) return 0;
    final totalTime = drinks.fold<int>(0, (sum, drink) => sum + (drink.recipe?.preparationTime ?? 5));
    return totalTime ~/ drinks.length;
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.change,
    required this.changeColor,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String value;
  final String change;
  final Color changeColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(StirSpacings.small16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: StirText.bodySmall(
                    change,
                    color: changeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: StirSpacings.small16),
            StirText.titleLarge(value),
            const SizedBox(height: 4),
            StirText.bodyMedium(title, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
