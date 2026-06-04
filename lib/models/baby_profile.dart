class BabyProfile {
  final String id;
  final String babyName;
  final DateTime babyBirthDate;
  final String theme;

  BabyProfile({
    required this.id,
    required this.babyName,
    required this.babyBirthDate,
    this.theme = 'blue',
  });

  int getAgeInMonths() {
    final now = DateTime.now();
    int months = (now.year - babyBirthDate.year) * 12;
    months += now.month - babyBirthDate.month;
    return months;
  }

  int getAgeInDays() {
    final now = DateTime.now();
    return now.difference(babyBirthDate).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'babyName': babyName,
      'babyBirthDate': babyBirthDate.toIso8601String(),
      'theme': theme,
    };
  }

  factory BabyProfile.fromMap(String id, Map<String, dynamic> map) {
    return BabyProfile(
      id: id,
      babyName: map['babyName'] ?? '',
      babyBirthDate: DateTime.parse(map['babyBirthDate']),
      theme: map['theme'] ?? 'blue',
    );
  }
}
