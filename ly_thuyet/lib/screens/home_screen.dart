import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mini_player.dart';
import '../avatar_drawer.dart';
import '../services/user_provider.dart'; // <-- Đảm bảo bạn import đúng file

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final avatarUrl = userProvider.avatarUrl;
    final fullName = userProvider.fullName;

    return Scaffold(
      drawer: const AvatarDrawer(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabs + Avatar mở Drawer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[800],
                              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                              child: avatarUrl == null
                                  ? Text(
                                fullName != null && fullName.isNotEmpty
                                    ? fullName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(color: Colors.white),
                              )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const FilterChip(
                          label: Text('Tất cả'),
                          selected: true,
                          onSelected: null,
                          selectedColor: Colors.green,
                          labelStyle: TextStyle(color: Colors.white),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Chip(
                          label: Text('Nhạc'),
                          backgroundColor: Colors.grey,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Chip(
                          label: Text('Podcast'),
                          backgroundColor: Colors.grey,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Grid playlist
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3.5,
                      children: List.generate(8, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/playlist');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Tên playlist',
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Trending
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Những bản nhạc thịnh hành nhất hiện nay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/playlist');
                          },
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'https://via.placeholder.com/140',
                                    height: 140,
                                    width: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tên Album',
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'Tên nghệ sĩ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Mini Player cố định
            const MiniPlayer(),
          ],
        ),
      ),
    );
  }
}
