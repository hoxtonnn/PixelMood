import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../../../data/models/mood_entry.dart';
import '../../../core/constants/colors.dart';

class YearView extends StatelessWidget {
  final int year;
  final List<MoodEntry> entries;
  final Function(int) onMonthSelected;

  const YearView({
    Key? key,
    required this.year,
    required this.entries,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          return _buildMonthCard(context, month);
        },
      ),
    );
  }

  Widget _buildMonthCard(BuildContext context, int month) {
    final monthEntries = entries.where(
            (entry) => entry.date.month == month
    ).toList();

    final dayCount = date_utils.DateUtils.daysInMonth(DateTime(year, month));
    final monthName = _getMonthName(month);

    return GestureDetector(
      onTap: () => onMonthSelected(month),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                monthName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: dayCount,
                  itemBuilder: (context, dayIndex) {
                    final day = dayIndex + 1;
                    final date = DateTime(year, month, day);

                    // Trouver l'entrée pour ce jour s'il en existe une
                    final entry = monthEntries.firstWhere(
                          (e) => date_utils.DateUtils.isSameDay(e.date, date),
                      orElse: () => MoodEntry(
                        date: date,
                        mood: 0,
                        notes: '',
                        photoUrls: [],
                      ),
                    );

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: MoodColors.getColorForMood(entry.mood),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Janv', 'Févr', 'Mars', 'Avr', 'Mai', 'Juin',
      'Juil', 'Août', 'Sept', 'Oct', 'Nov', 'Déc'
    ];
    return monthNames[month - 1];
  }
}