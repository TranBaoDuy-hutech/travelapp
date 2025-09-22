import 'package:flutter/material.dart';
import 'contact_page.dart';

class FeatureGridWidget extends StatelessWidget {
  const FeatureGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {"icon": Icons.flight, "title": "Chuyến bay", "color": Colors.blue},
      {"icon": Icons.hotel, "title": "Khách sạn", "color": Colors.green},
      {"icon": Icons.tour, "title": "Tour", "color": Colors.orange},
      {"icon": Icons.directions_bus, "title": "Xe khách", "color": Colors.red},
      {"icon": Icons.directions_boat, "title": "Du thuyền", "color": Colors.indigo},
      {"icon": Icons.local_offer, "title": "Khuyến mãi", "color": Colors.purple},
      {"icon": Icons.car_rental, "title": "Thuê xe", "color": Colors.teal},
      {"icon": Icons.phone, "title": "Liên hệ", "color": Colors.brown},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: GridView.builder(
        itemCount: features.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final feature = features[index];
          return _buildFeature(
            context,
            feature["icon"] as IconData,
            feature["title"] as String,
            feature["color"] as Color,
          );
        },
      ),
    );
  }

  static Widget _buildFeature(BuildContext context, IconData icon, String title, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (title == "Liên hệ") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactPage()),
          );
        } else {
          debugPrint("Tapped on $title");
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
