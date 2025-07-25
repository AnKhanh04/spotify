import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../model/songs_model.dart';
import '../services/provider/current_song_provider.dart';

class NowPlayingScreen extends StatefulWidget {
  final Song song;
  const NowPlayingScreen({super.key, required this.song});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initPlayer();

    // ✅ Cập nhật trạng thái isPlaying theo thời gian thực
    _audioPlayer.playingStream.listen((isPlayingNow) {
      setState(() {
        isPlaying = isPlayingNow;
      });
    });
  }

  Future<void> _initPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<CurrentSongProvider>(context, listen: false);

    final savedSongJson = prefs.getString('current_song');
    final savedPositionMillis = prefs.getInt('current_position') ?? 0;
    final wasPlaying = prefs.getBool('is_playing') ?? true;

    bool isSameSong = false;

    if (savedSongJson != null) {
      final savedSongMap = jsonDecode(savedSongJson);
      final savedSong = Song.fromJson(savedSongMap);
      isSameSong = savedSong.id == widget.song.id;
    }

    await _audioPlayer.stop();

    final duration = await _audioPlayer.setUrl(widget.song.audioUrl);
    if (duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không phát được bài hát này')),
      );
      return;
    }

    if (isSameSong && savedPositionMillis > 0) {
      await _audioPlayer.seek(Duration(milliseconds: savedPositionMillis));
      if (wasPlaying) await _audioPlayer.play();
    } else {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    }

    // 🧠 Cập nhật provider với bài hát mới
    provider.setCurrentSong(widget.song);
    prefs.setBool('is_playing', true);

    // ✅ Ghi nhận tiến trình liên tục
    _audioPlayer.positionStream.listen((position) async {
      provider.updatePosition(position);
      prefs.setInt('current_position', position.inMilliseconds);
      prefs.setBool('is_playing', _audioPlayer.playing);
    });

    setState(() {
      isPlaying = true;
    });
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
          onPressed: () => Navigator.pop(context),
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
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.song.imageUrl),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              children: [
                Text(
                  widget.song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.song.artist,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
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

                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('is_playing', _audioPlayer.playing);
                },
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
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
