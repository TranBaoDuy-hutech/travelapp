class Tour {
  final int tourID;
  final String tourName;
  final String location;
  final double price;
  final int durationDays;
  final String startDate;
  final String? imageUrl;
  final String departureLocation;
  final String hotelName;
  final bool isHot;
  final String itinerary;
  final String transportation;

  Tour({
    required this.tourID,
    required this.tourName,
    required this.location,
    required this.price,
    required this.durationDays,
    required this.startDate,
    this.imageUrl,
    required this.departureLocation,
    required this.hotelName,
    required this.isHot,
    required this.itinerary,
    required this.transportation,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      tourID: json['TourID'],
      tourName: json['TourName'],
      location: json['Location'],
      price: (json['Price'] as num).toDouble(),
      durationDays: json['DurationDays'],
      startDate: json['StartDate'],
      imageUrl: json['ImageUrl'],
      departureLocation: json['DepartureLocation'],
      hotelName: json['HotelName'],
      isHot: json['IsHot'],
      itinerary: json['Itinerary'],
      transportation: json['Transportation'],
    );
  }
}
