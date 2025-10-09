import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CruisePage extends StatefulWidget {
  const CruisePage({super.key});

  @override
  State<CruisePage> createState() => _CruisePageState();
}

class _CruisePageState extends State<CruisePage> {
  final List<Map<String, dynamic>> cruiseList = [
    {
      "name": "Vịnh Hạ Long Luxury Cruise",
      "image": "https://www.originvietnam.com/wp-content/uploads/IMG_Sea_Stars_Cruise_3_Days_banner-1536x712.jpg",
      "description": "Thưởng ngoạn kỳ quan thiên nhiên, ngắm hoàng hôn trên biển.",
      "location": "Hạ Long, Vietnam",
      "price": 2500000,
      "duration": "2D1N",
      "rating": 4.8,
      "departureDate": "2025-10-15",
      "status": "Available",
    },
    {
      "name": "Phú Quốc Sunset Cruise",
      "image": "https://cdn.queenacademy.net/2023/03/DJI_0644-scaled.jpg",
      "description": "Trải nghiệm biển đảo trong xanh, nghỉ dưỡng sang trọng.",
      "location": "Phú Quốc, Vietnam",
      "price": 3000000,
      "duration": "3D2N",
      "rating": 4.9,
      "departureDate": "2025-10-20",
      "status": "Available",
    },
    {
      "name": "Nha Trang Royal Cruise",
      "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945",
      "description": "Khám phá vịnh Nha Trang với dịch vụ 5 sao.",
      "location": "Nha Trang, Vietnam",
      "price": 2800000,
      "duration": "2D1N",
      "rating": 4.7,
      "departureDate": "2025-10-18",
      "status": "Limited Spots",
    },
    {
      "name": "Mekong Delta River Cruise",
      "image": "https://luxtour.com.vn/wp-content/uploads/2022/02/du-thuyen-ha-long-7-1.jpg",
      "description": "Khám phá sông nước miền Tây, văn hóa địa phương.",
      "location": "Cần Thơ, Vietnam",
      "price": 2000000,
      "duration": "3D2N",
      "rating": 4.5,
      "departureDate": "2025-10-22",
      "status": "Available",
    },
    {
      "name": "Lan Hạ Bay Explorer",
      "image": "https://vetauthamvinhhalong.com/wp-content/uploads/2023/02/Ambassador-Cruises-2.jpg",
      "description": "Hành trình yên bình qua vịnh Lan Hạ tuyệt đẹp.",
      "location": "Hải Phòng, Vietnam",
      "price": 2700000,
      "duration": "2D1N",
      "rating": 4.6,
      "departureDate": "2025-10-16",
      "status": "Available",
    },
    {
      "name": "Cat Ba Island Cruise",
      "image": "https://luxtour.com.vn/wp-content/uploads/2024/03/du-thuyen-ha-long-1-ngay-1.jpg",
      "description": "Khám phá đảo Cát Bà với các hoạt động kayak, bơi lội.",
      "location": "Cát Bà, Vietnam",
      "price": 2300000,
      "duration": "2D1N",
      "rating": 4.4,
      "departureDate": "2025-10-19",
      "status": "Available",
    },
    {
      "name": "Hội An Coastal Cruise",
      "image": "https://cdn.getyourguide.com/img/tour/cf10d4bd4a7fe1324b8c1ebc6e30a7a67310eba4a0451d3cdcb5be2f0750bb0f.jpg/148.jpg",
      "description": "Trải nghiệm văn hóa Hội An từ du thuyền sang trọng.",
      "location": "Hội An, Vietnam",
      "price": 2600000,
      "duration": "1D",
      "rating": 4.7,
      "departureDate": "2025-10-17",
      "status": "Limited Spots",
    },
    {
      "name": "Hue Imperial Cruise",
      "image": "https://owa.bestprice.vn/images/cruises/large/du-thuyen-catherine-65bcb97e491fa-848x477.jpg",
      "description": "Du ngoạn sông Hương, khám phá kinh thành Huế.",
      "location": "Huế, Vietnam",
      "price": 1900000,
      "duration": "1D",
      "rating": 4.3,
      "departureDate": "2025-10-21",
      "status": "Available",
    },
    {
      "name": "Vũng Tàu Ocean Cruise",
      "image": "https://www.tauhalong.vn/wp-content/uploads/2019/08/Overview-10.jpg",
      "description": "Thư giãn trên biển Vũng Tàu với dịch vụ cao cấp.",
      "location": "Vũng Tàu, Vietnam",
      "price": 2400000,
      "duration": "2D1N",
      "rating": 4.5,
      "departureDate": "2025-10-23",
      "status": "Available",
    },
    {
      "name": "Côn Đảo Paradise Cruise",
      "image": "https://images.unsplash.com/photo-1509233725247-49e657c54213",
      "description": "Khám phá thiên đường biển đảo Côn Đảo.",
      "location": "Côn Đảo, Vietnam",
      "price": 3200000,
      "duration": "3D2N",
      "rating": 4.9,
      "departureDate": "2025-10-25",
      "status": "Limited Spots",
    },
  ];

  String search = "";
  String sortBy = "price";
  bool isLoading = false;
  String? selectedLocationFilter;

  List<Map<String, dynamic>> _getFilteredAndSortedCruises() {
    var filteredCruises = cruiseList.where((cruise) {
      if (selectedLocationFilter != null) {
        return cruise["location"] == selectedLocationFilter;
      }
      return cruise["name"].toLowerCase().contains(search.toLowerCase()) ||
          cruise["location"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredCruises.sort((a, b) {
      if (sortBy == "price") {
        return a["price"].compareTo(b["price"]);
      }
      return a["name"].compareTo(b["name"]);
    });

    return filteredCruises;
  }

  @override
  Widget build(BuildContext context) {
    final filteredCruises = _getFilteredAndSortedCruises();
    final uniqueLocations = cruiseList.map((cruise) => cruise["location"]).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Du Thuyền",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              const PopupMenuItem(value: "price", child: Text("Sort by Price")),
              const PopupMenuItem(value: "name", child: Text("Sort by Name")),
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
                selectedLocationFilter = null;
              }),
              decoration: InputDecoration(
                hintText: "Search by cruise name or location...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    search = "";
                    selectedLocationFilter = null;
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
              children: uniqueLocations.map((location) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(location),
                  selected: selectedLocationFilter == location,
                  onSelected: (selected) {
                    setState(() {
                      selectedLocationFilter = selected ? location : null;
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
                : filteredCruises.isEmpty
                ? const Center(child: Text("No cruises found"))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredCruises.length,
              itemBuilder: (context, index) {
                final cruise = filteredCruises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Viewing details for ${cruise['name']}"),
                          backgroundColor: Colors.blue.shade700,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            cruise['image'],
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
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cruise['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cruise['location'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cruise['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
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
                                        "${cruise['rating']}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      cruise['duration'],
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Departure: ${cruise['departureDate']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Status: ${cruise['status']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: cruise['status'] == "Available"
                                      ? Colors.green.shade600
                                      : Colors.orange.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'vi_VN',
                                      symbol: 'VND',
                                      decimalDigits: 0,
                                    ).format(cruise['price']),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Booking ${cruise['name']}"),
                                          backgroundColor: Colors.blue.shade700,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                    child: const Text("Book Now"),
                                  ),
                                ],
                              ),
                            ],
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