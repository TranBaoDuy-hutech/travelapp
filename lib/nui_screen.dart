import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NuiScreen extends StatelessWidget {
  const NuiScreen({super.key});

  // Data for 10 beautiful mountain destinations in Vietnam
  static const List<Map<String, String>> _tours = [
    {
      'title': 'Fansipan - Lào Cai',
      'description': 'Đỉnh núi cao nhất Đông Dương với cáp treo hiện đại',
      'price': '4.500.000 VNĐ',
      'image': 'https://cuongdulich.com/assets/posts/1571879766-sapa_2.jpg', // Ảnh đỉnh Fansipan, cột mốc hoặc cáp treo
    },
    {
      'title': 'Ba Vì - Hà Nội',
      'description': 'Dãy núi xanh mát gần Thủ đô, lý tưởng cho trekking',
      'price': '1.800.000 VNĐ',
      'image': 'https://cdn3.ivivu.com/2023/10/du-lich-ba-vi-ivivu-1.jpg', // Ảnh núi rừng Ba Vì, cây xanh, sương mù
    },
    {
      'title': 'Tam Đảo - Vĩnh Phúc',
      'description': 'Thị trấn sương mù với khí hậu mát mẻ quanh năm',
      'price': '2.200.000 VNĐ',
      'image': 'https://tse3.mm.bing.net/th/id/OIP.o7int_Npz0qoWKoyBj-GXQHaF6?rs=1&pid=ImgDetMain&o=7&rm=3', // Ảnh nhà thờ đá hoặc thị trấn Tam Đảo trong sương
    },
    {
      'title': 'Đà Lạt - Langbiang',
      'description': 'Đỉnh núi lãng mạn giữa cao nguyên ngàn hoa',
      'price': '2.500.000 VNĐ',
      'image': 'https://image.vietgoing.com/editor/image_iwt1637746314.jpg', // Ảnh đỉnh Langbiang hoặc toàn cảnh Đà Lạt từ trên cao
    },
    {
      'title': 'Tà Xùa - Sơn La',
      'description': 'Thiên đường săn mây với biển mây bồng bềnh',
      'price': '3.000.000 VNĐ',
      'image': 'https://vstatic.vietnam.vn/vietnam/resource/IMAGE/2025/1/18/717676bd7ce340129a710603c195f6ff', // Ảnh Tà Xùa, biển mây hoặc sống lưng khủng long
    },
    {
      'title': 'Bạch Mộc Lương Tử - Lai Châu',
      'description': 'Đỉnh núi hoang sơ dành cho dân leo núi chuyên nghiệp',
      'price': '4.200.000 VNĐ',
      'image': 'https://dulichlaichau.vn/mypicture/images/Nm2024/Thng5Trang/sua-1-bach-moc.jpg', // Ảnh đỉnh núi cao, trekking, cảnh mây núi hùng vĩ
    },
    {
      'title': 'Pù Luông - Thanh Hóa',
      'description': 'Vùng núi với thung lũng xanh và văn hóa dân tộc độc đáo',
      'price': '2.800.000 VNĐ',
      'image': 'https://image.vietgoing.com/destination/large/vietgoing_tew2112215390.webp', // Ảnh Pù Luông, ruộng bậc thang xanh
    },
    {
      'title': 'Y Tý - Lào Cai',
      'description': 'Vùng cao với cảnh sắc hùng vĩ và văn hóa Hà Nhì',
      'price': '3.500.000 VNĐ',
      'image': 'https://dulichvn.org.vn/nhaptin/uploads/images/0aruongYNhi.jpg', // Ảnh Y Tý, ruộng bậc thang hoặc nhà trình tường Hà Nhì
    },
    {
      'title': 'Hàm Rồng - Sapa',
      'description': 'Ngọn núi với tầm nhìn toàn cảnh thị trấn Sapa',
      'price': '2.300.000 VNĐ',
      'image': 'https://ticotravel.com.vn/wp-content/uploads/2022/04/Nui-Ham-Rong-Sapa-1-1024x600.jpg', // Ảnh Núi Hàm Rồng, vườn hoa hoặc view Sapa từ trên cao
    },
    {
      'title': 'Ngọc Linh - Kon Tum',
      'description': 'Ngọn núi bí ẩn với hệ sinh thái rừng nguyên sinh',
      'price': '4.800.000 VNĐ',
      'image': 'https://meey3d.com/tin-tuc/wp-content/uploads/2023/04/chinh-phuc-nui-ngoc-linh-hung-vi-niem-tu-hao-cua-2.jpeg', // Ảnh rừng nguyên sinh hoặc núi ở Tây Nguyên
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Khám Phá Núi Việt Nam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.greenAccent],
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
                'Top 10 ngọn núi đẹp nhất Việt Nam',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[900],
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
        backgroundColor: Colors.green[700],
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
                      color: Colors.green[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tour['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tour['price']!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.green),
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
        title: const Text('Tìm kiếm tour núi'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Nhập tên núi hoặc địa điểm...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.green)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
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
        title: const Text('Lọc tour núi'),
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
                  labelText: 'Độ khó',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'easy', child: Text('Dễ')),
                  DropdownMenuItem(value: 'medium', child: Text('Trung bình')),
                  DropdownMenuItem(value: 'hard', child: Text('Khó')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.green)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
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
        title: const Text('Đặt tour núi'),
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
            child: const Text('Hủy', style: TextStyle(color: Colors.green)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Đặt ngay'),
          ),
        ],
      ),
    );
  }
}