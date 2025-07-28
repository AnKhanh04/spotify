import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/model/songs_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Song> _favoriteSongs = [];
  bool _isLoading = false;

  List<Song> get favoriteSongs => List.unmodifiable(_favoriteSongs);
  bool get isLoading => _isLoading;

  Future<void> loadFavorites(int userId) async {
    _isLoading = true;
    notifyListeners();
    print('Loading favorites for userId: $userId');
    try {
      final songs = await ApiService.getFavoriteSongs(userId);
      print('Loaded songs: $songs'); // Log dữ liệu trả về
      _favoriteSongs.clear();
      _favoriteSongs.addAll(songs);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleFavorite(int userId, int songId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final isCurrentlyFavorite = _favoriteSongs.any((song) => song.id == songId);
      bool success;
      if (isCurrentlyFavorite) {
        success = await ApiService.removeFavorite(userId, songId);
        if (success) {
          _favoriteSongs.removeWhere((song) => song.id == songId);
        }
      } else {
        success = await ApiService.addFavorite(userId, songId);
        if (success) {
          await loadFavorites(userId); // Làm mới danh sách
        }
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      print('Error toggling favorite: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool isFavorite(int songId) => _favoriteSongs.any((song) => song.id == songId);
}