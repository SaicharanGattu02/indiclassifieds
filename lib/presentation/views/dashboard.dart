import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/presentation/views/Home.dart';
import 'package:indiclassifieds/presentation/views/ProfileScreen.dart';
import 'package:indiclassifieds/theme/app_colors.dart';

import '../../theme/ThemeHelper.dart';
import 'AddsScreen.dart';
import 'FavouritesScreen.dart';

class Dashboard extends StatefulWidget {
  final int initialTab;
  const Dashboard({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    pageController = PageController(initialPage: _selectedIndex);
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeHelper.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (value) {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedIndex = value;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
            AdsScreen(),
            FavouritesScreen(),
            ProfileScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              context.push("/category");
            },
            child: Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: 65,
            decoration: BoxDecoration(
              color: Color(isDarkMode ? 0xff0D0D0D : 0xffffffff),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -1),
                  blurRadius: 8,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.chat, "Chat", 1),
                SizedBox(width: 40), // space for Sell FAB
                _buildNavItem(Icons.archive, "My Ads", 3),
                _buildNavItem(Icons.person, "Profile", 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? AppColors.primary : AppColors.unselect,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.unselect,
            ),
          ),
        ],
      ),
    );
  }
}
