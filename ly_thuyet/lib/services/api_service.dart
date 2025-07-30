import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/songs_model.dart';
import '../model/playlist_model.dart';
import '../services/user_secure_storage.dart';
import '../model/artist_model.dart';

class ApiService {
  static const String baseUrl = 'https://music-api-production-89f1.up.railway.app';

  static Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse('$baseUrl/songs'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((songJson) => Song.fromJson(songJson)).toList();
    } else {
      throw Exception('Failed to load songs: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<List<Playlist>> fetchPlaylists() async {
    final response = await http.get(Uri.parse('$baseUrl/playlists'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Playlist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load playlists: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<List<Song>> fetchSongsByPlaylistId(int playlistId) async {
    final response = await http.get(Uri.parse('$baseUrl/playlists/$playlistId/songs'));
    print('fetchSongsByPlaylistId response: ${response.statusCode} - ${response.body}'); // Thêm log
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Song.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load songs for playlist ID $playlistId: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<List<Song>> getFavoriteSongs(int userId) async {
    try {
      final userInfo = await UserSecureStorage.getUserInfo();
      final token = userInfo['token'] ?? '';
      if (token.isEmpty) {
        throw Exception('No authentication token available');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/favorites/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('getFavoriteSongs response: ${response.statusCode} - ${response.body}');
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
      print('isFavorite response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      } else {
        throw Exception('Failed to check favorite: ${response.statusCode} - ${response.body}');
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
      if (token.isEmpty) {
        throw Exception('No authentication token available');
      }
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': userId, 'song_id': songId}),
      );
      print('addFavorite response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to add favorite: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error adding favorite: $e');
      return false;
    }
  }

  static Future<bool> removeFavorite(int userId, int songId) async {
    try {
      final userInfo = await UserSecureStorage.getUserInfo();
      final token = userInfo['token'] ?? '';
      if (token.isEmpty) {
        throw Exception('No authentication token available');
      }
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$userId/$songId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('removeFavorite response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to remove favorite: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }

  // Phương thức tìm kiếm gợi ý
  static Future<List<Song>> searchSuggestions(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/suggestions?query=$query'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('searchSuggestions response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Song.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load suggestions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      throw Exception('Error fetching suggestions: $e');
    }
  }

  // Phương thức tìm kiếm kết quả chi tiết
  static Future<List<Song>> searchResults(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/results?query=$query'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('searchResults response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Song.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load results: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching results: $e');
      throw Exception('Error fetching results: $e');
    }
  }
  static Future<List<Artist>> fetchArtists() async {
    final response = await http.get(Uri.parse('${baseUrl}/artists'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Artist.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load artists');
    }
  }
}