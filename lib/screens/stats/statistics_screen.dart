import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/firebase_service.dart';
import '../../models/activity.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _firebaseService = FirebaseService();
  int _selectedDays = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistici'),
        actions: [
          PopupMenuButton<int>(
            initialValue: _selectedDays,
            onSelected: (days) => setState(() => _selectedDays = days),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 7, child: Text('Ultimele 7 zile')),
              const PopupMenuItem(value: 14, child: Text('Ultimele 14 zile')),
              const PopupMenuItem(value: 30, child: Text('Ultimele 30 zile')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Activity>>(
        stream: _firebaseService.getActivitiesStream(_selectedDays),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Nu există date de afișat', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            );
          }

          final activities = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(activities),
                const SizedBox(height: 24),
                _buildSleepChart(activities),
                const SizedBox(height: 24),
                _buildFeedingChart(activities),
                const SizedBox(height: 24),
                _buildDiaperChart(activities),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(List<Activity> activities) {
    final sleepCount = activities.where((a) => a.type == ActivityType.sleep).length;
    final feedingCount = activities.where((a) => a.type == ActivityType.feeding).length;
    final diaperCount = activities.where((a) => a.type == ActivityType.diaper).length;

    return Row(
      children: [
        Expanded(child: _SummaryCard(icon: Icons.bedtime, label: 'Somn', count: sleepCount, color: Colors.indigo)),
        const SizedBox(width: 12),
        Expanded(child: _SummaryCard(icon: Icons.restaurant, label: 'Alăptat', count: feedingCount, color: Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _SummaryCard(icon: Icons.baby_changing_station, label: 'Scutece', count: diaperCount, color: Colors.green)),
      ],
    );
  }

  Widget _buildSleepChart(List<Activity> activities) {
    final sleepActivities = activities.where((a) => a.type == ActivityType.sleep).toList();
    if (sleepActivities.isEmpty) return const SizedBox.shrink();

    final Map<int, double> dailySleep = {};
    for (var activity in sleepActivities) {
      final day = activity.timestamp.day;
      final duration = (activity.details['duration'] as num?)?.toDouble() ?? 0;
      dailySleep[day] = (dailySleep[day] ?? 0) + duration / 60;
    }

    final spots = dailySleep.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()..sort((a, b) => a.x.compareTo(b.x));

    return _ChartCard(
      title: 'Somn (ore pe zi)',
      chart: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.indigo,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.indigo.withOpacity(0.2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedingChart(List<Activity> activities) {
    final feedingActivities = activities.where((a) => a.type == ActivityType.feeding).toList();
    if (feedingActivities.isEmpty) return const SizedBox.shrink();

    final Map<int, double> dailyFeeding = {};
    for (var activity in feedingActivities) {
      final day = activity.timestamp.day;
      final duration = (activity.details['duration'] as num?)?.toDouble() ?? 0;
      dailyFeeding[day] = (dailyFeeding[day] ?? 0) + duration;
    }

    final barGroups = dailyFeeding.entries.map((e) {
      return BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: e.value, color: Colors.orange, width: 16)]);
    }).toList()..sort((a, b) => a.x.compareTo(b.x));

    return _ChartCard(
      title: 'Alăptare (minute pe zi)',
      chart: BarChart(
        BarChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          barGroups: barGroups,
        ),
      ),
    );
  }

  Widget _buildDiaperChart(List<Activity> activities) {
    final diaperActivities = activities.where((a) => a.type == ActivityType.diaper).toList();
    if (diaperActivities.isEmpty) return const SizedBox.shrink();

    final Map<int, int> dailyDiapers = {};
    for (var activity in diaperActivities) {
      final day = activity.timestamp.day;
      dailyDiapers[day] = (dailyDiapers[day] ?? 0) + 1;
    }

    final barGroups = dailyDiapers.entries.map((e) {
      return BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: e.value.toDouble(), color: Colors.green, width: 16)]);
    }).toList()..sort((a, b) => a.x.compareTo(b.x));

    return _ChartCard(
      title: 'Schimbări scutec (pe zi)',
      chart: BarChart(
        BarChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          barGroups: barGroups,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SummaryCard({required this.icon, required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;

  const _ChartCard({required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }
}
