import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/theme.dart';
import 'data/repositories/mood_repository.dart';
import 'services/storage_service.dart';
import 'services/image_service.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  // Assure que Flutter est initialisé
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser l'internationalisation pour les dates en français
  await initializeDateFormatting('fr_FR', null);

  // Définir l'orientation portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const PixelMoodApp());
}

class PixelMoodApp extends StatelessWidget {
  const PixelMoodApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Fournir les services et référentiels nécessaires
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        Provider<ImageService>(
          create: (_) => ImageService(),
        ),
        ProxyProvider<StorageService, MoodRepository>(
          update: (_, storageService, __) => MoodRepository(storageService),
        ),
      ],
      child: MaterialApp(
        title: 'PixelMood',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}