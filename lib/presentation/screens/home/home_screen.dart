import 'package:flutter/material.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../data/models/mood_entry.dart';
import '../../widgets/pixel_grid.dart';
import '../entry/entry_detail_screen.dart';
import '../entry/add_entry_screen.dart';
import '../../../core/utils/date_utils.dart' as app_date_utils;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MoodRepository _repository = MoodRepository();
  DateTime _currentMonth = DateTime.now();
  List<MoodEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    await _repository.initialize();
    _loadEntriesForCurrentMonth();

    // Écouter les changements dans le repository
    _repository.entriesStream.listen((_) {
      _loadEntriesForCurrentMonth();
    });
  }

  void _loadEntriesForCurrentMonth() {
    setState(() {
      _entries = _repository.getEntriesForMonth(_currentMonth);
      _isLoading = false;
    });
  }

  void _navigateToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _loadEntriesForCurrentMonth();
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _loadEntriesForCurrentMonth();
    });
  }

  void _onDayTap(DateTime date) async {
    final entry = _repository.getEntryByDate(date);

    if (entry != null) {
      // Si une entrée existe pour cette date, ouvrir l'écran de détail
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntryDetailScreen(entry: entry),
        ),
      );
    } else {
      // Sinon, ouvrir l'écran d'ajout d'entrée
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEntryScreen(date: date),
        ),
      );
    }

    // Recharger les entrées après le retour
    _loadEntriesForCurrentMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PixelMood'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _currentMonth = DateTime.now();
                _loadEntriesForCurrentMonth();
              });
            },
            tooltip: 'Aujourd\'hui',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMonthNavigator(),
            const SizedBox(height: 20),
            _buildWeekdayLabels(),
            const SizedBox(height: 8),
            PixelGrid(
              entries: _entries,
              month: _currentMonth,
              onDayTap: _onDayTap,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onDayTap(DateTime.now()),
        child: const Icon(Icons.add),
        tooltip: 'Ajouter l\'humeur d\'aujourd\'hui',
      ),
    );
  }

  Widget _buildMonthNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _navigateToPreviousMonth,
        ),
        Text(
          app_date_utils.DateUtils.formatMonth(_currentMonth),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _navigateToNextMonth,
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    final weekdays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) => Text(
        day,
        style: const TextStyle(fontWeight: FontWeight.bold),
      )).toList(),
    );
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}