class Song {
  final int id;
  final String title;
  final int? artistId;
  final int? albumId;
  final int? duration; // <- duration là INT trong DB
  final String imageUrl;
  final String audioUrl;
  final String? lyrics;
  final String artist;

  Song({
    required this.id,
    required this.title,
    this.artistId,
    this.albumId,
    this.duration,
    required this.imageUrl,
    required this.audioUrl,
    this.lyrics,
    required this.artist,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artistId: json['artist_id'],
      albumId: json['album_id'],
      duration: json['duration'],
      imageUrl: json['image_url'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      lyrics: json['lyrics'],
      artist: json['artist'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist_id': artistId,
      'album_id': albumId,
      'duration': duration,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'lyrics': lyrics,
      'artist':artist,
    };
  }
}
