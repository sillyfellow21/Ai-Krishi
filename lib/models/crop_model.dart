class Crop {
  final String id;
  final String landId;
  final String cropName;
  final String? variety;
  final DateTime plantingDate;

  Crop({
    required this.id,
    required this.landId,
    required this.cropName,
    this.variety,
    required this.plantingDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'landId': landId,
      'cropName': cropName,
      'variety': variety,
      'plantingDate': plantingDate.toIso8601String(),
    };
  }

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id'],
      landId: map['landId'],
      cropName: map['cropName'],
      variety: map['variety'],
      plantingDate: DateTime.parse(map['plantingDate']),
    );
  }
}
