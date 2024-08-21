class League {
  final int id;
  final String name;
  final String location;
  final String startDate;
  final String endDate;

  League({
    required this.id,
    required this.name,
    required this.location,
    required this.startDate,
    required this.endDate,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['ID'],
      name: json['Name'],
      location: json['Location'] ,
      startDate: json['StartDate'],
      endDate: json['EndDate'],
    );
  }

  DateTime get startDateTime => DateTime.parse(startDate); // String'den DateTime'e dönüşüm
  DateTime get endDateTime => DateTime.parse(endDate);
}
