import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screens/login_screen.dart';
import '../mini_player.dart';
import '../avatar_drawer.dart';
import '../services/provider/user_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ẩn bàn phím khi nhấn ra ngoài
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        drawer: const AvatarDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Builder(
                              builder: (context) {
                                final userProvider = Provider.of<UserProvider>(
                                  context,
                                );
                                final avatarUrl = userProvider.avatarUrl;
                                final fullName = userProvider.fullName;

                                return GestureDetector(
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey[800],
                                    backgroundImage:
                                        avatarUrl != null &&
                                                avatarUrl.isNotEmpty
                                            ? NetworkImage(avatarUrl)
                                            : null,
                                    child:
                                        (avatarUrl == null || avatarUrl.isEmpty)
                                            ? Text(
                                              (fullName != null &&
                                                      fullName.isNotEmpty)
                                                  ? fullName[0].toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                            : null,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Tìm kiếm',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),

                      // Search box
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Bạn muốn nghe gì?',
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Explore section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Khám phá nội dung mới mẻ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildExploreBox(
                              '#hip hop việt nam',
                              'https://via.placeholder.com/80x100',
                            ),
                            _buildExploreBox(
                              '#indie việt',
                              'https://via.placeholder.com/80x100',
                            ),
                            _buildExploreBox(
                              '#chill r&b',
                              'https://via.placeholder.com/80x100',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Browse All
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Duyệt tìm tất cả',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3 / 2,
                          children: const [
                            _CategoryBox(
                              title: 'Nhạc',
                              color: Colors.pink,
                              image: 'https://via.placeholder.com/80',
                            ),
                            _CategoryBox(
                              title: 'Podcast',
                              color: Colors.green,
                              image: 'https://via.placeholder.com/80',
                            ),
                            _CategoryBox(
                              title: 'Sự kiện trực tiếp',
                              color: Colors.purple,
                              image: 'https://via.placeholder.com/80',
                            ),
                            _CategoryBox(
                              title: 'Dành Cho Bạn',
                              color: Colors.deepPurple,
                              image: 'https://via.placeholder.com/80',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Mini Player đặt cố định dưới cùng
              const MiniPlayer(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildExploreBox(String title, String imageUrl) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 80,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _CategoryBox extends StatelessWidget {
  final String title;
  final Color color;
  final String image;

  const _CategoryBox({
    required this.title,
    required this.color,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            right: 8,
            child: Image.network(image, width: 40, height: 40),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
