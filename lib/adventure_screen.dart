import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdventureScreen extends StatelessWidget {
  const AdventureScreen({super.key});

  // Data for 10 adventure tour destinations/activities in Vietnam
  static const List<Map<String, String>> _tours = [
    {
      'title': 'Hang Sơn Đoòng - Quảng Bình',
      'description': 'Thám hiểm hang động lớn nhất thế giới',
      'price': '65.000.000 VNĐ',
      'image': 'https://baodongnai.com.vn/file/e7837c02876411cd0187645a2551379f/dataimages/201610/original/images1712717_hang_son_doong.jpg', // Ảnh bên trong Hang Sơn Đoòng, ánh sáng lọt vào.
    },
    {
      'title': 'Leo núi Fansipan - Lào Cai',
      'description': 'Chinh phục đỉnh núi cao nhất Đông Dương',
      'price': '4.500.000 VNĐ',
      'image': 'https://cuongdulich.com/assets/posts/1600236948-cap-treo-fansipan-co-gi0008.jpg', // Ảnh đỉnh Fansipan, cột mốc/cảnh mây núi.
    },
    {
      'title': 'Đua thuyền Kayak - Vịnh Hạ Long',
      'description': 'Chèo thuyền khám phá vịnh di sản UNESCO',
      'price': '3.200.000 VNĐ',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO90_xtA1I1oWTosK5OkQ16p-5syGLtWgYAA&s', // Ảnh Kayak giữa các hòn đảo đá vôi Vịnh Hạ Long.
    },
    {
      'title': 'Nhảy dù - Đà Nẵng',
      'description': 'Trải nghiệm nhảy dù trên bầu trời biển Mỹ Khê',
      'price': '7.500.000 VNĐ',
      'image': 'https://vj-prod-website-cms.s3.ap-southeast-1.amazonaws.com/depositphotos724977756xl-1723513162975.jpg', // Ảnh dù lượn (Paragliding) trên biển Đà Nẵng.
    },
    {
      'title': 'Trekking Tà Năng - Phan Dũng',
      'description': 'Hành trình băng rừng vượt suối hoang sơ',
      'price': '3.800.000 VNĐ',
      'image': 'https://sinhtour.vn/wp-content/uploads/2024/07/song-lung-khung-long-ta-xua-2.jpg', // Ảnh đồi cỏ xanh, trekking, sống lưng khủng long Tà Năng.
    },
    {
      'title': 'Lặn biển - Phú Quốc',
      'description': 'Khám phá rạn san hô và thế giới dưới nước',
      'price': '2.900.000 VNĐ',
      'image': 'https://pystravel.vn/_next/image?url=https%3A%2F%2Fbooking.pystravel.vn%2Fuploads%2Fposts%2Favatar%2F1745679932.jpg&w=3840&q=75', // Ảnh lặn biển ngắm san hô, sinh vật biển.
    },
    {
      'title': 'Đua xe địa hình - Mũi Né',
      'description': 'Chinh phục đồi cát bay bằng xe địa hình',
      'price': '2.500.000 VNĐ',
      'image': 'https://phanthietvn.com/wp-content/uploads/2020/05/kinh-nghiem-du-lich-mui-ne-tu-tuc-2-ngay-1-dem-9.jpg', // Ảnh xe địa hình (Jeep/ATV) trên đồi cát Mũi Né.
    },
    {
      'title': 'Leo núi Bà Rá - Bình Phước',
      'description': 'Thử thách leo núi với cảnh quan hùng vĩ',
      'price': '2.700.000 VNĐ',
      'image': 'https://vietrektravel.com/Upload/News/Huong-Dan-Chia-Se-Kinh-Nghiem-Leo-Nui-Ba-Ra.jpg', // Ảnh leo núi/view từ đỉnh núi cao.
    },
    {
      'title': 'Đi bộ đường dài - Pù Luông',
      'description': 'Trekking qua thung lũng xanh và bản làng dân tộc',
      'price': '3.000.000 VNĐ',
      'image': 'https://h3jd9zjnmsobj.vcdn.cloud/public/mytravelmap/images/2023/5/30/legiangdesign5505/e1af89bfe0b1afc393b40abf4a8350ba.jpg', // Ảnh ruộng bậc thang hoặc thung lũng Pù Luông.
    },
    {
      'title': 'Zipline - Đà Lạt',
      'description': 'Trượt zipline qua rừng thông và thác nước',
      'price': '2.200.000 VNĐ',
      'image': 'https://vgtrides.com/wp-content/uploads/2025/05/zipline-hava-750x500.jpg', // Ảnh hoạt động mạo hiểm, đu dây/zipline qua rừng (dùng ảnh đại diện cho cảm giác mạnh).
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: const Text(
          'Khám Phá Phiêu Lưu Việt Nam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.deepOrangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Top 10 trải nghiệm phiêu lưu mạo hiểm tại Việt Nam',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final tour = _tours[index];
                  return _buildTourCard(context, tour);
                },
                childCount: _tours.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookingDialog(context),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTourCard(BuildContext context, Map<String, String> tour) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _onTourTap(context, tour),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: tour['image']!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour['title']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tour['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tour['price']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.redAccent),
                        onPressed: () => _onTourTap(context, tour),
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
  }

  void _onTourTap(BuildContext context, Map<String, String> tour) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chi tiết tour: ${tour['title']}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tìm kiếm tour phiêu lưu'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Nhập tên tour hoặc địa điểm...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Tìm kiếm'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Lọc tour phiêu lưu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Giá tiền',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Dưới 5 triệu')),
                  DropdownMenuItem(value: 'medium', child: Text('5 - 10 triệu')),
                  DropdownMenuItem(value: 'high', child: Text('Trên 10 triệu')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Loại phiêu lưu',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'trekking', child: Text('Trekking')),
                  DropdownMenuItem(value: 'water', child: Text('Thể thao nước')),
                  DropdownMenuItem(value: 'extreme', child: Text('Mạo hiểm')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đặt tour phiêu lưu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tên tour',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Số người',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Đặt ngay'),
          ),
        ],
      ),
    );
  }
}