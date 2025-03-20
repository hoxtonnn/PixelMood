import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

/// Service pour gérer les images (sélection, stockage, suppression)
class ImageService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = Uuid();

  /// Sélectionne une image depuis la galerie
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Compresser légèrement l'image
    );

    if (image != null) {
      return File(image.path);
    }

    return null;
  }

  /// Prend une photo avec l'appareil photo
  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      return File(photo.path);
    }

    return null;
  }

  /// Sauvegarde une image dans le stockage local de l'application
  Future<String> saveImage(File imageFile) async {
    try {
      // Obtenir le répertoire de stockage de l'application
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Générer un nom de fichier unique
      final String fileName = '${_uuid.v4()}.jpg';

      // Chemin où l'image sera sauvegardée
      final String filePath = '${appDir.path}/images/$fileName';

      // Créer le dossier 'images' s'il n'existe pas
      final Directory imageDir = Directory('${appDir.path}/images');
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Copier l'image vers le dossier de l'application
      await imageFile.copy(filePath);

      return filePath;
    } catch (e) {
      print('Erreur lors de la sauvegarde de l\'image: $e');
      rethrow;
    }
  }

  /// Supprime une image du stockage local
  Future<bool> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la suppression de l\'image: $e');
      return false;
    }
  }

  /// Récupère toutes les images associées à une entrée
  Future<List<File>> getImagesForEntry(List<String> imagePaths) async {
    final List<File> images = [];

    for (final path in imagePaths) {
      final File file = File(path);
      if (await file.exists()) {
        images.add(file);
      }
    }

    return images;
  }
}