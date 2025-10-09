import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CityTourScreen extends StatelessWidget {
  const CityTourScreen({super.key});

  // Data for 10 beautiful city tour destinations in Vietnam
  static const List<Map<String, String>> _tours = [
    {
      'title': 'Hà Nội - Phố Cổ',
      'description': 'Khám phá lịch sử và văn hóa tại thủ đô ngàn năm văn hiến',
      'price': '2.500.000 VNĐ',
      'image': 'https://statics.vinpearl.com/36-pho-phuong-1_1688917165.jpg', // Ảnh Phố Cổ Hà Nội, phố xá cổ kính/Hồ Gươm.
    },
    {
      'title': 'TP. Hồ Chí Minh - Sài Gòn',
      'description': 'Trải nghiệm nhịp sống sôi động và ẩm thực đường phố',
      'price': '2.800.000 VNĐ',
      'image': 'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/anh-27.png', // Ảnh TP. Hồ Chí Minh, toà nhà Bitexco hoặc đường phố sôi động.
    },
    {
      'title': 'Huế - Cố Đô',
      'description': 'Tham quan kinh thành và thưởng thức ẩm thực Huế',
      'price': '3.000.000 VNĐ',
      'image': 'https://mia.vn/media/uploads/blog-du-lich/ghe-tham-cong-ngo-mon-kham-pha-di-san-kien-truc-duoi-trieu-nguyen-1638279393.jpg', // Ảnh Cổng Ngọ Môn/Kinh thành Huế.
    },
    {
      'title': 'Đà Nẵng - Thành phố biển',
      'description': 'Thành phố đáng sống với cầu Rồng và Bà Nà Hills',
      'price': '3.200.000 VNĐ',
      'image': 'https://sgtourism.vn/wp-content/uploads/2016/08/cau-rong-da-nang-1.jpg', // Ảnh Cầu Rồng Đà Nẵng.
    },
    {
      'title': 'Hội An - Phố cổ',
      'description': 'Dạo bước trong không gian cổ kính và đèn lồng rực rỡ',
      'price': '2.700.000 VNĐ',
      'image': 'https://cdn.xanhsm.com/2025/02/5e6c504a-le-hoi-den-long-1.jpg', // Ảnh Phố cổ Hội An với đèn lồng.
    },
    {
      'title': 'Đà Lạt - Thành phố sương mù',
      'description': 'Thành phố tình yêu với hoa và kiến trúc Pháp',
      'price': '2.900.000 VNĐ',
      'image': 'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/07/anh-da-lat.jpg', // Ảnh kiến trúc Pháp hoặc cảnh sương mù Đà Lạt.
    },
    {
      'title': 'Cần Thơ - Tây Đô',
      'description': 'Khám phá chợ nổi Cái Răng và văn hóa miền Tây',
      'price': '2.400.000 VNĐ',
      'image': 'https://bvhttdl.mediacdn.vn/291773308735864832/2023/6/16/12-1-1686903531766-16869035326441257819023.jpg', // Ảnh chợ nổi Cái Răng, Cần Thơ.
    },
    {
      'title': 'Nha Trang - Thành phố biển',
      'description': 'Tham quan Vinpearl và thưởng thức hải sản tươi ngon',
      'price': '3.100.000 VNĐ',
      'image': 'https://letsflytravel.vn/wp-content/uploads/2024/10/bien-nha-trang-1.webp', // Ảnh Vinpearl Nha Trang hoặc bãi biển trung tâm.
    },
    {
      'title': 'Quy Nhơn - Thành phố thi ca',
      'description': 'Khám phá Eo Gió và văn hóa Chăm độc đáo',
      'price': '2.600.000 VNĐ',
      'image': 'https://haidangtravel.com/image/blog/con-duong-di-bo-eo-gio.JPG', // Ảnh Eo Gió Quy Nhơn với con đường đi bộ ven biển.
    },
    {
      'title': 'Phan Thiết - Mũi Né',
      'description': 'Thành phố biển với đồi cát bay và resort sang trọng',
      'price': '2.800.000 VNĐ',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSV-Qa0lgrO4IBaSUZAKzlC7YGZ_uQk-DK4w&s', // Ảnh trải nghiệm đồi cát bay Mũi Né.
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          'Khám Phá Thành Phố Việt Nam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.amberAccent],
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
                'Top 10 thành phố tuyệt vời nhất Việt Nam',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[900],
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
        backgroundColor: Colors.orangeAccent,
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
                      color: Colors.orange[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tour['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.orange[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tour['price']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent),
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
        title: const Text('Tìm kiếm tour thành phố'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Nhập tên thành phố hoặc tour...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.orange)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
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
        title: const Text('Lọc tour thành phố'),
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
                  DropdownMenuItem(value: 'low', child: Text('Dưới 3 triệu')),
                  DropdownMenuItem(value: 'medium', child: Text('3 - 5 triệu')),
                  DropdownMenuItem(value: 'high', child: Text('Trên 5 triệu')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Loại tour',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'cultural', child: Text('Văn hóa')),
                  DropdownMenuItem(value: 'food', child: Text('Ẩm thực')),
                  DropdownMenuItem(value: 'sightseeing', child: Text('Tham quan')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.orange)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
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
        title: const Text('Đặt tour thành phố'),
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
            child: const Text('Hủy', style: TextStyle(color: Colors.orange)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Đặt ngay'),
          ),
        ],
      ),
    );
  }
}