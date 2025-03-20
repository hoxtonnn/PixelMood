import 'package:intl/intl.dart';

/// Utilitaires pour manipuler les dates dans l'application
class DateUtils {
  /// Formate une date pour l'affichage en format court
  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formate une date pour l'affichage en format long
  static String formatLongDate(DateTime date) {
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date);
  }

  /// Formate une date pour l'affichage du mois seulement
  static String formatMonth(DateTime date) {
    return DateFormat('MMMM yyyy', 'fr_FR').format(date);
  }

  /// Retourne le premier jour du mois
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Retourne le dernier jour du mois
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Retourne le nombre de jours dans un mois
  static int daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// Retourne le premier jour de l'année
  static DateTime firstDayOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Retourne le dernier jour de l'année
  static DateTime lastDayOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  /// Vérifie si deux dates sont le même jour
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Vérifie si une date est aujourd'hui
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  /// Génère une liste de tous les jours d'un mois
  static List<DateTime> daysInMonthList(DateTime date) {
    final first = firstDayOfMonth(date);
    final dayCount = daysInMonth(date);

    return List.generate(
      dayCount,
          (index) => DateTime(first.year, first.month, index + 1),
    );
  }

  /// Génère une grille de jours incluant les jours du mois précédent et suivant
  /// pour avoir une grille complète commençant le lundi
  static List<DateTime?> getMonthGrid(DateTime month) {
    final List<DateTime?> days = [];

    final firstDay = firstDayOfMonth(month);
    final lastDay = lastDayOfMonth(month);

    // Déterminer le nombre de jours à ajouter avant le premier jour du mois
    // pour commencer la grille au lundi
    int startOffset = firstDay.weekday - 1; // Lundi = 1, Dimanche = 7
    if (startOffset < 0) startOffset = 6; // Ajustement pour commencer la semaine le lundi

    // Ajouter les jours du mois précédent
    for (int i = startOffset - 1; i >= 0; i--) {
      days.add(firstDay.subtract(Duration(days: i + 1)));
    }

    // Ajouter tous les jours du mois actuel
    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }

    // Calculer combien de jours du mois suivant sont nécessaires pour compléter la grille
    int endOffset = 42 - days.length; // 42 = 6 semaines * 7 jours

    // Ajouter les jours du mois suivant
    for (int i = 0; i < endOffset; i++) {
      days.add(lastDay.add(Duration(days: i + 1)));
    }

    return days;
  }

  /// Générer une liste des 12 mois de l'année
  static List<DateTime> monthsOfYear(int year) {
    return List.generate(
      12,
          (index) => DateTime(year, index + 1, 1),
    );
  }
}