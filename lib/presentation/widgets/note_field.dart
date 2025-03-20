import 'package:flutter/material.dart';

/// Widget pour saisir des notes textuelles
class NoteField extends StatelessWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final int maxLines;

  const NoteField({
    Key? key,
    this.initialValue,
    required this.onChanged,
    this.maxLines = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Notes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        TextField(
          controller: TextEditingController(text: initialValue)..selection = TextSelection.fromPosition(
            TextPosition(offset: initialValue?.length ?? 0),
          ),
          decoration: const InputDecoration(
            hintText: 'Comment s\'est passée votre journée ?',
            border: OutlineInputBorder(),
          ),
          maxLines: maxLines,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}