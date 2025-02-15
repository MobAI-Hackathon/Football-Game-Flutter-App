class Player {
  final String name;
  final String position;
  final String club;
  final double price;
  final String kitImageUrl;

  Player({
    required this.name,
    required this.position,
    required this.club,
    required this.price,
    required this.kitImageUrl,
  });

  factory Player.fromJson(
      Map<String, dynamic> json, String clubName, String kitImageUrl) {
    return Player(
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      club: clubName,
      price: (json['price'] ?? 0).toDouble(),
      kitImageUrl: kitImageUrl,
    );
  }
}
