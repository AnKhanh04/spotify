import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/songs_model.dart';

class CurrentSongProvider with ChangeNotifier {
  Song? _currentSong;
  Duration _currentPosition = Duration.zero;

  Song? get currentSong => _currentSong;
  Duration get currentPosition => _currentPosition;

  void setCurrentSong(Song song) {
    _currentSong = song;
    _currentPosition = Duration.zero;
    saveToPrefs();
    notifyListeners();
  }

  void updatePosition(Duration position) {
    _currentPosition = position;
    saveToPrefs();
    notifyListeners();
  }

  void clearSong() {
    _currentSong = null;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  // ✅ Lưu bài hát & vị trí phát
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentSong != null) {
      prefs.setString('current_song', jsonEncode(_currentSong!.toJson()));
      prefs.setInt('current_position', _currentPosition.inMilliseconds);
    }
  }

  // ✅ Tải lại bài hát và vị trí
  Future<void> loadSavedSong() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('current_song');
    final positionMs = prefs.getInt('current_position') ?? 0;
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      _currentSong = Song.fromJson(jsonMap);
      _currentPosition = Duration(milliseconds: positionMs);
      notifyListeners();
    }
  }
}
