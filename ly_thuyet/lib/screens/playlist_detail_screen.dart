import 'package:flutter/material.dart';

class PlaylistDetailScreen extends StatelessWidget {
  const PlaylistDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh album + tên + artist
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://via.placeholder.com/300x300',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cho Bão',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'B Ray',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Album • 8 thg 7 • Mới phát hành',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Hàng nút + play
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.download_for_offline_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {},
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 24,
                  child: const Icon(Icons.pause, color: Colors.black),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Danh sách bài hát
          Expanded(
            child: ListView(
              children: const [
                _SongItem(title: 'Intro', artist: 'B Ray'),
                _SongItem(title: 'Vùng An Toàn', artist: 'B Ray, V#'),
                _SongItem(title: 'The One', artist: 'B Ray, Đạt G'),
                _SongItem(title: 'Viết Em Bản Tình Ca', artist: 'B Ray'),
                _SongItem(title: 'Feel At Home', artist: 'B Ray'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SongItem extends StatelessWidget {
  final String title;
  final String artist;

  const _SongItem({required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(artist, style: const TextStyle(color: Colors.white54)),
      trailing: const Icon(Icons.more_vert, color: Colors.white),
      onTap: () {
        Navigator.pushNamed(context, '/nowplaying'); // mở màn hình nghe nhạc
      },
    );
  }
}
