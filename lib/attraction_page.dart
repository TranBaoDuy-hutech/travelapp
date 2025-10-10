import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttractionPage extends StatefulWidget {
  const AttractionPage({super.key});

  @override
  State<AttractionPage> createState() => _AttractionPageState();
}

class _AttractionPageState extends State<AttractionPage> {
  final List<Map<String, dynamic>> attractions = [
    {
      "title": "Vịnh Hạ Long",
      "subtitle": "Khám phá kỳ quan thiên nhiên thế giới với hàng nghìn đảo đá.",
      "image": "https://qtair.vn/sites/default/files/vinh-ha-long-ve-dep-cua-ky-quan-da-3-lan-duoc-vinh-danh-la-di-san-the-gioi-1114_0.jpg",
      "location": "Quảng Ninh, Vietnam",
      "price": 200000,
      "duration": "4h",
      "rating": 4.9,
      "category": "Nature",
    },
    {
      "title": "Phố cổ Hội An",
      "subtitle": "Dạo bước trong khu phố cổ với kiến trúc độc đáo và đèn lồng rực rỡ.",
      "image": "https://hotelroyalhoian.vn/wp-content/uploads/2025/02/3-1024x675.jpg",
      "location": "Hội An, Vietnam",
      "price": 100000,
      "duration": "3h",
      "rating": 4.8,
      "category": "Cultural",
    },
    {
      "title": "Bà Nà Hills",
      "subtitle": "Trải nghiệm cáp treo và cầu Vàng nổi tiếng tại Đà Nẵng.",
      "image": "https://booking.muongthanh.com/upload_images/images/cau-vang-da-nang.jpg",
      "location": "Đà Nẵng, Vietnam",
      "price": 850000,
      "duration": "6h",
      "rating": 4.7,
      "category": "Entertainment",
    },
    {
      "title": "Phong Nha - Kẻ Bàng",
      "subtitle": "Khám phá hệ thống hang động kỳ vĩ, di sản UNESCO.",
      "image": "https://cdn.nhandan.vn/images/824d0f34e072d85d409c61d945e7d3dc0cd1a310f710495e8059c2705b9f7b41f9a4b39b327cd6499004f4f98f61e1a05cfacd5ee898d181029010948d9846a0/be08f78cbd9d09c3508c.jpg",
      "location": "Quảng Bình, Vietnam",
      "price": 300000,
      "duration": "8h",
      "rating": 4.9,
      "category": "Nature",
    },
    {
      "title": "Chùa Linh Mụ",
      "subtitle": "Tham quan ngôi chùa cổ kính bên dòng sông Hương.",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXUckWnTNKzv3N7BsnLBQJClnKyvnagqqgAw&shttps://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXUckWnTNKzv3N7BsnLBQJClnKyvnagqqgAw&s",
      "location": "Huế, Vietnam",
      "price": 50000,
      "duration": "2h",
      "rating": 4.5,
      "category": "Cultural",
    },
    {
      "title": "VinWonders Phú Quốc",
      "subtitle": "Khu vui chơi giải trí với nhiều trò chơi hấp dẫn.",
      "image": "https://phuquoctrip.com/files/images/vui-choi-phu-quoc/phu-quoc-united-center/vinwonders/vinwonder.jpg",
      "location": "Phú Quốc, Vietnam",
      "price": 900000,
      "duration": "1D",
      "rating": 4.6,
      "category": "Entertainment",
    },
    {
      "title": "Thác Bà Nà",
      "subtitle": "Thưởng ngoạn vẻ đẹp hùng vĩ của thác nước và rừng nguyên sinh.",
      "image": "https://statics.vinpearl.com/thac-ban-ba-hung-vi_1729839906.jpg",
      "location": "Đà Lạt, Vietnam",
      "price": 150000,
      "duration": "3h",
      "rating": 4.4,
      "category": "Nature",
    },
    {
      "title": "Bảo tàng Lịch sử Quốc gia",
      "subtitle": "Tìm hiểu lịch sử Việt Nam qua các hiện vật độc đáo.",
      "image": "https://statics.vinpearl.com/bao-tang-lich-su-quoc-gia-thump_1681308749.jpeg",
      "location": "Hà Nội, Vietnam",
      "price": 40000,
      "duration": "2h",
      "rating": 4.3,
      "category": "Cultural",
    },
    {
      "title": "Côn Đảo",
      "subtitle": "Khám phá thiên đường biển đảo với bãi biển hoang sơ.",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJLStr7rPa0H7PFR6idFVms28eSpJCAVmPwg&s",
      "location": "Côn Đảo, Vietnam",
      "price": 250000,
      "duration": "5h",
      "rating": 4.8,
      "category": "Nature",
    },
    {
      "title": "Công viên nước Đầm Sen",
      "subtitle": "Vui chơi giải trí với các trò chơi nước hấp dẫn.",
      "image": "https://www.damsenwaterpark.com.vn/wp-content/uploads/2011/12/khu-du-lich-dam-sen-2.webp",
      "location": "TP.HCM, Vietnam",
      "price": 200000,
      "duration": "5h",
      "rating": 4.5,
      "category": "Entertainment",
    },
  ];

  String search = "";
  String sortBy = "price";
  bool isLoading = false;
  String? selectedCategoryFilter;

  List<Map<String, dynamic>> _getFilteredAndSortedAttractions() {
    var filteredAttractions = attractions.where((attr) {
      if (selectedCategoryFilter != null) {
        return attr["category"] == selectedCategoryFilter;
      }
      return attr["title"].toLowerCase().contains(search.toLowerCase()) ||
          attr["location"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredAttractions.sort((a, b) {
      if (sortBy == "price") {
        return a["price"].compareTo(b["price"]);
      }
      return a["title"].compareTo(b["title"]);
    });

    return filteredAttractions;
  }

  @override
  Widget build(BuildContext context) {
    final filteredAttractions = _getFilteredAndSortedAttractions();
    final uniqueCategories = attractions.map((attr) => attr["category"]).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tham Quan",
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
              const PopupMenuItem(value: "title", child: Text("Sort by Title")),
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
                selectedCategoryFilter = null;
              }),
              decoration: InputDecoration(
                hintText: "Search by attraction or location...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    search = "";
                    selectedCategoryFilter = null;
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
              children: uniqueCategories.map((category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: selectedCategoryFilter == category,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategoryFilter = selected ? category : null;
                    });
                  },
                  selectedColor: Colors.teal.shade100,
                  checkmarkColor: Colors.teal.shade700,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredAttractions.isEmpty
                ? const Center(child: Text("No attractions found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredAttractions.length,
              itemBuilder: (context, index) {
                final attr = filteredAttractions[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Selected: ${attr['title']}"),
                          backgroundColor: Colors.teal.shade700,
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            attr["image"],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attr["title"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  attr["location"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  attr["subtitle"],
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
                                          "${attr['rating']}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        attr["duration"],
                                        style: TextStyle(
                                          color: Colors.teal.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi_VN',
                                    symbol: 'VND',
                                    decimalDigits: 0,
                                  ).format(attr["price"]),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.arrow_forward_ios, size: 18),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              "© 2025 Trần Bảo Duy. All rights reserved.",
              style: TextStyle(
                color: Colors.blue.shade900.withOpacity(0.7),
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}