import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  final List<Map<String, dynamic>> experiences = [
    {
      "title": "Hà Nội Street Food Tour",
      "subtitle": "Khám phá ẩm thực đường phố Hà Nội với các món phở, bún chả.",
      "image": "https://trieuhaotravel.vn/Uploads/files/unnamed%20(66)_2.png",
      "location": "Hà Nội, Vietnam",
      "price": 500000,
      "duration": "3h",
      "rating": 4.8,
      "category": "Culinary",
    },
    {
      "title": "Hội An Lantern Making",
      "subtitle": "Học làm đèn lồng truyền thống tại Hội An.",
      "image": "https://visitquangnam.com/wp-content/uploads/2022/11/craft-workshops-hoi-an-1.jpg",
      "location": "Hội An, Vietnam",
      "price": 350000,
      "duration": "2h",
      "rating": 4.6,
      "category": "Cultural",
    },
    {
      "title": "Sapa Trekking Adventure",
      "subtitle": "Khám phá núi rừng và bản làng ở Sapa.",
      "image": "https://maivutravel.com/wp-content/uploads/2023/10/du-lich-sapa-1.jpg",
      "location": "Sapa, Vietnam",
      "price": 800000,
      "duration": "1D",
      "rating": 4.9,
      "category": "Adventure",
    },
    {
      "title": "Mekong Delta Kayaking",
      "subtitle": "Chèo thuyền kayak qua sông nước miền Tây.",
      "image": "https://thamhiemmekong.com/wp-content/uploads/2021/11/thuyensupcantho3-1024x768.jpg",
      "location": "Cần Thơ, Vietnam",
      "price": 600000,
      "duration": "4h",
      "rating": 4.7,
      "category": "Adventure",
    },
    {
      "title": "Huế Cooking Class",
      "subtitle": "Học nấu các món ăn cung đình Huế.",
      "image": "https://cdn.tcdulichtphcm.vn/upload/1-2022/images/2022-01-07/picture-187-1641541355-464-width700height934.jpg",
      "location": "Huế, Vietnam",
      "price": 450000,
      "duration": "3h",
      "rating": 4.5,
      "category": "Culinary",
    },
    {
      "title": "Đà Lạt Countryside Cycling",
      "subtitle": "Đạp xe khám phá vùng nông thôn Đà Lạt.",
      "image": "https://tse2.mm.bing.net/th/id/OIP.g8x9l0MGE5ofjFEqFUKNkQHaEL?rs=1&pid=ImgDetMain&o=7&rm=3",
      "location": "Đà Lạt, Vietnam",
      "price": 400000,
      "duration": "4h",
      "rating": 4.6,
      "category": "Adventure",
    },
    {
      "title": "Phú Quốc Snorkeling",
      "subtitle": "Lặn ngắm san hô tại biển Phú Quốc.",
      "image": "https://statics.vinpearl.com/lan-bien-phu-quoc-5_1628671421.jpg",
      "location": "Phú Quốc, Vietnam",
      "price": 700000,
      "duration": "5h",
      "rating": 4.8,
      "category": "Adventure",
    },
    {
      "title": "Nha Trang Pottery Workshop",
      "subtitle": "Trải nghiệm làm gốm truyền thống Nha Trang.",
      "image": "https://nhatrangxua.net/wp-content/uploads/2024/12/2G1A9644.jpg",
      "location": "Nha Trang, Vietnam",
      "price": 300000,
      "duration": "2h",
      "rating": 4.4,
      "category": "Cultural",
    },
    {
      "title": "Hạ Long Bay Kayaking",
      "subtitle": "Chèo thuyền khám phá kỳ quan Vịnh Hạ Long.",
      "image": "https://vivuhalong.com/wp-content/uploads/2024/02/hang-luon-ha-long.jpg",
      "location": "Hạ Long, Vietnam",
      "price": 650000,
      "duration": "4h",
      "rating": 4.9,
      "category": "Adventure",
    },
    {
      "title": "Đà Nẵng Night Market Tour",
      "subtitle": "Khám phá chợ đêm Đà Nẵng và ẩm thực địa phương.",
      "image": "https://danangfantasticity.com/wp-content/uploads/2019/06/cho-dem-heliodiem-qua-5-khu-cho-dem-noi-tieng-nhat-da-nang.jpg",
      "location": "Đà Nẵng, Vietnam",
      "price": 400000,
      "duration": "3h",
      "rating": 4.7,
      "category": "Culinary",
    },
  ];

  String search = "";
  String sortBy = "price";
  bool isLoading = false;
  String? selectedCategoryFilter;

  List<Map<String, dynamic>> _getFilteredAndSortedExperiences() {
    var filteredExperiences = experiences.where((exp) {
      if (selectedCategoryFilter != null) {
        return exp["category"] == selectedCategoryFilter;
      }
      return exp["title"].toLowerCase().contains(search.toLowerCase()) ||
          exp["location"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredExperiences.sort((a, b) {
      if (sortBy == "price") {
        return a["price"].compareTo(b["price"]);
      }
      return a["title"].compareTo(b["title"]);
    });

    return filteredExperiences;
  }

  @override
  Widget build(BuildContext context) {
    final filteredExperiences = _getFilteredAndSortedExperiences();
    final uniqueCategories = experiences.map((exp) => exp["category"]).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trải Nghiệm",
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
                hintText: "Search by experience or location...",
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
                  selectedColor: Colors.orange.shade100,
                  checkmarkColor: Colors.orange.shade700,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredExperiences.isEmpty
                ? const Center(child: Text("No experiences found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExperiences.length,
              itemBuilder: (context, index) {
                final exp = filteredExperiences[index];
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
                          content: Text("Selected: ${exp['title']}"),
                          backgroundColor: Colors.orange.shade700,
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            exp["image"],
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
                                  exp["title"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exp["location"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  exp["subtitle"],
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
                                          "${exp['rating']}",
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
                                        color: Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        exp["duration"],
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
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
                                  ).format(exp["price"]),
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
        ],
      ),
    );
  }
}