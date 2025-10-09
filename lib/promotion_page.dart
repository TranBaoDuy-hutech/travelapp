import 'package:flutter/material.dart';

class PromotionPage extends StatelessWidget {
  const PromotionPage({super.key});

  final List<Map<String, dynamic>> promotions = const [
    {
      "title": "Giảm 20% cho tour miền Tây",
      "description": "Đặt tour miền Tây trước ngày 15/10 để nhận ưu đãi.",
      "images": [
        "assets/t110.jpg",
        "assets/t11.jpg"
      ],
      "validity": "01/10/2025 - 15/12/2025",
    },
    {
      "title": "Miễn phí tham quan 1 ngày",
      "description": "Khách hàng đăng ký tour 3 ngày 2 đêm sẽ được tham quan miễn phí 1 ngày.",
      "images": [
        "assets/t112.jpg",
        "assets/t113.jpg"
      ],
      "validity": "05/10/2025 - 20/12/2025",
    },
    {
      "title": "Voucher 500k cho khách hàng mới",
      "description": "Áp dụng cho tất cả tour trong tháng 10/2025.",
      "images": [
        "assets/t114.jpg",
        "assets/t115.jpg"
      ],
      "validity": "01/10/2025 - 31/12/2025",
    },
    {
      "title": "Giảm 15% combo tour + khách sạn",
      "description": "Combo đặc biệt mùa lễ hội.",
      "images": [
        "assets/t151.jpg",
        "assets/t152.jpg"
      ],
      "validity": "10/10/2025 - 25/12/2025",
    },
    {
      "title": "Ưu đãi cuối tuần: Free 1 bữa ăn",
      "description": "Áp dụng cho tour cuối tuần.",
      "images": [
        "assets/t153.jpg",
        "assets/t154.jpg"
      ],
      "validity": "12/10/2025 - 31/12/2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khuyến Mãi"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: promotions.length,
                itemBuilder: (context, index) {
                  final promo = promotions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carousel hình ảnh
                        SizedBox(
                          height: 180,
                          child: PageView.builder(
                            itemCount: promo["images"].length,
                            itemBuilder: (context, i) {
                              return ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  promo["images"][i],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
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
                                promo["title"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                promo["description"],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    promo["validity"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Đã nhận ưu đãi: ${promo["title"]}"),
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.local_offer),
                                  label: const Text("Nhận ưu đãi"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
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
            // Footer
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
      ),
    );
  }
}
