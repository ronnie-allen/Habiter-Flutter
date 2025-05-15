import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  const MyHeatMap({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Custom colors for light/dark mode
    final defaultColor =
        isDark ? theme.colorScheme.secondary.withOpacity(0.3) : theme.colorScheme.secondary;
    final textColor = isDark ? Colors.white : Colors.black;

    final colorsets = {
      1: isDark ? Colors.green.shade800 : Colors.green.shade200,
      2: isDark ? Colors.green.shade700 : Colors.green.shade300,
      3: isDark ? Colors.green.shade600 : Colors.green.shade400,
      4: isDark ? Colors.green.shade500 : Colors.green.shade500,
      5: isDark ? Colors.green.shade400 : Colors.green.shade600,
      6: isDark ? Colors.green.shade300 : Colors.green.shade700,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: HeatMap(
          startDate: startDate,
          datasets: datasets,
          colorMode: ColorMode.color,
          defaultColor: defaultColor,
          textColor: textColor,
          showColorTip: false,
          showText: true,
          scrollable: true,
          size: 30,
          colorsets: colorsets,
        ),
      ),
    );
  }
}
