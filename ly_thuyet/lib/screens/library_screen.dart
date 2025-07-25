import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider/user_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      final userProvider = Provider.of<UserProvider>(context);
                      final avatarUrl = userProvider.avatarUrl;
                      final fullName = userProvider.fullName;

                      return CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: (avatarUrl == null || avatarUrl.isEmpty)
                            ? Text(
                          (fullName != null && fullName.isNotEmpty)
                              ? fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white),
                        )
                            : null,
                      );
                    },
                  ),
                  const Text("Thư viện",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Row(
                    children: const [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 12),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Chip(label: Text("Danh sách phát"), backgroundColor: Colors.grey),
                  Chip(label: Text("Album"), backgroundColor: Colors.grey),
                  Chip(label: Text("Nghệ sĩ"), backgroundColor: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Danh sách mục
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network('https://via.placeholder.com/60', width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: const Text('Tên danh sách phát',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Nghệ sĩ • 51 bài hát', style: TextStyle(color: Colors.white70)),
                  );
                },
              ),
            ),

            // Mini Player
            Container(
              height: 65,
              color: Colors.blueGrey[900],
              child: ListTile(
                leading: Image.network('https://via.placeholder.com/50'),
                title: const Text('Phonecert • Hoàng Dũng',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                subtitle: const Text('MacBook Air của An', style: TextStyle(color: Colors.green, fontSize: 12)),
                trailing: const Icon(Icons.pause, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
