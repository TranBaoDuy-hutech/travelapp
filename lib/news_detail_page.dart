import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const NewsDetailPage({super.key, required this.item});

  /// Hàm xử lý hiển thị ảnh (http hoặc asset)
  Widget buildNewsImage(String? img) {
    if (img == null || img.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 100);
    }

    if (img.startsWith("http")) {
      return Image.network(
        img,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 100),
      );
    } else {
      String assetPath = img;
      if (assetPath.startsWith("/assets/")) {
        assetPath = assetPath.replaceFirst("/assets/", "");
      }
      return Image.asset(
        "assets/$assetPath",
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 100),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item["Title"] ?? "Chi tiết tin tức")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNewsImage(item["ImageUrl"]?.toString()),
            const SizedBox(height: 16),
            Text(
              item["Title"] ?? "No title",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              item["Content"] ?? "Không có nội dung",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
