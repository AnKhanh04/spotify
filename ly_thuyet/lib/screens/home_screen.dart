import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mini_player.dart';
import '../avatar_drawer.dart';
import '../services/provider/user_provider.dart';
import '../model/songs_model.dart';
import '../model/playlist_model.dart';
import '../services/api_service.dart';
import 'now_playing_screen.dart';
import '../services/provider/current_song_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Song>> _songsFuture;
  late Future<List<Playlist>> _playlistsFuture;

  @override
  void initState() {
    super.initState();
    _songsFuture = ApiService.fetchSongs();
    _playlistsFuture = ApiService.fetchPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentSongProvider = Provider.of<CurrentSongProvider>(context);
    final avatarUrl = userProvider.avatarUrl;
    final fullName = userProvider.fullName;

    return Scaffold(
      drawer: const AvatarDrawer(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[800],
                              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                              child: avatarUrl == null
                                  ? Text(
                                fullName != null && fullName.isNotEmpty
                                    ? fullName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(color: Colors.white),
                              )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const FilterChip(
                          label: Text('Tất cả'),
                          selected: true,
                          onSelected: null,
                          selectedColor: Colors.green,
                          labelStyle: TextStyle(color: Colors.white),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Chip(
                          label: Text('Nhạc'),
                          backgroundColor: Colors.grey,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Chip(
                          label: Text('Podcast'),
                          backgroundColor: Colors.grey,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Playlist grid
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FutureBuilder<List<Playlist>>(
                      future: _playlistsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Lỗi tải playlist', style: TextStyle(color: Colors.white)),
                          );
                        } else {
                          final playlists = snapshot.data!;
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 3.5,
                            children: playlists.take(8).map((playlist) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/playlist',
                                    arguments: playlist,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[850],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 8),
                                      if (playlist.image != null && playlist.image!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(
                                            playlist.image!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          playlist.name,
                                          style: const TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),

                  // Recently played
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Nội dung bạn hay nghe gần đây',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  FutureBuilder<List<Song>>(
                    future: _songsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Lỗi tải bài hát', style: TextStyle(color: Colors.white)),
                        );
                      } else {
                        final songs = snapshot.data!.take(3);
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs.elementAt(index); // Sử dụng elementAt thay vì index trực tiếp
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(song.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                              ),
                              title: Text(song.title, style: const TextStyle(color: Colors.white)),
                              subtitle: Text(song.artist, style: const TextStyle(color: Colors.white70)),
                              trailing: const Icon(Icons.more_vert, color: Colors.white),
                              onTap: () async {
                                currentSongProvider.setCurrentSong(song);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlayingScreen(song: song),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),

                  // Trending section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Những bản nhạc thịnh hành nhất hiện nay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 180,
                    child: FutureBuilder<List<Playlist>>(
                      future: _playlistsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Lỗi tải playlist', style: TextStyle(color: Colors.white)),
                          );
                        } else {
                          final playlists = snapshot.data!;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: playlists.length,
                            itemBuilder: (context, index) {
                              final playlist = playlists[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/playlist',
                                    arguments: playlist,
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          playlist.image ?? 'https://via.placeholder.com/140', // Fallback nếu không có image
                                          height: 140,
                                          width: 140,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.network(
                                              'https://via.placeholder.com/140',
                                              height: 140,
                                              width: 140,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        playlist.name,
                                        style: const TextStyle(color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}