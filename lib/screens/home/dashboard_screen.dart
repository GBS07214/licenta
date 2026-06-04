import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../models/baby_profile.dart';
import '../../widgets/activity_button.dart';
import '../../widgets/daily_tip_card.dart';
import '../tracking/sleep_screen.dart';
import '../tracking/feeding_screen.dart';
import '../tracking/diaper_screen.dart';
import '../stats/statistics_screen.dart';
import '../chat/ai_chat_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _firebaseService = FirebaseService();
  BabyProfile? _babyProfile;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _firebaseService.getBabyProfile();
    if (mounted) {
      setState(() => _babyProfile = profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildDashboard(),
      const StatisticsScreen(),
      const AIChatScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BabyTracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              setState(() => _currentIndex = 3);
            },
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Acasă'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistici'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat AI'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setări'),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_babyProfile != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.child_care, size: 35, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _babyProfile!.babyName,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_babyProfile!.getAgeInMonths()} luni (${_babyProfile!.getAgeInDays()} zile)',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          const DailyTipCard(),
          const SizedBox(height: 24),
          const Text(
            'Activități rapide',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ActivityButton(
                  icon: Icons.bedtime,
                  label: 'Somn',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SleepScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActivityButton(
                  icon: Icons.restaurant,
                  label: 'Alăptat',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FeedingScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ActivityButton(
                  icon: Icons.baby_changing_station,
                  label: 'Scutec',
                  color: Colors.green,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DiaperScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActivityButton(
                  icon: Icons.bar_chart,
                  label: 'Statistici',
                  color: Colors.purple,
                  onTap: () {
                    setState(() => _currentIndex = 1);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
