import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../data/models/mood_entry.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;

/// Widget affichant une grille de pixels représentant les humeurs
class PixelGrid extends StatelessWidget {
  final List<MoodEntry> entries;
  final DateTime month;
  final Function(DateTime) onDayTap;
  final double pixelSize;
  final double spacing;

  const PixelGrid({
    Key? key,
    required this.entries,
    required this.month,
    required this.onDayTap,
    this.pixelSize = 40,
    this.spacing = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = app_date_utils.DateUtils.getMonthGrid(month);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        if (day == null) {
          return const SizedBox();
        }

        // Vérifie si une entrée existe pour ce jour
        final entry = entries.firstWhere(
              (e) => app_date_utils.DateUtils.isSameDay(e.date, day),
          orElse: () => MoodEntry.create(
            date: day,
            mood: MoodType.fromValue(0), // Pas d'humeur définie
          ),
        );

        final bool isCurrentMonth = day.month == month.month;
        final bool isToday = app_date_utils.DateUtils.isToday(day);

        return _buildDayPixel(context, day, entry, isCurrentMonth, isToday);
      },
    );
  }

  Widget _buildDayPixel(
      BuildContext context,
      DateTime day,
      MoodEntry entry,
      bool isCurrentMonth,
      bool isToday,
      ) {
    // Définir la couleur de fond selon l'humeur
    Color backgroundColor = MoodColors.getColorForMood(entry.mood.value);

    // Si pas d'entrée pour ce jour, utiliser une couleur grise
    if (entry.mood.value == 0) {
      backgroundColor = MoodColors.noEntry;
    }

    // Réduire l'opacité pour les jours qui ne sont pas du mois courant
    if (!isCurrentMonth) {
      backgroundColor = backgroundColor.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: () => onDayTap(day),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: isToday
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            day.day.toString(),
            style: TextStyle(
              color: _getTextColor(backgroundColor),
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // Détermine la couleur du texte en fonction de la luminosité du fond
  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}