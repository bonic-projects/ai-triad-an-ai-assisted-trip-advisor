class HotelData {
  final String? id;
  final String name;
  final String type;
  final int rate;
  final String state;
  final String place;

  HotelData({
    this.id,
    required this.name,
    required this.type,
    required this.rate,
    required this.state,
    required this.place,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'rate': rate,
      'state': state,
      'place': place,
    };
  }

  factory HotelData.fromMap(id, Map<String, dynamic> map) {
    return HotelData(
      id: id,
      name: map['name'],
      type: map['type'],
      rate: map['rate'],
      state: map['state'],
      place: map['place'],
    );
  }
}
