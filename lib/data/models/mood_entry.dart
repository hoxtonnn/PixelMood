import 'mood_type.dart';

/// Modèle représentant une entrée d'humeur journalière
class MoodEntry {
  final String id;
  final DateTime date;
  final MoodType mood;
  final String? note;
  final List<String> photoUrls;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoodEntry({
    required this.id,
    required this.date,
    required this.mood,
    this.note,
    this.photoUrls = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crée une nouvelle entrée avec les valeurs par défaut
  factory MoodEntry.create({
    required DateTime date,
    required MoodType mood,
    String? note,
    List<String> photoUrls = const [],
  }) {
    final now = DateTime.now();
    return MoodEntry(
      id: '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      date: DateTime(date.year, date.month, date.day),
      mood: mood,
      note: note,
      photoUrls: photoUrls,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Convertit l'entrée en Map pour le stockage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'mood': mood.value,
      'note': note,
      'photoUrls': photoUrls,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Crée une entrée à partir d'une Map
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      mood: MoodType.fromValue(map['mood']),
      note: map['note'],
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  /// Crée une copie de l'entrée avec des champs mis à jour
  MoodEntry copyWith({
    String? id,
    DateTime? date,
    MoodType? mood,
    String? note,
    List<String>? photoUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Met à jour l'entrée avec de nouvelles valeurs
  MoodEntry update({
    MoodType? mood,
    String? note,
    List<String>? photoUrls,
  }) {
    return copyWith(
      mood: mood,
      note: note,
      photoUrls: photoUrls,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'MoodEntry{id: $id, date: $date, mood: ${mood.label}, '
        'note: ${note != null ? '${note!.substring(0, note!.length > 20 ? 20 : note!.length)}...' : 'null'}, '
        'photos: ${photoUrls.length}}';
  }
}