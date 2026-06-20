import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Breaking News',
      'message': 'Artikel luar angkasa terbaru sudah tersedia.',
    },
    {
      'title': 'Favorite Saved',
      'message': 'Berita favorite kamu berhasil disimpan.',
    },
    {
      'title': 'Space Update',
      'message': 'NASA dan SpaceX memiliki pembaruan misi terbaru.',
    },
    {
      'title': 'Daily Feed',
      'message': 'Jangan lupa membaca berita hari ini.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: const Icon(
                  Icons.notifications,
                  color: Colors.deepPurple,
                ),
              ),
              title: Text(
                item['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(item['message']!),
            ),
          );
        },
      ),
    );
  }
}