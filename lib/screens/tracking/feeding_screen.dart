import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/firebase_service.dart';
import '../../models/activity.dart';

class FeedingScreen extends StatefulWidget {
  const FeedingScreen({super.key});

  @override
  State<FeedingScreen> createState() => _FeedingScreenState();
}

class _FeedingScreenState extends State<FeedingScreen> {
  final _firebaseService = FirebaseService();
  bool _isFeeding = false;
  String _selectedSide = 'stanga';
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleFeeding() {
    setState(() {
      if (_isFeeding) {
        _saveFeedingActivity();
        _isFeeding = false;
        _timer?.cancel();
        _elapsed = Duration.zero;
        _startTime = null;
      } else {
        _isFeeding = true;
        _startTime = DateTime.now();
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        setState(() => _elapsed = DateTime.now().difference(_startTime!));
      }
    });
  }

  Future<void> _saveFeedingActivity() async {
    if (_startTime == null) return;

    final activity = Activity(
      id: '',
      type: ActivityType.feeding,
      timestamp: _startTime!,
      details: {
        'side': _selectedSide,
        'duration': _elapsed.inMinutes,
        'timestamp': _startTime!.toIso8601String(),
      },
    );

    try {
      await _firebaseService.saveActivity(activity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alăptare salvată: ${_elapsed.inMinutes} minute')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare: $e')));
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alăptat')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant, size: 120, color: _isFeeding ? Colors.orange : Colors.grey),
              const SizedBox(height: 32),
              const Text('Selectează sânul', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Stânga'),
                    selected: _selectedSide == 'stanga',
                    onSelected: !_isFeeding ? (selected) { if (selected) setState(() => _selectedSide = 'stanga'); } : null,
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Dreapta'),
                    selected: _selectedSide == 'dreapta',
                    onSelected: !_isFeeding ? (selected) { if (selected) setState(() => _selectedSide = 'dreapta'); } : null,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (_isFeeding) ...[
                Text(_formatDuration(_elapsed), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 8),
                Text('Sân: ${_selectedSide == 'stanga' ? 'Stânga' : 'Dreapta'}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ] else ...[
                const Text('Apasă butonul pentru a începe', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _toggleFeeding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFeeding ? Colors.red : Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _isFeeding ? 'Oprește și salvează' : 'Pornește cronometrul',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
