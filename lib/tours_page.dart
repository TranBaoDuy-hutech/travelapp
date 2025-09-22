import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'tour_detail_page.dart';

class ToursPage extends StatefulWidget {
  const ToursPage({super.key});

  @override
  State<ToursPage> createState() => _ToursPageState();
}

class _ToursPageState extends State<ToursPage> {
  List<dynamic> tours = [];
  List<dynamic> filteredTours = [];
  bool loading = true;

  final NumberFormat currencyFormatter = NumberFormat("#,##0", "vi_VN");

  @override
  void initState() {
    super.initState();
    fetchTours();
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
      return Icon(Icons.image_not_supported, size: size * 0.8);
    }

    if (img.startsWith("http")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          img,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: size * 0.8),
        ),
      );
    }

    String assetPath = img.startsWith("/assets/") ? img.replaceFirst("/assets/", "") : img;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        "assets/$assetPath",
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: size * 0.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    // ảnh tour chiếm 25% chiều rộng màn hình
    final imgSize = screenW * 0.25;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenH * 0.1),
        child: AppBar(
          elevation: 8,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Row(
            children: [
              const Icon(Icons.map, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Danh sách tour | Việt Lữ Travel",
                  style: TextStyle(
                    fontSize: screenW * 0.05, // responsive font
                    fontWeight: FontWeight.bold,
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: filterTours,
              decoration: InputDecoration(
                hintText: "Tìm kiếm tour...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Danh sách tour
          Expanded(
            child: filteredTours.isEmpty
                ? const Center(child: Text("Không tìm thấy tour nào."))
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TourDetailPage(tour: tour),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        buildTourImage(tour["ImageUrl"], imgSize),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tour["TourName"] ?? "-",
                                  style: TextStyle(
                                    fontSize: screenW * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  tour["Location"] ?? "-",
                                  style: TextStyle(
                                    fontSize: screenW * 0.035,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  priceStr,
                                  style: TextStyle(
                                    fontSize: screenW * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal,
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
