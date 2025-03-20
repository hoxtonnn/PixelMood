import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../data/models/mood_entry.dart';
import '../../../data/models/mood_type.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../widgets/mood_selector.dart';
import '../../widgets/note_field.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../services/image_service.dart';

class AddEntryScreen extends StatefulWidget {
  final DateTime date;
  final MoodEntry? existingEntry;

  const AddEntryScreen({
    Key? key,
    required this.date,
    this.existingEntry,
  }) : super(key: key);

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  late final MoodRepository _repository;
  late final ImageService _imageService;

  MoodType? _selectedMood;
  String? _note;
  List<String> _photoUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _repository = MoodRepository()..initialize();
    _imageService = ImageService();

    // Si nous éditons une entrée existante, initialiser les valeurs
    if (widget.existingEntry != null) {
      _selectedMood = widget.existingEntry!.mood;
      _note = widget.existingEntry!.note;
      _photoUrls = List.from(widget.existingEntry!.photoUrls);
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        // Sauvegarder l'image dans le stockage local
        final String savedPath = await _imageService.saveImage(File(image.path));
        setState(() {
          _photoUrls.add(savedPath);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la prise de photo: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Sauvegarder l'image dans le stockage local
        final String savedPath = await _imageService.saveImage(File(image.path));
        setState(() {
          _photoUrls.add(savedPath);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection d\'image: $e')),
      );
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photoUrls.removeAt(index);
    });
  }

  Future<void> _saveEntry() async {
    // Vérifier qu'une humeur est sélectionnée
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une humeur')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Créer une nouvelle entrée ou mettre à jour l'existante
      final entry = widget.existingEntry != null
          ? widget.existingEntry!.update(
        mood: _selectedMood,
        note: _note,
        photoUrls: _photoUrls,
      )
          : MoodEntry.create(
        date: widget.date,
        mood: _selectedMood!,
        note: _note,
        photoUrls: _photoUrls,
      );

      // Enregistrer l'entrée
      await _repository.saveEntry(entry);

      // Fermer l'écran
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingEntry != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier l\'entrée' : 'Nouvelle entrée'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              app_date_utils.DateUtils.formatLongDate(widget.date),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Sélecteur d'humeur
            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),
            const SizedBox(height: 24),

            // Champ de note
            NoteField(
              initialValue: _note,
              onChanged: (value) {
                _note = value;
              },
            ),
            const SizedBox(height: 24),

            // Section photos
            _buildPhotoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Photos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        // Boutons pour ajouter des photos
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Prendre une photo'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Galerie'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Affichage des photos
        if (_photoUrls.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _photoUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_photoUrls[index]),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        else
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Aucune photo ajoutée'),
            ),
          ),
      ],
    );
  }
}