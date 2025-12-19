enum CropStatus { Planting, Growing, Harvested }

class Crop {
  final String id;
  final String landId;
  final String cropName;
  final String? variety;
  final DateTime plantingDate;
  CropStatus status;
  DateTime? harvestDate;
  double? expectedYield;
  double? actualYield;

  Crop({
    required this.id,
    required this.landId,
    required this.cropName,
    this.variety,
    required this.plantingDate,
    this.status = CropStatus.Planting, // Default status
    this.harvestDate,
    this.expectedYield,
    this.actualYield,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'landId': landId,
      'cropName': cropName,
      'variety': variety,
      'plantingDate': plantingDate.toIso8601String(),
      'status': status.toString(),
      'harvestDate': harvestDate?.toIso8601String(),
      'expectedYield': expectedYield,
      'actualYield': actualYield,
    };
  }

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      id: map['id'],
      landId: map['landId'],
      cropName: map['cropName'],
      variety: map['variety'],
      plantingDate: DateTime.parse(map['plantingDate']),
      status: CropStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => CropStatus.Planting, // Fallback
      ),
      harvestDate: map['harvestDate'] != null ? DateTime.parse(map['harvestDate']) : null,
      expectedYield: map['expectedYield'],
      actualYield: map['actualYield'],
    );
  }
}
