import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/songs_model.dart';
import '../model/playlist_model.dart';
import '../services/user_secure_storage.dart';

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
    final response = await http.get(Uri.parse('$baseUrl/playlists/$playlistId/songs'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load songs for playlist ID $playlistId');
    }
  }

  static Future<List<Song>> getFavoriteSongs(int userId) async {
    try {
      final userInfo = await UserSecureStorage.getUserInfo();
      final token = userInfo['token'] ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/favorites/$userId'),
        headers: {
          'Authorization': 'Bearer $token', // Thêm token
          'Content-Type': 'application/json',
        },
      );
      print('getFavoriteSongs response: ${response.statusCode} - ${response.body}'); // Log chi tiết
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Song.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorite songs: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching favorite songs: $e');
      throw Exception('Error fetching favorite songs: $e');
    }
  }

  static Future<bool> isFavorite(int userId, int songId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/favorites/check/$userId/$songId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      } else {
        print('isFavorite error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  static Future<bool> addFavorite(int userId, int songId) async {
    try {
      final userInfo = await UserSecureStorage.getUserInfo();
      final token = userInfo['token'] ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': userId, 'song_id': songId}),
      );
      print('addFavorite response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      print('Error adding favorite: $e');
      return false;
    }
  }

  static Future<bool> removeFavorite(int userId, int songId) async {
    try {
      final userInfo = await UserSecureStorage.getUserInfo();
      final token = userInfo['token'] ?? '';
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$userId/$songId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('removeFavorite response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }
}