class Trip {
  String? id;
  DateTime date;
  String from;
  String to;
  int budget;
  String accommodationType;
  bool needTourGuide;
  bool soloTravel;
  String travelMode;
  String userId;
  String hotelId;
  String hotelName;
  String travelModeId;
  String travelAgency;
  int paymentMade;

  Trip({
    this.id,
    required this.date,
    required this.from,
    required this.to,
    required this.budget,
    required this.accommodationType,
    required this.needTourGuide,
    required this.soloTravel,
    required this.travelMode,
    required this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.travelModeId,
    required this.travelAgency,
    required this.paymentMade,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'from': from,
      'to': to,
      'budget': budget,
      'accommodationType': accommodationType,
      'needTourGuide': needTourGuide,
      'soloTravel': soloTravel,
      'travelMode': travelMode,
      'userId': userId,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'travelModeId': travelModeId,
      'travelAgency': travelAgency,
      'paymentMade': paymentMade,
    };
  }

  static Trip fromMap(String id, Map<String, dynamic> map) {
    return Trip(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      id: id,
      from: map['from'],
      to: map['to'],
      budget: map['budget'],
      accommodationType: map['accommodationType'],
      needTourGuide: map['needTourGuide'],
      soloTravel: map['soloTravel'],
      travelMode: map['travelMode'],
      userId: map['userId'],
      hotelId: map['hotelId'],
      hotelName: map['hotelName'],
      travelModeId: map['travelModeId'],
      travelAgency: map['travelAgency'],
      paymentMade: map['paymentMade'],
    );
  }
}
