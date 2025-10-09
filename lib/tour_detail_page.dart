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
    return Hero(
      tag: tour["TourName"] ?? "tour_image",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: img == null || img.isEmpty
              ? const Icon(Icons.image_not_supported, size: 100, color: Colors.grey)
              : img.startsWith("http")
              ? Image.network(
            img,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image,
              size: 100,
              color: Colors.grey,
            ),
          )
              : Image.asset(
            "assets/${img.replaceFirst("/assets/", "")}",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              size: 100,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tour["TourName"] ?? "Chi tiết Tour",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTourImage(tour["ImageUrl"]),
                  const SizedBox(height: 16),
                  const Text(
                    "Thông tin Tour",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildInfoRow(Icons.flag, "Tên tour", tour["TourName"] ?? "-"),
                  buildInfoRow(Icons.place, "Địa điểm", tour["Location"] ?? "-"),
                  buildInfoRow(Icons.attach_money, "Giá", formatPrice(tour["Price"])),
                  buildInfoRow(Icons.schedule, "Thời gian", "${tour["DurationDays"] ?? "-"} ngày"),
                  buildInfoRow(Icons.calendar_today, "Ngày khởi hành", tour["StartDate"] ?? "-"),
                  buildInfoRow(Icons.directions_bus, "Điểm xuất phát", tour["DepartureLocation"] ?? "-"),
                  buildInfoRow(Icons.hotel, "Khách sạn", tour["HotelName"] ?? "-"),
                  buildInfoRow(Icons.local_fire_department, "Tour Hot", (tour["IsHot"] == true) ? "Có" : "Không"),
                  buildInfoRow(Icons.map, "Phương tiện", tour["Transportation"] ?? "-"),
                ],
              ),
            ),
          ),
          if (tour["Itinerary"] != null && tour["Itinerary"] != "")
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(top: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.description, size: 24, color: Colors.blueAccent),
                        SizedBox(width: 12),
                        Text(
                          "Lịch trình",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._splitItineraryByDay(tour["Itinerary"] ?? "").map(
                          (line) {
                        final regex = RegExp(r'^(Ngày\s*\d+:?)', caseSensitive: false);
                        final match = regex.firstMatch(line);
                        if (match != null) {
                          String day = match.group(0)!;
                          String rest = line.substring(match.end).trim();
                          return ExpansionTile(
                            title: Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  rest,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ),
                            ],
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            line,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 5,
              ),
              child: const Text("Đặt Tour Ngay"),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

List<String> _splitItineraryByDay(String itinerary) {
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