class Playlist {
  final int id;
  final String name;
  final String? description;
  final int userId;
  final String? image;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.image,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      userId: int.parse(json['user_id'].toString()),
      image: json['image']?.toString(),
    );
  }
}
