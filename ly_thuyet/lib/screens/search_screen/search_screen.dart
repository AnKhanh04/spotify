import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mini_player.dart';
import '../../avatar_drawer.dart';
import '../../services/provider/user_provider.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                                    avatarUrl != null && avatarUrl.isNotEmpty
                                        ? NetworkImage(avatarUrl)
                                        : null,
                                    child: avatarUrl == null || avatarUrl.isEmpty
                                        ? Text(
                                      (fullName != null && fullName.isNotEmpty)
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchResultScreen(),
                              ),
                            );
                          },
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
                            _buildExploreBox('#hip hop việt nam'),
                            _buildExploreBox('#indie việt'),
                            _buildExploreBox('#chill r&b'),
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
                            ),
                            _CategoryBox(
                              title: 'Podcast',
                              color: Colors.green,
                            ),
                            _CategoryBox(
                              title: 'Sự kiện trực tiếp',
                              color: Colors.purple,
                            ),
                            _CategoryBox(
                              title: 'Dành Cho Bạn',
                              color: Colors.deepPurple,
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

  static Widget _buildExploreBox(String title) {
    return Column(
      children: [
        const SizedBox(height: 100), // Giữ kích thước giống ảnh trước đây
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _CategoryBox extends StatelessWidget {
  final String title;
  final Color color;

  const _CategoryBox({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}