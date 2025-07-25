import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/playlist_model.dart';
import '../screens/favorite_song_screen.dart';
import '../screens/playlist_detail_screen.dart';
import '../services/api_service.dart';
import '../services/provider/user_provider.dart';
import '../mini_player.dart'; // ✅ import miniplayer

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Playlist>> _playlistsFuture;

  @override
  void initState() {
    super.initState();
    _playlistsFuture = ApiService.fetchPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final avatarUrl = userProvider.avatarUrl;
    final fullName = userProvider.fullName;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: (avatarUrl == null || avatarUrl.isEmpty)
                            ? Text(
                          (fullName != null && fullName.isNotEmpty)
                              ? fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white),
                        )
                            : null,
                      ),
                      const Text("Thư viện",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      Row(
                        children: const [
                          Icon(Icons.search, color: Colors.white),
                          SizedBox(width: 12),
                          Icon(Icons.add, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),

                // Filter Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Chip(label: Text("Danh sách phát"), backgroundColor: Colors.grey),
                      Chip(label: Text("Album"), backgroundColor: Colors.grey),
                      Chip(label: Text("Nghệ sĩ"), backgroundColor: Colors.grey),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Danh sách yêu thích + Playlists
                Expanded(
                  child: FutureBuilder<List<Playlist>>(
                    future: _playlistsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final playlists = snapshot.data ?? [];

                      return ListView(
                        padding: const EdgeInsets.only(bottom: 80), // Tránh đè mini player
                        children: [
                          ListTile(
                            leading: const Icon(Icons.favorite, color: Colors.redAccent),
                            title: const Text('Danh sách yêu thích', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FavoriteSongsScreen()),
                              );
                            },
                          ),
                          const Divider(color: Colors.white24),

                          ...playlists.map((playlist) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  playlist.image ?? 'https://via.placeholder.com/60',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(playlist.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text('Playlist ID: ${playlist.id}',
                                  style: const TextStyle(color: Colors.white70)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlaylistDetailScreen(playlist: playlist),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ✅ MiniPlayer cố định ở dưới
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }
}
