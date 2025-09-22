import 'package:flutter/material.dart';
import 'account_page.dart';
import 'globals.dart' as globals;
import 'header.dart';
import 'feature_grid.dart';
import 'promo_banner.dart';
import 'tours_page.dart';
import 'news_page.dart';
import 'quick_categories_widget.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeContent(),
      const ToursPage(),
      const NewsPage(),
      ChatPage(customerId: globals.currentCustomer?.customerID ?? 0),
      const AccountPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Trang chủ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded),
                label: "Tour",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article_rounded),
                label: "Tin tức",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded),
                label: "Trò chuyện",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: "Tài khoản",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              const HeaderWidget(),
              const SizedBox(height: 12),

              // Banner có bo góc + shadow
              Material(
                borderRadius: BorderRadius.circular(16),
                elevation: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const PromoBannerWidget(),
                ),
              ),
              const SizedBox(height: 16),

              // Feature Grid
              const FeatureGridWidget(),
              const SizedBox(height: 20),

              // Quick Categories
              Material(
                borderRadius: BorderRadius.circular(16),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QuickCategoriesWidget(
                    onCategoryTap: (category) {
                      debugPrint("Chọn danh mục: $category");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
