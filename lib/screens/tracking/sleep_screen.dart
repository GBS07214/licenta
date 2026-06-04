import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/firebase_service.dart';
import '../../models/activity.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final _firebaseService = FirebaseService();
  bool _isSleeping = false;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleSleep() {
    setState(() {
      if (_isSleeping) {
        _saveSleepActivity();
        _isSleeping = false;
        _timer?.cancel();
        _elapsed = Duration.zero;
        _startTime = null;
      } else {
        _isSleeping = true;
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

  Future<void> _saveSleepActivity() async {
    if (_startTime == null) return;
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!);
    final activity = Activity(
      id: '',
      type: ActivityType.sleep,
      timestamp: _startTime!,
      details: {
        'startTime': _startTime!.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'duration': duration.inMinutes,
      },
    );

    try {
      await _firebaseService.saveActivity(activity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Somn salvat: ${duration.inHours}h ${duration.inMinutes % 60}m')),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare: $e')));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Somn')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bedtime, size: 120, color: _isSleeping ? Colors.indigo : Colors.grey),
              const SizedBox(height: 32),
              Text(
                _isSleeping ? 'Bebelușul doarme...' : 'Începe cronometrul de somn',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_isSleeping) ...[
                Text(_formatDuration(_elapsed), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 8),
                Text('Început: ${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _toggleSleep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSleeping ? Colors.red : Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_isSleeping ? 'Oprește și salvează' : 'Pornește cronometrul', style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
