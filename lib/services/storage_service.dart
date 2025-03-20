import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/mood_entry.dart';

/// Service pour gérer le stockage local des entrées d'humeur
class StorageService {
  static const String _entriesKey = 'mood_entries';

  /// Sauvegarde une entrée d'humeur
  Future<bool> saveMoodEntry(MoodEntry entry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getString(_entriesKey) ?? '{}';
      final Map<String, dynamic> entriesMap = json.decode(entriesJson);

      // Créer une clé unique basée sur la date (format: YYYY-MM-DD)
      final String dateKey = _formatDateKey(entry.date);

      // Ajouter ou mettre à jour l'entrée
      entriesMap[dateKey] = entry.toJson();

      // Sauvegarder le JSON mis à jour
      await prefs.setString(_entriesKey, json.encode(entriesMap));
      return true;
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'entrée: $e');
      return false;
    }
  }

  /// Récupère une entrée d'humeur par date
  Future<MoodEntry?> getMoodEntry(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getString(_entriesKey) ?? '{}';
      final Map<String, dynamic> entriesMap = json.decode(entriesJson);

      final String dateKey = _formatDateKey(date);

      if (entriesMap.containsKey(dateKey)) {
        return MoodEntry.fromJson(entriesMap[dateKey]);
      }

      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'entrée: $e');
      return null;
    }
  }

  /// Récupère toutes les entrées d'humeur
  Future<List<MoodEntry>> getAllMoodEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getString(_entriesKey) ?? '{}';
      final Map<String, dynamic> entriesMap = json.decode(entriesJson);

      return entriesMap.values
          .map<MoodEntry>((json) => MoodEntry.fromJson(json))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des entrées: $e');
      return [];
    }
  }

  /// Récupère les entrées d'humeur pour un mois spécifique
  Future<List<MoodEntry>> getMoodEntriesForMonth(int year, int month) async {
    final allEntries = await getAllMoodEntries();

    return allEntries.where((entry) {
      return entry.date.year == year && entry.date.month == month;
    }).toList();
  }

  /// Récupère les entrées d'humeur pour une année spécifique
  Future<List<MoodEntry>> getMoodEntriesForYear(int year) async {
    final allEntries = await getAllMoodEntries();

    return allEntries.where((entry) {
      return entry.date.year == year;
    }).toList();
  }

  /// Supprime une entrée d'humeur
  Future<bool> deleteMoodEntry(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getString(_entriesKey) ?? '{}';
      final Map<String, dynamic> entriesMap = json.decode(entriesJson);

      final String dateKey = _formatDateKey(date);

      if (entriesMap.containsKey(dateKey)) {
        entriesMap.remove(dateKey);
        await prefs.setString(_entriesKey, json.encode(entriesMap));
        return true;
      }

      return false;
    } catch (e) {
      print('Erreur lors de la suppression de l\'entrée: $e');
      return false;
    }
  }

  /// Formate une date en clé (YYYY-MM-DD)
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}