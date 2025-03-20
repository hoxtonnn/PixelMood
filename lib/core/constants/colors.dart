import 'package:flutter/material.dart';

/// Définition des couleurs principales pour les différentes humeurs
class MoodColors {
  // Couleurs pour les 5 types d'humeur
  static const Color excellent = Color(0xFF4CAF50);  // Vert vif
  static const Color good = Color(0xFF8BC34A);       // Vert clair
  static const Color neutral = Color(0xFFFFC107);    // Jaune
  static const Color bad = Color(0xFFFF9800);        // Orange
  static const Color terrible = Color(0xFFF44336);   // Rouge

  // Couleur pour les jours sans entrée
  static const Color noEntry = Color(0xFFE0E0E0);    // Gris clair

  // Obtenir la couleur selon le type d'humeur
  static Color getColorForMood(int moodValue) {
    switch (moodValue) {
      case 5:
        return excellent;
      case 4:
        return good;
      case 3:
        return neutral;
      case 2:
        return bad;
      case 1:
        return terrible;
      default:
        return noEntry;
    }
  }

  // Obtenir le nom de l'humeur selon la valeur
  static String getMoodName(int moodValue) {
    switch (moodValue) {
      case 5:
        return 'Excellent';
      case 4:
        return 'Bon';
      case 3:
        return 'Neutre';
      case 2:
        return 'Mauvais';
      case 1:
        return 'Terrible';
      default:
        return 'Non défini';
    }
  }
}

/// Couleurs générales de l'application
class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
}