import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SeaScreen extends StatelessWidget {
  const SeaScreen({super.key});

  // Data for 10 beautiful beach destinations in Vietnam
  static const List<Map<String, String>> _tours = [
    {
      'title': 'Vịnh Hạ Long',
      'description': 'Di sản UNESCO với hàng ngàn đảo đá vôi kỳ vĩ',
      'price': '6.500.000 VNĐ',
      'image': 'https://ik.imagekit.io/tvlk/blog/2022/10/kinh-nghiem-du-lich-vinh-ha-long-3.jpg?tr=dpr-2,w-675', // Ảnh Vịnh Hạ Long, vịnh biển với núi đá vôi
    },
    {
      'title': 'Bãi biển Nha Trang',
      'description': 'Vịnh biển xanh mát với cát trắng mịn',
      'price': '3.800.000 VNĐ',
      'image': 'https://th.bing.com/th/id/R.966392878fff0d549c42218f5ffcfc80?rik=1PPPXz%2f2Ss7J8g&pid=ImgRaw&r=0', // Ảnh Bãi biển Nha Trang, bãi biển dài, thành phố
    },
    {
      'title': 'Đảo Phú Quốc',
      'description': 'Thiên đường nghỉ dưỡng với bãi Sao tuyệt đẹp',
      'price': '5.200.000 VNĐ',
      'image': 'https://vietnam.travel/sites/default/files/inline-images/du-lich-phu-quoc-thang-10-.jpeg', // Ảnh Bãi Sao Phú Quốc, bãi cát trắng, dừa nghiêng
    },
    {
      'title': 'Đà Nẵng - Biển Mỹ Khê',
      'description': 'Bãi biển được Forbes vinh danh đẹp nhất hành tinh',
      'price': '4.000.000 VNĐ',
      'image': 'https://static.vinwonders.com/2022/03/bai-bien-da-nang-1.jpeg', // Ảnh Biển Mỹ Khê, bãi cát rộng, thành phố xa
    },
    {
      'title': 'Côn Đảo',
      'description': 'Vùng biển hoang sơ với hệ sinh thái biển đa dạng',
      'price': '7.000.000 VNĐ',
      'image': 'https://tse4.mm.bing.net/th/id/OIP.eYhabvzAKPQgFo4BBIKgpQHaE7?rs=1&pid=ImgDetMain&o=7&rm=3', // Ảnh Côn Đảo, biển xanh, bãi đá/hoang sơ
    },
    {
      'title': 'Lý Sơn',
      'description': 'Hòn đảo núi lửa với vương quốc tỏi biển',
      'price': '4.500.000 VNĐ',
      'image': 'https://tse1.mm.bing.net/th/id/OIP.nN3pMQTUOEaKdIH2U3289AHaFj?rs=1&pid=ImgDetMain&o=7&rm=3', // Ảnh Đảo Lý Sơn, cánh đồng tỏi hoặc núi lửa sát biển
    },
    {
      'title': 'Mũi Né',
      'description': 'Cát vàng và sóng biển lý tưởng cho lướt ván',
      'price': '3.200.000 VNĐ',
      'image': 'https://static.vinwonders.com/production/lang-chai-mui-ne-top-banner.jpg', // Ảnh Đồi Cát Mũi Né hoặc bãi biển có lướt ván
    },
    {
      'title': 'Vũng Tàu - Bãi Sau',
      'description': 'Bãi biển gần Sài Gòn với không khí sôi động',
      'price': '2.800.000 VNĐ',
      'image': 'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2023/1/7/1135434/DSC09213.JPG', // Ảnh Bãi Sau Vũng Tàu, bãi biển đông đúc/thành phố
    },
    {
      'title': 'Hội An - Biển Cửa Đại',
      'description': 'Biển xanh kết hợp với phố cổ lãng mạn',
      'price': '3.600.000 VNĐ',
      'image': 'https://tse2.mm.bing.net/th/id/OIP.Zabtdd5RWgjsbaMwiG3OiAHaEK?rs=1&pid=ImgDetMain&o=7&rm=3', // Ảnh Biển Cửa Đại hoặc một góc biển Hội An
    },
    {
      'title': 'Quy Nhơn - Kỳ Co',
      'description': 'Bãi biển hoang sơ với nước trong xanh như ngọc',
      'price': '4.300.000 VNĐ',
      'image': 'https://ik.imagekit.io/tvlk/blog/2022/06/dia-diem-du-lich-quy-nhon-1.jpg?tr=dpr-2,w-675', // Ảnh Kỳ Co Quy Nhơn, bãi biển hình lưỡi liềm, nước trong
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Khám Phá Biển Việt Nam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.cyan],
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
                'Top 10 vùng biển đẹp nhất Việt Nam',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[800],
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
        backgroundColor: Colors.blueAccent,
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
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tour['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueGrey[600],
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
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
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
    // Navigate to a detail screen (implement SeaTourDetailScreen later)
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
        title: const Text('Tìm kiếm tour'),
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
            child: const Text('Hủy', style: TextStyle(color: Colors.blueGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
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
        title: const Text('Lọc tour'),
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
                  DropdownMenuItem(value: 'low', child: Text('Dưới 4 triệu')),
                  DropdownMenuItem(value: 'medium', child: Text('4 - 6 triệu')),
                  DropdownMenuItem(value: 'high', child: Text('Trên 6 triệu')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Thời gian',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: 'short', child: Text('1-2 ngày')),
                  DropdownMenuItem(value: 'medium', child: Text('3-5 ngày')),
                  DropdownMenuItem(value: 'long', child: Text('Trên 5 ngày')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.blueGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
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
        title: const Text('Đặt tour mới'),
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
            child: const Text('Hủy', style: TextStyle(color: Colors.blueGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Đặt ngay'),
          ),
        ],
      ),
    );
  }
}