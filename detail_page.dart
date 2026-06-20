import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/article.dart';

class DetailPage extends StatefulWidget {
  final Article article;

  const DetailPage({
    super.key,
    required this.article,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  String get favoriteDocId {
    final user = FirebaseAuth.instance.currentUser;
    return '${user!.uid}_${widget.article.id}';
  }

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  Future<void> checkFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(favoriteDocId)
        .get();

    setState(() {
      isFavorite = doc.exists;
    });
  }

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessage('Silakan login terlebih dahulu');
      return;
    }

    final favoriteRef = FirebaseFirestore.instance
        .collection('favorites')
        .doc(favoriteDocId);

    if (isFavorite) {
      await favoriteRef.delete();

      setState(() {
        isFavorite = false;
      });

      showMessage('Berita dihapus dari favorite');
    } else {
      await favoriteRef.set({
        'articleId': widget.article.id,
        'title': widget.article.title,
        'imageUrl': widget.article.imageUrl,
        'newsSite': widget.article.newsSite,
        'summary': widget.article.summary,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        isFavorite = true;
      });

      showMessage('Berita disimpan ke favorite');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              article.imageUrl,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 260,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 80,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.newsSite,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.publishedAt,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.summary.isEmpty
                        ? 'Tidak ada ringkasan berita.'
                        : article.summary,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}