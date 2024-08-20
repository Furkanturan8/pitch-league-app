class Field {
  final int id;
  final String name;
  final String location;
  final int price_per_hour;
  final int capacity;
  final bool available;


  Field({
    required this.id,
    required this.name,
    required this.location,
    required this.price_per_hour,
    required this.capacity,
    required this.available,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      price_per_hour: json['price_per_hour'],
      capacity: json['capacity'],
      available: json['available'],
    );
  }
}