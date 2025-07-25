import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/songs_model.dart';
import '../model/playlist_model.dart';
class ApiService {
  static const String baseUrl = 'https://music-api-production-89f1.up.railway.app';

  static Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((songJson) => Song.fromJson(songJson)).toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }
  static Future<List<Playlist>> fetchPlaylists() async {
    final response = await http.get(Uri.parse('$baseUrl/playlists'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Playlist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load playlists');
    }
  }
  static Future<List<Song>> fetchSongsByPlaylistId(int playlistId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/playlists/$playlistId/songs'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load songs for playlist ID $playlistId');
    }
  }

  static Future<bool> addToFavorites(int userId, int songId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'song_id': songId}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> removeFromFavorites(int userId, int songId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites?user_id=$userId&song_id=$songId'),
    );

    return response.statusCode == 200;
  }

  static Future<bool> addToFavoritesByUsername(String username, int songId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'song_id': songId}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> removeFromFavoritesByUsername(String username, int songId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'song_id': songId}),
    );
    return response.statusCode == 200;
  }

}
