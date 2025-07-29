import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart'; // Giả sử API để tìm kiếm
import '../../model/songs_model.dart';
import 'search_detail_screen.dart'; // Trang kết quả chi tiết

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _suggestions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      _fetchSuggestions(query);
    } else {
      setState(() {
        _suggestions.clear();
      });
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => _isLoading = true);
    try {
      // Giả sử API trả về danh sách gợi ý (có thể là songs hoặc playlists)
      final suggestions = await ApiService.searchSuggestions(query); // Cần triển khai trong ApiService
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tìm kiếm: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchDetailScreen(query: query),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm bài hát hoặc danh sách...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : null,
                ),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        suggestion.imageUrl ?? '',
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
                      suggestion.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      suggestion.artist.isEmpty ? 'Unknown Artist' : suggestion.artist,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () => _onSearchSubmitted(suggestion.title),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}