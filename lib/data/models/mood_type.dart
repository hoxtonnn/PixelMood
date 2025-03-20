/// Énumération des types d'humeurs disponibles
enum MoodType {
  terrible(1, 'Terrible'),
  bad(2, 'Mauvais'),
  neutral(3, 'Neutre'),
  good(4, 'Bon'),
  excellent(5, 'Excellent');

  final int value;
  final String label;

  const MoodType(this.value, this.label);

  /// Convertit une valeur numérique en MoodType
  static MoodType fromValue(int value) {
    return MoodType.values.firstWhere(
          (type) => type.value == value,
      orElse: () => MoodType.neutral,
    );
  }

  /// Retourne la liste des types d'humeur pour l'affichage
  static List<MoodType> get displayList => [
    MoodType.excellent,
    MoodType.good,
    MoodType.neutral,
    MoodType.bad,
    MoodType.terrible,
  ];
}