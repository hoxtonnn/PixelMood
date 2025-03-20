import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/mood_entry.dart';
import '../models/mood_type.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;

/// Repository pour gérer les opérations CRUD sur les entrées d'humeur
class MoodRepository {
  static const String _storageKey = 'pixelmood_entries';

  late SharedPreferences _prefs;
  final List<MoodEntry> _entries = [];
  final _entriesStreamController = StreamController<List<MoodEntry>>.broadcast();

  /// Stream d'entrées d'humeur pour observer les changements
  Stream<List<MoodEntry>> get entriesStream => _entriesStreamController.stream;

  /// Liste des entrées actuelles
  List<MoodEntry> get entries => List.unmodifiable(_entries);

  /// Initialise le repository
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadEntries();
    _notifyListeners();
  }

  /// Charge les entrées depuis le stockage local
  Future<void> _loadEntries() async {
    final String? entriesJson = _prefs.getString(_storageKey);
    if (entriesJson != null) {
      final List<dynamic> decoded = jsonDecode(entriesJson);
      _entries.clear();
      _entries.addAll(
        decoded.map((item) => MoodEntry.fromMap(item)).toList(),
      );

      // Trie les entrées par date (plus récentes en premier)
      _entries.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  /// Sauvegarde les entrées dans le stockage local
  Future<void> _saveEntries() async {
    final String entriesJson = jsonEncode(
      _entries.map((entry) => entry.toMap()).toList(),
    );
    await _prefs.setString(_storageKey, entriesJson);
  }

  /// Notifie les auditeurs des changements
  void _notifyListeners() {
    _entriesStreamController.add(_entries);
  }

  /// Ajoute ou met à jour une entrée d'humeur
  Future<void> saveEntry(MoodEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);

    if (index >= 0) {
      _entries[index] = entry;
    } else {
      _entries.add(entry);
    }

    // Trie les entrées par date (plus récentes en premier)
    _entries.sort((a, b) => b.date.compareTo(a.date));

    await _saveEntries();
    _notifyListeners();
  }

  /// Supprime une entrée d'humeur
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((entry) => entry.id == id);
    await _saveEntries();
    _notifyListeners();
  }

  /// Obtient une entrée par son ID
  MoodEntry? getEntryById(String id) {
    try {
      return _entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtient une entrée par sa date
  MoodEntry? getEntryByDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    try {
      return _entries.firstWhere(
            (entry) => app_date_utils.DateUtils.isSameDay(entry.date, normalizedDate),
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtient toutes les entrées pour un mois donné
  List<MoodEntry> getEntriesForMonth(DateTime month) {
    final year = month.year;
    final monthNum = month.month;

    return _entries.where((entry) {
      return entry.date.year == year && entry.date.month == monthNum;
    }).toList();
  }

  /// Obtient toutes les entrées pour une année donnée
  List<MoodEntry> getEntriesForYear(int year) {
    return _entries.where((entry) => entry.date.year == year).toList();
  }

  /// Dispose du repository
  void dispose() {
    _entriesStreamController.close();
  }
}