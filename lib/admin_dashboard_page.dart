import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_chat_page.dart';
import 'globals.dart' as globals;
import 'package:intl/intl.dart';
import 'booking_management_page.dart';
import 'guide_assignment_page.dart';
import 'tour_management_page.dart';
import 'customer_management_page.dart';
import 'user_management_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool isLoading = true;
  String? errorMessage;
  int totalTours = 0;
  int totalCustomers = 0;
  int totalGuides = 0;
  double totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/admin/stats'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalTours = data['totalTours'] ?? 0;
          totalCustomers = data['totalCustomers'] ?? 0;
          totalGuides = data['totalGuides'] ?? 0;
          totalRevenue = (data['totalRevenue'] ?? 0).toDouble();
          isLoading = false;
          errorMessage = null;
        });
      } else {
        throw Exception("Failed to load statistics");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error loading data: $e";
      });
    }
  }

  // ✅ Hàm định dạng tiền tệ
  String _formatCurrency(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.teal,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Việt Lữ Travel | Hệ Thống"),
          backgroundColor: Colors.teal,
          elevation: 2,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: "Cập nhật số liệu",
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                fetchStats();
              },
            ),
          ],
        ),

        body: isLoading
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.teal),
              SizedBox(height: 8),
              Text("Loading data...", style: TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        )
            : errorMessage != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.red),
              const SizedBox(height: 8),
              Text(errorMessage!, style: const TextStyle(fontSize: 14, color: Colors.red)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: fetchStats,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Retry"),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: fetchStats,
          color: Colors.teal,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, Admin!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        StatCard(
                          title: "Tours",
                          value: totalTours.toString(),
                          color: Colors.orange.shade600,
                          icon: Icons.tour,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - 36) / 4
                              : constraints.maxWidth,
                        ),
                        StatCard(
                          title: "Customers",
                          value: totalCustomers.toString(),
                          color: Colors.green.shade600,
                          icon: Icons.people,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - 36) / 4
                              : constraints.maxWidth,
                        ),
                        StatCard(
                          title: "Guides",
                          value: totalGuides.toString(),
                          color: Colors.purple.shade600,
                          icon: Icons.person_pin,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - 36) / 4
                              : constraints.maxWidth,
                        ),
                        StatCard(
                          title: "Revenue",
                          // ✅ Sử dụng hàm định dạng mới
                          value: _formatCurrency(totalRevenue),
                          color: Colors.blue.shade600,
                          icon: Icons.attach_money,
                          width: constraints.maxWidth > 600
                              ? (constraints.maxWidth - 36) / 4
                              : constraints.maxWidth,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),
                Text(
                  "Management",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ManagementButton(
                      title: "Manage Tours",
                      icon: Icons.tour,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TourManagementPage()),
                        );
                      },
                    ),
                    ManagementButton(
                      title: "Manage Customers",
                      icon: Icons.people,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CustomerManagementPage()),
                        );
                      },
                    ),
                    ManagementButton(
                      title: "Manage Staff",
                      icon: Icons.admin_panel_settings,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserManagementPage()),
                        );
                      },
                    ),
                    ManagementButton(
                      title: "Manage Bookings",
                      icon: Icons.receipt_long,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BookingManagementPage()),
                        );
                      },
                    ),
                    ManagementButton(
                      title: "Assign Guides",
                      icon: Icons.assignment_ind,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GuideAssignmentPage()),
                        );
                      },
                    ),

            ManagementButton(
              title: "Messages",
              icon: Icons.chat,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminChatPage()),
                );
              },
            ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final double width;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManagementButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ManagementButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.shade200, width: 1.5),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.teal.shade700),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade800,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}