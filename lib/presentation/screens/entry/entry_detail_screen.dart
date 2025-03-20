import 'package:flutter/material.dart';
import 'dart:io';
import '../../../data/models/mood_entry.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;
import 'add_entry_screen.dart';

class EntryDetailScreen extends StatelessWidget {
  final MoodEntry entry;

  const EntryDetailScreen({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(app_date_utils.DateUtils.formatShortDate(entry.date)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEntryScreen(
                    date: entry.date,
                    existingEntry: entry,
                  ),
                ),
              ).then((_) => Navigator.pop(context));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec date et humeur
            _buildHeader(context),
            const SizedBox(height: 24),

            // Notes
            if (entry.note != null && entry.note!.isNotEmpty)
              _buildNotes(context),

            // Photos
            if (entry.photoUrls.isNotEmpty)
              _buildPhotos(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Cercle coloré représentant l'humeur
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: MoodColors.getColorForMood(entry.mood.value),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app_date_utils.DateUtils.formatLongDate(entry.date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Humeur: ${entry.mood.label}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            entry.note!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPhotos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),

        // Grille de photos
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: entry.photoUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Afficher la photo en plein écran
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _FullScreenPhoto(
                      photoUrl: entry.photoUrls[index],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(entry.photoUrls[index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Widget pour afficher une photo en plein écran
class _FullScreenPhoto extends StatelessWidget {
  final String photoUrl;

  const _FullScreenPhoto({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.file(
            File(photoUrl),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}