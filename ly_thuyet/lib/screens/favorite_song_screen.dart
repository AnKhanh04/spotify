import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/songs_model.dart';

class FavoriteSongsScreen extends StatefulWidget {
  const FavoriteSongsScreen({super.key});

  @override
  State<FavoriteSongsScreen> createState() => _FavoriteSongsScreenState();
}

class _FavoriteSongsScreenState extends State<FavoriteSongsScreen> {
  List<Song> favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final userId = 1; // Tạm thời hardcode

    try {
      final res = await http.get(Uri.parse('http://localhost:3000/favorites'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final userFavs = data.where((e) => e['user_id'] == userId).toList();

        List<Song> songs = [];
        for (var fav in userFavs) {
          final songRes = await http.get(Uri.parse('http://localhost:3000/songs/${fav['song_id']}'));
          if (songRes.statusCode == 200) {
            songs.add(Song.fromJson(jsonDecode(songRes.body)));
          }
        }

        setState(() {
          favoriteSongs = songs;
        });
      }
    } catch (e) {
      print("Lỗi lấy danh sách yêu thích: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Danh sách yêu thích"),
        backgroundColor: Colors.black,
      ),
      body: favoriteSongs.isEmpty
          ? const Center(child: Text("Chưa có bài hát yêu thích", style: TextStyle(color: Colors.white)))
          : ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = favoriteSongs[index];
          return ListTile(
            leading: Image.network(song.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(song.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(song.artist, style: const TextStyle(color: Colors.white70)),
            onTap: () {
              Navigator.pushNamed(context, '/nowplaying', arguments: song);
            },
          );
        },
      ),
    );
  }
}
