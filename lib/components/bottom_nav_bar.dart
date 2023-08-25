import 'package:flutter/material.dart';

import '../constants.dart';
import '../pages/meal_pages/add_meal.dart';
import '../pages/meal_pages/meal_locate.dart';
import '../pages/settings_pages/settings.dart';
import '../pages/summary.dart';

enum TabItem {
  Summary,
  Map,
  AddMeal,
  Settings,
}

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    Key? key,
    required this.currentTab,
  }) : super(key: key);

  final TabItem currentTab;

  static const Color backgroundColor = Color(0xFF2e343b);
  static const Color shadowColor = Color(0xB22e343b);
  static const Color iconColor = Color(0xFFCDCDCD);
  static const double iconSize = 0.077;

  Widget _buildTab(
      {required IconData icon,
      required bool isActive,
      required VoidCallback onPressed,
      required BuildContext context}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: MediaQuery.of(context).size.width * iconSize,
            color: isActive ? Colors.white : iconColor,
          ),
        ),
        _buildTabIndicator(isActive),
      ],
    );
  }

  Widget _buildTabIndicator(bool isActive) {
    return Container(
      width: 6,
      height: 6,
      decoration: ShapeDecoration(
        color: isActive ? AppColors.accentColor : Colors.transparent,
        shape: const CircleBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: const BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab(
            icon: Icons.house_outlined,
            isActive: currentTab == TabItem.Summary,
            onPressed: () {
              if (currentTab != TabItem.Summary) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Summary()),
                );
              }
            },
            context: context,
          ),
          _buildTab(
            icon: Icons.map_outlined,
            isActive: currentTab == TabItem.Map,
            onPressed: () {
              if (currentTab != TabItem.Map) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MapPointScreen()),
                );
              }
            },
            context: context,
          ),
          _buildTab(
            icon: Icons.add_circle_outline,
            isActive: currentTab == TabItem.AddMeal,
            onPressed: () {
              if (currentTab != TabItem.AddMeal) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MealAdd()),
                );
              }
            },
            context: context,
          ),
          _buildTab(
            icon: Icons.settings_outlined,
            isActive: currentTab == TabItem.Settings,
            onPressed: () {
              if (currentTab != TabItem.Settings) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              }
            },
            context: context,
          ),
        ],
      ),
    );
  }
}
