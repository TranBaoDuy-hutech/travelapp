import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PromoBannerWidget extends StatefulWidget {
  const PromoBannerWidget({super.key});

  @override
  State<PromoBannerWidget> createState() => _PromoBannerWidgetState();
}

class _PromoBannerWidgetState extends State<PromoBannerWidget> {
  final List<Map<String, String>> banners = [
    {
      "image": "assets/b7.jpg",
      "title": "Tour Di sản miền Trung - HUTECH",
      "subtitle": "Thực tập tour miền Trung - hành trình di sản"
    },
    {
      "image": "assets/b6.jpg",
      "title": "Tour Di sản miền Trung - HUTECH",
      "subtitle": "Tham quan Đại Nội Huế – Hành trình về cố đô"
    },
    {
      "image": "assets/b8.jpg",
      "title": "Tour Di sản miền Trung - HUTECH",
      "subtitle": "Khám phá Động Thiên Đường – Kỳ quan lòng đất"
    },
    {
      "image": "assets/b9.jpg",
      "title": "Tour Di sản miền Trung - HUTECH",
      "subtitle": "Trải nghiệm Bà Nà Hills – Lâu đài trên mây"
    },
    {
      "image": "assets/b1.jpg",
      "title": "Khám phá Phú Quốc",
      "subtitle": "Ưu đãi đặc biệt cho sinh viên"
    },
    {
      "image": "assets/b2.jpg",
      "title": "Vịnh Hạ Long – Hành trình trải nghiệm",
      "subtitle": "Du thuyền sang trọng 3N2Đ"
    },
    {
      "image": "assets/b3.jpg",
      "title": "Phong Nha - Kẻ Bàng kỳ vĩ",
      "subtitle": "Chuyến đi trải nghiệm của sinh viên HUTECH"
    },
    {
      "image": "assets/b4.jpg",
      "title": "Đà Lạt – Thành phố sương mù",
      "subtitle": "Khám phá cùng đoàn HUTECH"
    },
    {
      "image": "assets/b5.png",
      "title": "Du lịch mùa lễ hội",
      "subtitle": "Chương trình đặc biệt cho sinh viên HUTECH"
    },
  ];


  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: banners.map((banner) {
            return GestureDetector(
              onTap: () {
                debugPrint("Clicked on ${banner['title']}");
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      banner['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner['title']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner['subtitle']!,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
