import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Giới thiệu & Liên hệ"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Logo + Tên công ty
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/logo3.jpg",
                      height: 120,
                      width: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Công ty Du Lịch Việt Lữ Travel",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Chuyên cung cấp tour du lịch đoàn",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Phần Giới thiệu
            _buildInfoCard(
              icon: Icons.info,
              title: "Giới thiệu",
              content:
              "Việt Lữ Travel là công ty lữ hành uy tín, chuyên tổ chức các tour "
                  "du lịch cho đoàn thể, doanh nghiệp và cá nhân. Với đội ngũ hướng dẫn viên "
                  "nhiệt tình, giàu kinh nghiệm, chúng tôi cam kết mang đến cho khách hàng "
                  "những hành trình đáng nhớ, an toàn và đầy trải nghiệm.",
              color: Colors.teal,
            ),
            _buildInfoCard(
              icon: Icons.flag,
              title: "Sứ mệnh & Tầm nhìn",
              content:
              "- Tạo nên những chuyến đi ý nghĩa và gắn kết.\n"
                  "- Đảm bảo dịch vụ chuyên nghiệp, giá cả hợp lý.\n"
                  "- Trở thành đơn vị lữ hành hàng đầu tại Việt Nam.",
              color: Colors.orange,
            ),

            const SizedBox(height: 24),

            // Thông tin liên hệ
            _buildContactCard(
              context: context,
              icon: Icons.person,
              title: "Người quản lý",
              subtitle: "Trần Bảo Duy",
              color: Colors.orange,
              showDialogOnTap: true,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.location_on,
              title: "Địa chỉ",
              subtitle:
              "Khu Công nghệ cao TP.HCM, Xa lộ Hà Nội, Phường Tăng Nhơn Phú, TP.HCM",
              color: Colors.redAccent,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.phone,
              title: "Hotline",
              subtitle: "0329 810 650",
              color: Colors.green,
            ),
            _buildContactCard(
              context: context,
              icon: Icons.email,
              title: "Email",
              subtitle: "vietlutravell@gmail.com",
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  /// Card giới thiệu / sứ mệnh
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: color.withOpacity(0.4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(content, style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  /// Card liên hệ
  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool showDialogOnTap = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: color.withOpacity(0.4),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, size: 24, color: Colors.grey),
        onTap: () {
          if (showDialogOnTap) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Thông tin", textAlign: TextAlign.center),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Họ và tên: Trần Bảo Duy"),
                    SizedBox(height: 8),
                    Text("Chức vụ: Quản lý"),
                    SizedBox(height: 8),
                    Text("Số điện thoại: 0329810650"),
                    SizedBox(height: 8),
                    Text("Email: baoduy10072004@gmail.com"),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Đóng"),
                  ),
                ],
              ),
            );
          } else {
            debugPrint("Tapped on $title");
          }
        },
      ),
    );
  }
}
