class Land {
  final String id;
  final String userId;
  final String landName;
  final double area;
  final String? location;

  Land({
    required this.id,
    required this.userId,
    required this.landName,
    required this.area,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'landName': landName,
      'area': area,
      'location': location,
    };
  }

  factory Land.fromMap(Map<String, dynamic> map) {
    return Land(
      id: map['id'],
      userId: map['userId'],
      landName: map['landName'],
      area: map['area'],
      location: map['location'],
    );
  }
}
