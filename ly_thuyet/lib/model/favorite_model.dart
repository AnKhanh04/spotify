class Favorite {
  final int userId;
  final int songId;

  Favorite({required this.userId, required this.songId});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      userId: json['user_id'],
      songId: json['song_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'song_id': songId,
    };
  }
}
