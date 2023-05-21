class TravelMode {
  final String? id;
  final String name;
  final String type;
  final int rate;
  final String fromState;
  final String toState;
  final String place;

  TravelMode({
    this.id,
    required this.name,
    required this.type,
    required this.rate,
    required this.fromState,
    required this.toState,
    required this.place,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'rate': rate,
      'fromState': fromState,
      'toState': toState,
      'place': place,
    };
  }

  factory TravelMode.fromMap(String id, Map<String, dynamic> map) {
    return TravelMode(
      id: id,
      name: map['name'],
      type: map['type'],
      rate: map['rate'],
      fromState: map['fromState'],
      toState: map['toState'],
      place: map['place'],
    );
  }
}
