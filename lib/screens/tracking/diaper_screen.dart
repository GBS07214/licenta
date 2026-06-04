import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/activity.dart';

class DiaperScreen extends StatefulWidget {
  const DiaperScreen({super.key});

  @override
  State<DiaperScreen> createState() => _DiaperScreenState();
}

class _DiaperScreenState extends State<DiaperScreen> {
  final _firebaseService = FirebaseService();
  String _selectedType = 'ud';

  Future<void> _saveDiaperChange() async {
    final activity = Activity(
      id: '',
      type: ActivityType.diaper,
      timestamp: DateTime.now(),
      details: {'type': _selectedType},
    );

    try {
      await _firebaseService.saveActivity(activity);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Schimbare scutec salvată: $_selectedType')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schimbare scutec')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.baby_changing_station, size: 120, color: Colors.green),
              const SizedBox(height: 32),
              const Text('Selectează tipul de scutec', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('💧 Ud'),
                    value: 'ud',
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('💩 Murdar'),
                    value: 'murdar',
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('💧💩 Ambele'),
                    value: 'ambele',
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _saveDiaperChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Salvează schimbarea', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
