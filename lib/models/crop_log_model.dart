class CropLog {
  final String id;
  final String cropId;
  final DateTime date;
  final String activity;
  final String? notes;

  CropLog({
    required this.id,
    required this.cropId,
    required this.date,
    required this.activity,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropId': cropId,
      'date': date.toIso8601String(),
      'activity': activity,
      'notes': notes,
    };
  }

  factory CropLog.fromMap(Map<String, dynamic> map) {
    return CropLog(
      id: map['id'],
      cropId: map['cropId'],
      date: DateTime.parse(map['date']),
      activity: map['activity'],
      notes: map['notes'],
    );
  }
}
