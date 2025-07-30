class Artist {
  final int id;
  final String name;
  final String? bio;
  final String? imageUrl;

  Artist({required this.id, required this.name, this.bio, this.imageUrl});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      imageUrl: json['image_url'],
    );
  }
}