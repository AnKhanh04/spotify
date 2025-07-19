import 'package:flutter/material.dart';
import 'package:spotify/show_song_options.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A4D2B), // Màu nền nâu
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Thiên Hạ Nghe Gì',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showSongOptions(context); // Gọi BottomSheet từ file tách riêng
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Ảnh bìa bài hát
          Padding(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://via.placeholder.com/300x300',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Tên bài hát và nghệ sĩ
          const Text(
            'Từng Ngày Yêu Em',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'buitruonglinh',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          // Thanh tiến độ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Slider(
                  value: 5,
                  min: 0,
                  max: 220,
                  onChanged: (value) {},
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('0:05', style: TextStyle(color: Colors.white70)),
                    Text('3:40', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          // Nút điều khiển
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.shuffle, color: Colors.white),
              Icon(Icons.skip_previous, color: Colors.white, size: 36),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28,
                child: Icon(Icons.pause, color: Colors.black, size: 36),
              ),
              Icon(Icons.skip_next, color: Colors.white, size: 36),
              Icon(Icons.timer, color: Colors.white),
            ],
          ),

          const SizedBox(height: 20),

          // Lyrics Preview Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Bản xem trước lời bài hát',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  'Lại chìm trong đôi mắt em xoe tròn ngất ngây\n'
                      'Phút giây khi mà anh khẽ nhìn sang\n'
                      'Lại làm đôi môi nhớ em, lại muốn hôn em thêm bao lần',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 12),
                Text(
                  'Từng ngày cô đơn xé đôi, hạ thu',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
