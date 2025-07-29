import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/playlist_model.dart';
import '../model/songs_model.dart';
import '../services/api_service.dart';
import 'now_playing_screen.dart';
import '../services/provider/current_song_provider.dart';
class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  late Future<List<Song>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = ApiService.fetchSongsByPlaylistId(widget.playlist.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ảnh và thông tin playlist
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.playlist.image ?? '',
                      width: 200, // Thu nhỏ kích thước
                      height: 200, // Thu nhỏ kích thước
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[800],
                        child: const Icon(Icons.music_note, color: Colors.white, size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.playlist.name,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Các nút điều khiển
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.download_for_offline_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {},
                ),
                const Spacer(),
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 24,
                  child: Icon(Icons.pause, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Danh sách bài hát
          Expanded(
            child: FutureBuilder<List<Song>>(
              future: _songsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Lỗi: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Chưa có bài hát nào',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                final songs = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            song.imageUrl ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note, color: Colors.white),
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          song.artist.isEmpty ? 'Unknown Artist' : song.artist,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NowPlayingScreen(song: song),
                            ),
                          );
                          // Gọi setCurrentSong với cùng song
                          Provider.of<CurrentSongProvider>(context, listen: false).setCurrentSong(song);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}