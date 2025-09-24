import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'tour_detail_page.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({super.key});

  @override
  State<ToursPage> createState() => _ToursPageState();
}

class _ToursPageState extends State<ToursPage> with SingleTickerProviderStateMixin {
  List<dynamic> tours = [];
  List<dynamic> filteredTours = [];
  bool loading = true;
  final NumberFormat currencyFormatter = NumberFormat("#,##0", "vi_VN");
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    fetchTours();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchTours() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:8000/tours"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tours = data["data"];
          filteredTours = tours;
          loading = false;
          _animationController.forward();
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
      debugPrint("Lỗi fetch tours: $e");
    }
  }

  void filterTours(String query) {
    final q = removeDiacritics(query.toLowerCase());
    setState(() {
      filteredTours = tours.where((tour) {
        final name = removeDiacritics((tour["TourName"] ?? "").toString().toLowerCase());
        final location = removeDiacritics((tour["Location"] ?? "").toString().toLowerCase());
        return name.contains(q) || location.contains(q);
      }).toList();
    });
  }

  Widget buildTourImage(String? img, double size) {
    if (img == null || img.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
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
              color: Theme.of(context).colorScheme.surfaceVariant,
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
    }

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
            color: Theme.of(context).colorScheme.surfaceVariant,
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

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final imgSize = screenW * 0.28;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenW * 0.15),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(
                Icons.map_rounded,
                color: Colors.white,
                size: screenW * 0.07,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Danh sách tour | Việt Lữ Travel",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: screenW * 0.05,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      body: loading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      )
          : Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: filterTours,
              decoration: InputDecoration(
                hintText: "Tìm kiếm tour...",
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          // Danh sách tour
          Expanded(
            child: filteredTours.isEmpty
                ? Center(
              child: Text(
                "Không tìm thấy tour nào.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredTours.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final tour = filteredTours[index];
                String priceStr = "-";
                if (tour["Price"] != null) {
                  final parsed = double.tryParse(tour["Price"].toString()) ?? 0;
                  priceStr = "${currencyFormatter.format(parsed)} VND";
                }

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourDetailPage(tour: tour),
                      ),
                    );
                  },
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: Tween<double>(begin: 0.95, end: 1.0)
                            .animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            0.1 * index,
                            0.1 * index + 0.3,
                            curve: Curves.easeOut,
                          ),
                        ))
                            .value,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        buildTourImage(tour["ImageUrl"], imgSize),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tour["TourName"] ?? "-",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: screenW * 0.045,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tour["Location"] ?? "-",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: screenW * 0.035,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  priceStr,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: screenW * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}