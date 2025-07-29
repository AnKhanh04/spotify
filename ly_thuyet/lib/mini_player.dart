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

    if (currentSong == null) return const SizedBox.shrink();

    print('MiniPlayer - Artist: ${currentSong.artist}, Full Data: ${currentSong.toJson()}');

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
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
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: Image.network(
                  currentSong.imageUrl,
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
              const SizedBox(width: 12),
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
                      currentSong.artist.isEmpty ? 'Unknown Artist' : currentSong.artist,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}