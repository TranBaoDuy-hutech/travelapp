import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  // Data for 10 family-friendly tour destinations in Vietnam
  static const List<Map<String, String>> _tours = [
    {
      'title': 'Phú Quốc - Thiên đường gia đình',
      'description': 'Resort biển sang trọng với công viên nước và hoạt động gia đình',
      'price': '4.500.000 VNĐ',
      'image': 'https://pullmanphuquoc.com/wp-content/uploads/sites/225/2022/05/Exrerior_8.jpg', // Ảnh resort sang trọng và hồ bơi/bãi biển Phú Quốc.
    },
    {
      'title': 'Đà Nẵng - Bà Nà Hills',
      'description': 'Công viên giải trí với cáp treo và làng Pháp cổ tích',
      'price': '3.800.000 VNĐ',
      'image': 'https://media.mia.vn/uploads/blog-du-lich/lich-trinh-kham-pha-ba-na-hills-tu-tuc-trong-1-ngay-01-1637077043.jpeg', // Ảnh Làng Pháp hoặc Cầu Vàng Bà Nà Hills.
    },
    {
      'title': 'Nha Trang - Vinpearl Land',
      'description': 'Công viên giải trí trên đảo với tàu lượn và thủy cung',
      'price': '3.200.000 VNĐ',
      'image': 'https://statics.vinpearl.com/banh-xe-bau-troi-vinpearl-nha-trang_1714711591.jpg', // Ảnh VinWonders (Vinpearl Land) Nha Trang.
    },
    {
      'title': 'Đà Lạt - Thành phố hoa',
      'description': 'Vườn hoa, hồ Xuân Hương và chợ đêm gia đình',
      'price': '2.900.000 VNĐ',
      'image': 'https://freshdalat.vn/wp-content/uploads/2023/09/gioi-thieu-ve-ho-xuan-huong-o-da-lat.jpg', // Ảnh Vườn hoa/Hồ Xuân Hương Đà Lạt.
    },
    {
      'title': 'Vịnh Hạ Long - Du thuyền gia đình',
      'description': 'Hành trình ngắm cảnh với hoạt động bơi lội và câu cá',
      'price': '5.000.000 VNĐ',
      'image': 'https://vcdn1-dulich.vnecdn.net/2020/05/05/duthuyenhalong-1588676332-5897-1588676390.jpg?w=1200&h=0&q=100&dpr=1&fit=crop&s=Y8RDBzcgn0ZOcNDQjB4ZWA', // Ảnh Du thuyền sang trọng trên Vịnh Hạ Long.
    },
    {
      'title': 'Hội An - Phố cổ đèn lồng',
      'description': 'Trải nghiệm văn hóa với lễ thả đèn và ẩm thực gia đình',
      'price': '2.700.000 VNĐ',
      'image': 'https://tourhoian.vn/wp-content/uploads/2021/10/Th%E1%BA%A3-%C4%91%C3%A8n-hoa-%C4%91%C4%83ng-H%E1%BB%99i-An.png', // Ảnh thả đèn hoa đăng trên sông Hoài Hội An.
    },
    {
      'title': 'Cần Thơ - Chợ nổi Cái Răng',
      'description': 'Khám phá miền Tây với thuyền bè và văn hóa sông nước',
      'price': '2.500.000 VNĐ',
      'image': 'https://statics.vinpearl.com/Cai-rang-floating-market-1_1648281041.jpg', // Ảnh chợ nổi Cái Răng, thuyền bán trái cây.
    },
    {
      'title': 'Vũng Tàu - Bãi biển gia đình',
      'description': 'Nghỉ dưỡng biển gần Sài Gòn với công viên nước và hải sản',
      'price': '2.200.000 VNĐ',
      'image': 'https://palacelonghairesort.vn/wp-content/uploads/2025/06/resort-vung-tau-view-bien-1.jpg', // Ảnh bãi biển/hồ bơi resort Vũng Tàu.
    },
    {
      'title': 'Hà Nội - Sun World',
      'description': 'Công viên giải trí với tàu lượn và vườn thú',
      'price': '2.400.000 VNĐ',
      'image': 'https://www.homepaylater.vn/static/9dd3ec63cb9ecd6907b876ca73f68db8/17514/2_sun_wheel_ha_long_la_dia_diem_check_in_duoc_gioi_tre_san_lung_1_f5f4c9f750.jpg', // Ảnh công viên giải trí/vòng quay mặt trời.
    },
    {
      'title': 'Sapa - Văn hóa dân tộc',
      'description': 'Tham quan bản làng và ruộng bậc thang an toàn cho gia đình',
      'price': '3.500.000 VNĐ',
      'image': 'https://cdn.nhandan.vn/images/78d92bfef5333421c1cfa9f19aa2572af2f6454a381555b801846adcfda202211ca5d6ce4cb90349118222b2eb785751625f5d3fee48b8f6ea31427b6b73886b80118d2319ee834bcd42df8f049861ea/d77f54b1793ef5b2c46f5cbf171aa0ec.jpg', // Ảnh ruộng bậc thang và bản làng Sapa.
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: const Text(
          'Khám Phá Tour Gia Đình',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.purpleAccent],
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
                'Top 10 tour du lịch gia đình tuyệt vời tại Việt Nam',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.purple[900],
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
        backgroundColor: Colors.purple,
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
                      color: Colors.purple[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tour['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.purple[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tour['price']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.purple[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.purpleAccent),
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
        title: const Text('Tìm kiếm tour gia đình'),
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
            child: const Text('Hủy', style: TextStyle(color: Colors.purple)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
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
        title: const Text('Lọc tour gia đình'),
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
                  DropdownMenuItem(value: 'beach', child: Text('Biển')),
                  DropdownMenuItem(value: 'theme', child: Text('Giải trí')),
                  DropdownMenuItem(value: 'cultural', child: Text('Văn hóa')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.purple)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
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
        title: const Text('Đặt tour gia đình'),
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
                  labelText: 'Số người (bao gồm trẻ em)',
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
            child: const Text('Hủy', style: TextStyle(color: Colors.purple)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Đặt ngay'),
          ),
        ],
      ),
    );
  }
}