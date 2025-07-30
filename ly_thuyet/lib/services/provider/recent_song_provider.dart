import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/songs_model.dart';

class RecentSongsProvider with ChangeNotifier {
  List<Song> _recentSongs = [];

  List<Song> get recentSongs => _recentSongs;

  RecentSongsProvider() {
    loadSavedSongs();
  }

  void addRecentSong(Song song) async {
    print('Adding song to recent: ${song.title}, ID: ${song.id}'); // Debug
    final Map<String, dynamic> jsonData = song.toJson();
    final String artistValue = jsonData['artist_name'] ?? (song.artist.isNotEmpty ? song.artist : 'Unknown Artist');

    final newSong = Song(
      id: song.id,
      title: song.title,
      artistId: song.artistId,
      albumId: song.albumId,
      duration: song.duration,
      imageUrl: song.imageUrl,
      audioUrl: song.audioUrl,
      lyrics: song.lyrics,
      artist: artistValue,
    );

    _recentSongs.removeWhere((s) => s.id == newSong.id); // Loại bỏ nếu đã tồn tại
    _recentSongs.insert(0, newSong); // Thêm bài mới nhất lên đầu
    if (_recentSongs.length > 3) _recentSongs.removeLast(); // Giới hạn 3 bài

    await saveToPrefs(); // Đảm bảo lưu dữ liệu trước khi notify
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final recentJson = _recentSongs.map((song) => jsonEncode(song.toJson())).toList();
      await prefs.setStringList('recent_songs', recentJson);
      print('Saved recent songs to prefs: ${recentJson.map((j) => jsonDecode(j)['title']).join(', ')}'); // Debug
    } catch (e) {
      print('Error saving recent songs to prefs: $e');
    }
  }

  Future<void> loadSavedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getStringList('recent_songs') ?? [];
    try {
      _recentSongs = recentJson
          .map((json) {
        try {
          return Song.fromJson(jsonDecode(json));
        } catch (e) {
          print('Error parsing song from JSON: $e, JSON: $json');
          return null;
        }
      })
          .whereType<Song>()
          .toList();
      if (_recentSongs.length > 3) _recentSongs = _recentSongs.take(3).toList(); // Đảm bảo không vượt 3
      print('Loaded recent songs from prefs: ${_recentSongs.map((s) => s.title).join(', ')}'); // Debug
    } catch (e) {
      print('Error loading recent songs from prefs: $e');
      _recentSongs.clear();
    }
    notifyListeners();
  }

  void clearRecentSongs() {
    _recentSongs.clear();
    saveToPrefs();
    notifyListeners();
  }
}