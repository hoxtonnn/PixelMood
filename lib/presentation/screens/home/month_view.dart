import 'package:flutter/material.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../../../data/models/mood_entry.dart';
import '../../../core/constants/colors.dart';

class MonthView extends StatelessWidget {
  final DateTime month;
  final List<MoodEntry> entries;
  final Function(DateTime) onDaySelected;

  const MonthView({
    Key? key,
    required this.month,
    required this.entries,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = date_utils.DateUtils.getMonthGrid(month);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Jours de la semaine
          Row(
            children: _buildWeekdayLabels(),
          ),

          // Grille des jours
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                if (day == null) {
                  return Container(); // Cellule vide
                }

                final isCurrentMonth = day.month == month.month;

                // Trouver l'entrée pour ce jour s'il en existe une
                final entry = entries.firstWhere(
                      (entry) => date_utils.DateUtils.isSameDay(entry.date, day),
                  orElse: () => MoodEntry(
                    date: day,
                    mood: 0,
                    notes: '',
                    photoUrls: [],
                  ),
                );

                return _buildDayCell(context, day, entry, isCurrentMonth);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeekdayLabels() {
    const weekdays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return List.generate(
      7,
          (index) => Expanded(
        child: Center(
          child: Text(
            weekdays[index],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime day, MoodEntry entry, bool isCurrentMonth) {
    final isToday = date_utils.DateUtils.isToday(day);
    final hasEntry = entry.mood > 0;

    return GestureDetector(
      onTap: () => onDaySelected(day),
      child: Card(
        margin: const EdgeInsets.all(2),
        color: hasEntry
            ? MoodColors.getColorForMood(entry.mood)
            : isCurrentMonth
            ? Colors.white
            : Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isToday
              ? const BorderSide(color: Colors.black, width: 2)
              : BorderSide.none,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: hasEntry
                    ? Colors.white
                    : isCurrentMonth
                    ? Colors.black
                    : Colors.grey.shade700,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (hasEntry && entry.photoUrls.isNotEmpty)
              const Icon(
                Icons.photo,
                size: 12,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}