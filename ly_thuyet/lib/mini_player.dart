import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem bàn phím có đang hiển thị không
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // Nếu đang mở bàn phím thì không hiển thị MiniPlayer
    if (isKeyboardOpen) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/nowplaying');
        },
        child: Container(
          height: 65,
          width: double.infinity,
          color: Colors.brown[400],
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // Ảnh bìa bài hát
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Image(
                  image: NetworkImage('https://via.placeholder.com/50'),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Expanded để chiếm phần còn lại, tránh tràn
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Say Yes (Vietnamese Version)',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'OgeNus, PiaLinh',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Icon play
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
