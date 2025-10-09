import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  final List<Map<String, dynamic>> hotels = [
    {
      "name": "Riverside Hotel",
      "image": "https://acihome.vn/uploads/15/thiet-ke-khach-san-ven-bien-dang-cap-nghi-duong-5-sao-tien-nghi-hien-dai-3.jpg",
      "rating": 4.5,
      "price": 120,
      "location": "Hà Nội, Vietnam",
      "amenities": ["Free Wi-Fi", "Pool", "Spa"],
      "status": "Available",
    },
    {
      "name": "Sunshine Resort",
      "image": "https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9",
      "rating": 4.0,
      "price": 90,
      "location": "Đà Nẵng, Vietnam",
      "amenities": ["Beachfront", "Gym", "Restaurant"],
      "status": "Available",
    },
    {
      "name": "Blue Sky Hotel",
      "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945",
      "rating": 4.8,
      "price": 150,
      "location": "TP. HCM, Vietnam",
      "amenities": ["Rooftop Bar", "Free Breakfast", "Parking"],
      "status": "Limited Rooms",
    },
    {
      "name": "Luxury Palace",
      "image": "https://top10vn.org/wp-content/uploads/2021/08/khach-san-5-sao-o-ha-noi.jpg",
      "rating": 5.0,
      "price": 200,
      "location": "Phú Quốc, Vietnam",
      "amenities": ["Private Beach", "Spa", "Infinity Pool"],
      "status": "Available",
    },
    {
      "name": "Golden Lotus Hotel",
      "image": "https://acihome.vn/wp-content/uploads/2020/02/thiet-ke-khach-san-4-sao-tai-hai-hoa-4-sao-ben-thanh-paradise-hotel-2.jpg",
      "rating": 4.2,
      "price": 110,
      "location": "Huế, Vietnam",
      "amenities": ["Free Wi-Fi", "Restaurant", "Garden"],
      "status": "Available",
    },
    {
      "name": "Ocean Breeze Resort",
      "image": "https://images.unsplash.com/photo-1596436889106-be35e843f974",
      "rating": 4.7,
      "price": 180,
      "location": "Nha Trang, Vietnam",
      "amenities": ["Beachfront", "Pool", "Spa"],
      "status": "Limited Rooms",
    },
    {
      "name": "Silver Star Hotel",
      "image": "https://motortrip.vn/wp-content/uploads/2022/03/khach-san-14.jpg",
      "rating": 4.3,
      "price": 100,
      "location": "Hà Nội, Vietnam",
      "amenities": ["Gym", "Free Breakfast", "Parking"],
      "status": "Available",
    },
    {
      "name": "Paradise Inn",
      "image": "https://images.unsplash.com/photo-1596394516093-501ba68a0ba6",
      "rating": 4.6,
      "price": 130,
      "location": "Đà Lạt, Vietnam",
      "amenities": ["Garden", "Free Wi-Fi", "Restaurant"],
      "status": "Available",
    },
    {
      "name": "Crystal Bay Hotel",
      "image": "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
      "rating": 4.9,
      "price": 170,
      "location": "Vũng Tàu, Vietnam",
      "amenities": ["Beachfront", "Rooftop Bar", "Pool"],
      "status": "Available",
    },
    {
      "name": "Majestic Villa",
      "image": "https://vinapad.com/wp-content/uploads/2018/12/sanh-khach-san-2.jpg",
      "rating": 4.4,
      "price": 140,
      "location": "Sapa, Vietnam",
      "amenities": ["Mountain View", "Spa", "Free Breakfast"],
      "status": "Limited Rooms",
    },
  ];

  String search = "";
  String sortBy = "rating";
  bool isLoading = false;
  double? selectedRatingFilter;

  List<Map<String, dynamic>> _getFilteredAndSortedHotels() {
    var filteredHotels = hotels.where((hotel) {
      if (selectedRatingFilter != null) {
        return hotel["rating"] >= selectedRatingFilter!;
      }
      return hotel["name"].toLowerCase().contains(search.toLowerCase()) ||
          hotel["location"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredHotels.sort((a, b) {
      if (sortBy == "price") {
        return a["price"].compareTo(b["price"]);
      }
      return b["rating"].compareTo(a["rating"]); // Higher rating first
    });

    return filteredHotels;
  }

  @override
  Widget build(BuildContext context) {
    final filteredHotels = _getFilteredAndSortedHotels();
    final ratingFilters = [4.0, 4.5, 5.0];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Khách Sạn"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "rating", child: Text("Sort by Rating")),
              const PopupMenuItem(value: "price", child: Text("Sort by Price")),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() {
                search = value;
                selectedRatingFilter = null;
              }),
              decoration: InputDecoration(
                hintText: "Search by hotel name or location...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    search = "";
                    selectedRatingFilter = null;
                  }),
                )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ratingFilters.map((rating) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text("${rating}★+"),
                  selected: selectedRatingFilter == rating,
                  onSelected: (selected) {
                    setState(() {
                      selectedRatingFilter = selected ? rating : null;
                    });
                  },
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue.shade700,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredHotels.isEmpty
                ? const Center(child: Text("No hotels found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = filteredHotels[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Image.network(
                          hotel["image"],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 180,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel["name"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hotel["location"],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              children: hotel["amenities"].map<Widget>((amenity) {
                                return Chip(
                                  label: Text(
                                    amenity,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.blue.shade50,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${hotel["rating"]}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'en_US',
                                    symbol: '\$',
                                    decimalDigits: 0,
                                  ).format(hotel["price"]),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text("/night"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Status: ${hotel["status"]}",
                              style: TextStyle(
                                fontSize: 14,
                                color: hotel["status"] == "Available"
                                    ? Colors.green.shade600
                                    : Colors.orange.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  debugPrint("Booking ${hotel["name"]}");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                ),
                                child: const Text(
                                  "Book Now",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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