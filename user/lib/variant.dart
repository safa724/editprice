class Variant {
  final int id;
  final double measurement;
  final double price;

  Variant({
    required this.id,
    required this.measurement,
    required this.price,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      measurement: json['measurement'].toDouble(),
      price: json['price'].toDouble(),
    );
  }
}
