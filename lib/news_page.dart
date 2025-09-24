import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'news_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin {
  List news = [];
  bool loading = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    fetchNews();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:8000/news"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          news = data["data"];
          loading = false;
        });
        _animationController.forward();
      } else {
        setState(() => loading = false);
        debugPrint("❌ Lỗi backend: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => loading = false);
      debugPrint("❌ Lỗi kết nối: $e");
    }
  }

  Widget buildNewsImage(String? img, double size) {
    if (img == null || img.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.image_not_supported_rounded,
          size: size * 0.6,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    if (img.startsWith("http")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          img,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.broken_image_rounded,
              size: size * 0.6,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    } else {
      String assetPath = img.startsWith("/assets/") ? img.replaceFirst("/assets/", "") : img;
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          "assets/$assetPath",
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.image_not_supported_rounded,
              size: size * 0.6,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final imgSize = screenW * 0.28;

    return Scaffold(
      body: loading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: screenW * 0.15,
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              title: Row(
                children: [
                  Icon(
                    Icons.announcement_rounded,
                    color: Colors.white,
                    size: screenW * 0.07,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tin Tức | Việt Lữ Travel",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: screenW * 0.045,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer ?? Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = news[index];
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0.1 * index / news.length, 1.0, curve: Curves.easeInOut),
                        ),
                      ),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(0.1 * index / news.length, 1.0, curve: Curves.easeOut),
                          ),
                        ),
                        child: GestureDetector(
                          onTapDown: (_) => HapticFeedback.selectionClick(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailPage(item: item),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: buildNewsImage(item["ImageUrl"]?.toString(), imgSize),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["Title"] ?? "Không có tiêu đề",
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            item["Content"] ?? "",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: news.length,
            ),
          ),
        ],
      ),
    );
  }
}