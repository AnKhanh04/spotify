import 'package:flutter/material.dart';
import '../../services/api_service.dart'; // Giả sử API để tìm kiếm chi tiết
import '../../model/songs_model.dart';
import '../now_playing_screen.dart';

class SearchDetailScreen extends StatefulWidget {
  final String query;

  const SearchDetailScreen({super.key, required this.query});

  @override
  _SearchDetailScreenState createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  late Future<List<Song>> _searchResults;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchResults = _fetchSearchResults(widget.query);
  }

  Future<List<Song>> _fetchSearchResults(String query) async {
    setState(() => _isLoading = true);
    try {
      // Giả sử API trả về danh sách bài hát hoặc playlists
      final results = await ApiService.searchResults(query); // Cần triển khai trong ApiService
      return results;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tìm kiếm: $e')),
      );
      return [];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Kết quả cho "${widget.query}"',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Song>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Không tìm thấy kết quả',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          final results = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final song = results[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    song.imageUrl ?? '',
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
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song.artist.isEmpty ? 'Unknown Artist' : song.artist,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  // Điều hướng đến NowPlayingScreen hoặc thực hiện hành động khác
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlayingScreen(song: song),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}