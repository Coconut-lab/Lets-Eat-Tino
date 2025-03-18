class Partner {
  final String image;
  final String name;
  final String benefit;
  final String condition;

  Partner({
    required this.image,
    required this.name,
    required this.benefit,
    required this.condition,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      image: json['image'],
      name: json['name'],
      benefit: json['benefit'],
      condition: json['condition'],
    );
  }
}
