import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoriteSongIds = [];

  List<int> get favoriteSongIds => _favoriteSongIds;

  Future<void> loadFavorites(int userId) async {
    final response = await http.get(Uri.parse('https://yourapi.com/favorites'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      _favoriteSongIds.clear();
      _favoriteSongIds.addAll(
        data.where((item) => item['user_id'] == userId).map<int>((item) => item['song_id']),
      );
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int userId, int songId) async {
    if (_favoriteSongIds.contains(songId)) {
      // TODO: tạo API DELETE nếu muốn huỷ yêu thích
      _favoriteSongIds.remove(songId);
    } else {
      final response = await http.post(
        Uri.parse('https://yourapi.com/favorites'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'song_id': songId}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _favoriteSongIds.add(songId);
      }
    }
    notifyListeners();
  }

  bool isFavorite(int songId) => _favoriteSongIds.contains(songId);
}
