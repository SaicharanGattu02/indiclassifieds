import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/presentation/views/Home.dart';
import 'package:indiclassifieds/presentation/views/ProfileScreen.dart';
import 'package:indiclassifieds/services/AuthService.dart';
import 'package:indiclassifieds/theme/app_colors.dart';

import '../../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../../data/cubit/theme_cubit.dart';
import '../../theme/ThemeHelper.dart';
import 'AddsScreen.dart';
import 'FavouritesScreen.dart';
import 'UserListScreen.dart';

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
    getData();
  }

  Future<void> getData() async {
    final plan = await context
        .read<UserActivePlanCubit>()
        .getUserActivePlansData();
    if (plan != null) {
      AuthService.setPlanStatus(plan.goToPlansPage.toString() ?? "");
      AuthService.setFreePlanStatus(plan.isFree.toString() ?? "");
    }
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, mode) {
        final cardColor = ThemeHelper.cardColor(context);
        return WillPopScope(
          onWillPop: () async { SystemNavigator.pop(); return false; },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: PageView(
              controller: pageController,
              onPageChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() => _selectedIndex = value);
              },
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomeScreen(),
                AdsScreen(),
                UserListScreen(),
                ProfileScreen(),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: MediaQuery.removeViewInsets(
              context: context,
              removeBottom: true,
              child: Container(
                width: 50, height: 50, margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      blurRadius: 5, offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: () => context.push("/category"),
                  child: const Icon(Icons.add, size: 32, color: Colors.white),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: AnimatedContainer( // smooth color transition
                duration: const Duration(milliseconds: 200),
                height: 65,
                color: cardColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home, "Home", 0),
                    _buildNavItem(Icons.archive, "My Ads", 1),
                    const SizedBox(width: 40), // space for FAB
                    _buildNavItem(Icons.chat, "Chat", 2),
                    _buildNavItem(Icons.person, "Profile", 3),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
