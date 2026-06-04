enum ActivityType {
  sleep,
  feeding,
  diaper,
}

class Activity {
  final String id;
  final ActivityType type;
  final DateTime timestamp;
  final Map<String, dynamic> details;

  Activity({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
    };
  }

  factory Activity.fromMap(String id, Map<String, dynamic> map) {
    ActivityType type;
    switch (map['type']) {
      case 'sleep':
        type = ActivityType.sleep;
        break;
      case 'feeding':
        type = ActivityType.feeding;
        break;
      case 'diaper':
        type = ActivityType.diaper;
        break;
      default:
        type = ActivityType.diaper;
    }

    return Activity(
      id: id,
      type: type,
      timestamp: DateTime.parse(map['timestamp']),
      details: Map<String, dynamic>.from(map['details'] ?? {}),
    );
  }
}
