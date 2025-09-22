import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking_page.dart';

class TourDetailPage extends StatelessWidget {
  final Map<String, dynamic> tour;

  const TourDetailPage({Key? key, required this.tour}) : super(key: key);

  String formatPrice(dynamic price) {
    if (price == null) return "-";
    final formatter = NumberFormat("#,##0", "vi_VN");
    final parsed = double.tryParse(price.toString()) ?? 0;
    return "${formatter.format(parsed)} VND";
  }

  Widget buildTourImage(String? img) {
    if (img == null || img.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 200);
    }

    if (img.startsWith("http")) {
      return Image.network(
        img,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 200),
      );
    }

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
      const Icon(Icons.image_not_supported, size: 200),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tour["TourName"] ?? "Chi tiết Tour")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTourImage(tour["ImageUrl"]),
            const SizedBox(height: 16),
            buildInfoRow(Icons.flag, "Tên tour", tour["TourName"] ?? "-"),
            buildInfoRow(Icons.place, "Địa điểm", tour["Location"] ?? "-"),
            buildInfoRow(Icons.attach_money, "Giá", formatPrice(tour["Price"])),
            buildInfoRow(Icons.schedule, "Thời gian", "${tour["DurationDays"] ?? "-"} ngày"),
            buildInfoRow(Icons.calendar_today, "Ngày khởi hành", tour["StartDate"] ?? "-"),
            buildInfoRow(Icons.directions_bus, "Điểm xuất phát", tour["DepartureLocation"] ?? "-"),
            buildInfoRow(Icons.hotel, "Khách sạn", tour["HotelName"] ?? "-"),
            buildInfoRow(Icons.local_fire_department, "Tour Hot", (tour["IsHot"] == true) ? "Có" : "Không"),
            buildInfoRow(Icons.map, "Phương tiện", tour["Transportation"] ?? "-"),
            if (tour["Itinerary"] != null && tour["Itinerary"] != "")
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.description, size: 22, color: Colors.blueAccent),
                        SizedBox(width: 8),
                        Text(
                          "Lịch trình:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ..._splitItineraryByDay(tour["Itinerary"] ?? "").map(
                          (line) {
                        final regex = RegExp(r'^(Ngày\s*\d+:?)', caseSensitive: false);
                        final match = regex.firstMatch(line);
                        if (match != null) {
                          String day = match.group(0)!;
                          String rest = line.substring(match.end).trim();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10), // tăng khoảng cách
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: day + " ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: rest,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              line,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),
            // Nút đặt tour
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(tour: tour),
                    ),
                  );
                },
                child: const Text("Đặt Tour"),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
List<String> _splitItineraryByDay(String itinerary) {
  // Regex tìm "Ngày" và tách
  final regex = RegExp(r'(Ngày\s*\d+:?)', caseSensitive: false);
  final matches = regex.allMatches(itinerary).toList();

  if (matches.isEmpty) return [itinerary];

  List<String> result = [];
  for (int i = 0; i < matches.length; i++) {
    int start = matches[i].start;
    int end = (i + 1 < matches.length) ? matches[i + 1].start : itinerary.length;
    result.add(itinerary.substring(start, end));
  }
  return result;
}
