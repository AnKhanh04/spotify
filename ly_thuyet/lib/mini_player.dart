import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/provider/current_song_provider.dart';
import 'model/songs_model.dart';
import 'screens/now_playing_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSong = context.watch<CurrentSongProvider>().currentSong;

    // Nếu chưa có bài hát → không hiển thị mini player
    if (currentSong == null) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          // Khi nhấn vào MiniPlayer → mở lại NowPlayingScreen với bài hát hiện tại
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NowPlayingScreen(song: currentSong),
            ),
          );
        },
        child: Container(
          height: 65,
          width: double.infinity,
          color: Colors.brown[400],
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // Ảnh bài hát
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: Image.network(
                  currentSong.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Tên bài hát & nghệ sĩ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentSong.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong.artist,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Nút phát (placeholder – bạn có thể tích hợp player để phát ở đây)
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  // Nếu bạn dùng AudioPlayer toàn cục, có thể phát từ đây
                  // Hoặc chuyển sang `NowPlayingScreen`
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
