import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../model/songs_model.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  const NowPlayingScreen({super.key, required this.song});
  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}


class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(
      'https://res.cloudinary.com/dpaobwox0/video/upload/v1753124890/Mu%E1%BB%99n_R%E1%BB%93i_M%C3%A0_Sao_C%C3%B2n_-_S%C6%A1n_T%C3%B9ng_M-TP_youtube_omdem5.mp4',
    );
    _audioPlayer.play();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          )
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white24,
                  offset: Offset(0, 10),
                  blurRadius: 30,
                )
              ],
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://res.cloudinary.com/dpaobwox0/image/upload/v1753124802/S%C6%A1n_T%C3%B9ng_M-TP_-_Mu%E1%BB%99n_r%E1%BB%93i_m%C3%A0_sao_c%C3%B2n_uym0hk.png',
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              children: [
                Text(
                  'Muộn rồi mà sao còn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sơn Tùng M-TP',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioPlayer.duration ?? Duration(seconds: 1);
              return Column(
                children: [
                  Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position), style: const TextStyle(color: Colors.white70)),
                        Text(_formatDuration(duration), style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle, color: Colors.white)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40)),
              IconButton(
                onPressed: () async {
                  if (_audioPlayer.playing) {
                    await _audioPlayer.pause();
                  } else {
                    await _audioPlayer.play();
                  }
                  setState(() {});
                },
                icon: Icon(
                  _audioPlayer.playing ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 40)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.repeat, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
