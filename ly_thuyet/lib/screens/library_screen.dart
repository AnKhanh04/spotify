import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/playlist_model.dart';
import '../screens/favorite_song_screen.dart';
import '../screens/playlist_detail_screen.dart';
import '../services/api_service.dart';
import '../services/provider/user_provider.dart';
import '../mini_player.dart';
import '../model/artist_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Playlist>> _playlistsFuture;
  late Future<List<Artist>> _artistsFuture;
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _playlistsFuture = ApiService.fetchPlaylists();
    _artistsFuture = ApiService.fetchArtists();
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
                    children: [
                      FilterChip(
                        label: const Text("Danh sách phát"),
                        selected: _selectedFilter == 'playlists',
                        onSelected: (value) {
                          setState(() {
                            _selectedFilter = value ? 'playlists' : null;
                          });
                        },
                        selectedColor: Colors.green,
                        backgroundColor: Colors.grey,
                        labelStyle: TextStyle(
                          color: _selectedFilter == 'playlists' ? Colors.white : Colors.white70,
                        ),
                      ),
                      FilterChip(
                        label: const Text("Nghệ sĩ"),
                        selected: _selectedFilter == 'artists',
                        onSelected: (value) {
                          setState(() {
                            _selectedFilter = value ? 'artists' : null;
                          });
                        },
                        selectedColor: Colors.green,
                        backgroundColor: Colors.grey,
                        labelStyle: TextStyle(
                          color: _selectedFilter == 'artists' ? Colors.white : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Danh sách yêu thích + Playlists hoặc Nghệ sĩ
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: Future.wait([_playlistsFuture, _artistsFuture]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Lỗi tải dữ liệu', style: TextStyle(color: Colors.white)),
                        );
                      }

                      final playlists = snapshot.data?[0] as List<Playlist>? ?? [];
                      final artists = snapshot.data?[1] as List<Artist>? ?? [];

                      return ListView(
                        padding: const EdgeInsets.only(bottom: 80), // Tránh đè mini player
                        children: [
                          // Luôn hiển thị "Danh sách yêu thích"
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                          // Hiển thị danh sách dựa trên filter
                          if (_selectedFilter == null || _selectedFilter == 'playlists')
                            ...playlists.map((playlist) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                minVerticalPadding: 8.0, // Thêm khoảng cách dọc
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistDetailScreen(playlist: playlist),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          if (_selectedFilter == null || _selectedFilter == 'artists')
                            ...artists.map((artist) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    artist.imageUrl ?? 'https://via.placeholder.com/60',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(artist.name,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                minVerticalPadding: 8.0, // Thêm khoảng cách dọc
                                onTap: () {
                                  // Không có hành động điều hướng cho nghệ sĩ
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