import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../data/models/mood_type.dart';

/// Widget pour sélectionner une humeur
class MoodSelector extends StatelessWidget {
  final MoodType? selectedMood;
  final Function(MoodType) onMoodSelected;

  const MoodSelector({
    Key? key,
    this.selectedMood,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Comment vous sentez-vous aujourd\'hui ?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: MoodType.displayList.map((mood) {
            return _buildMoodOption(context, mood);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodOption(BuildContext context, MoodType mood) {
    final isSelected = selectedMood == mood;

    return GestureDetector(
      onTap: () => onMoodSelected(mood),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: MoodColors.getColorForMood(mood.value),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.black, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ]
                  : null,
            ),
          ),
          Text(
            mood.label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}