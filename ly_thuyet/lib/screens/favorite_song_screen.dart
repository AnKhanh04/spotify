import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../model/songs_model.dart';
import '../services/provider/favorite_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteSongsScreen extends StatefulWidget {
  const FavoriteSongsScreen({super.key});

  @override
  State<FavoriteSongsScreen> createState() => _FavoriteSongsScreenState();
}

class _FavoriteSongsScreenState extends State<FavoriteSongsScreen> {
  int? _userId;

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    print('User JSON from SharedPreferences: $userJson');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      final id = int.tryParse(userMap['userID']?.toString() ?? '');
      print('Parsed userId: $id');
      setState(() {
        _userId = id;
      });
    } else {
      print('No user data found in SharedPreferences');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserId().then((_) {
      if (_userId != null) {
        _loadFavorites();
      } else {
        print('UserId is null, skipping loadFavorites');
      }
    });
  }

  Future<void> _loadFavorites() async {
    if (_userId != null) {
      print('Loading favorites for userId: $_userId');
      await Provider.of<FavoriteProvider>(context, listen: false).loadFavorites(_userId!);
    }
  }

  Future<void> _removeFavorite(int songId) async {
    if (_userId == null) {
      if (mounted) _showError('Please login to remove favorites');
      return;
    }
    final success = await Provider.of<FavoriteProvider>(context, listen: false).toggleFavorite(_userId!, songId);
    if (mounted) {
      if (success) {
        _showSuccess('Removed from favorites');
      } else {
        _showError('Failed to remove favorite');
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
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
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          if (favoriteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final favoriteSongs = favoriteProvider.favoriteSongs;
          print('Favorite songs count: ${favoriteSongs.length}');
          if (favoriteSongs.isEmpty) {
            return const Center(
              child: Text("Chưa có bài hát yêu thích", style: TextStyle(color: Colors.white)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              final song = favoriteSongs[index];
              print('Song artist: ${song.artist}'); // Log để debug artist
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    song.imageUrl,
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
                  song.artist, // Hiển thị tên nghệ sĩ
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _removeFavorite(song.id),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/nowplaying', arguments: song);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Colors.grey[900],
              );
            },
          );
        },
      ),
    );
  }
}