import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/songs_model.dart';

class CurrentSongProvider with ChangeNotifier {
  Song? _currentSong;
  Duration _currentPosition = Duration.zero;

  Song? get currentSong => _currentSong;
  Duration get currentPosition => _currentPosition;

  CurrentSongProvider() {
    loadSavedSong();
  }

  void setCurrentSong(Song song) {
    // Lấy JSON gốc từ song để kiểm tra artist_name
    Map<String, dynamic> jsonData = song.toJson();
    String artistValue = song.artist.isEmpty && jsonData.containsKey('artist_name')
        ? (jsonData['artist_name'] as String)
        : (song.artist.isEmpty ? 'Unknown Artist' : song.artist);

    _currentSong = Song(
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
    saveToPrefs();
    notifyListeners();
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentSong != null) {
      try {
        final jsonString = jsonEncode(_currentSong!.toJson());
        prefs.setString('current_song', jsonString);
        prefs.setInt('current_position', _currentPosition.inMilliseconds);
        print('Saved to prefs: $jsonString');
      } catch (e) {
        print('Error saving to prefs: $e');
      }
    } else {
      prefs.remove('current_song');
      prefs.remove('current_position');
    }
  }

  Future<void> loadSavedSong() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('current_song');
    print('Loaded from prefs: $jsonString');
    final positionMs = prefs.getInt('current_position') ?? 0;
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        _currentSong = Song.fromJson(jsonMap);
        _currentPosition = Duration(milliseconds: positionMs);
        notifyListeners();
      } catch (e) {
        print('Error loading from prefs: $e');
        _currentSong = null;
        _currentPosition = Duration.zero;
      }
    }
  }
}