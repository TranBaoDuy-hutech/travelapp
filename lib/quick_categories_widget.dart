import 'package:flutter/material.dart';

import 'adventure_screen.dart';
import 'bien_screen.dart';
import 'city_tour_screen.dart';
import 'family_screen.dart';
import 'nui_screen.dart';

final List<Map<String, dynamic>> categories = [
  {"name": "Biển", "icon": Icons.beach_access},
  {"name": "Núi", "icon": Icons.terrain},
  {"name": "City Tour", "icon": Icons.location_city},
  {"name": "Adventure", "icon": Icons.hiking},
  {"name": "Family", "icon": Icons.family_restroom},
];

class QuickCategoriesWidget extends StatefulWidget {
  final Function(String category)? onCategoryTap;
  const QuickCategoriesWidget({super.key, this.onCategoryTap});

  @override
  State<QuickCategoriesWidget> createState() => _QuickCategoriesWidgetState();
}

class _QuickCategoriesWidgetState extends State<QuickCategoriesWidget> {
  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category["name"] == selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() => selectedCategory = category["name"]);

              if (category["name"] == "Biển") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SeaScreen()));
              } else if (category["name"] == "Núi") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NuiScreen()));
              } else if (category["name"] == "City Tour") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CityTourScreen()));
              } else if (category["name"] == "Adventure") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdventureScreen()));
              } else if (category["name"] == "Family") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyScreen()));
              }

              widget.onCategoryTap?.call(category["name"]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
                border: isSelected ? Border.all(color: Colors.teal, width: 2) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category["icon"], size: 36, color: isSelected ? Colors.teal : Colors.grey[700]),
                  const SizedBox(height: 8),
                  Text(
                    category["name"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.teal[800] : Colors.grey[800],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
