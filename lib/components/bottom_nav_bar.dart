import 'package:congressionalappchallenge/pages/meal_pages/meal_history.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../pages/meal_pages/add_meal.dart';
import '../pages/meal_pages/meal_finder.dart';
import '../pages/settings_pages/settings.dart';
import '../pages/summary.dart';

enum TabItem {
  Summary,
  Map,
  AddMeal,
  Settings,
  History,
}

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    Key? key,
    required this.currentTab,
  }) : super(key: key);

  final TabItem currentTab;

  static Color backgroundColor = Color(0xFF161314);
  static const Color shadowColor = Color(0xB22e343b);
  static const Color iconColor = AppColors.accentColor;
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
            color: isActive ? Colors.white : AppColors.cardColor,
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
        color: isActive ? AppColors.hintTextColor : Colors.transparent,
        shape: const CircleBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
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
            icon: Icons.house,
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
            icon: Icons.map,
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
            icon: Icons.add_box,
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
            icon: Icons.history,
            isActive: currentTab == TabItem.History,
            onPressed: () {
              if (currentTab != TabItem.History) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MealHistory()),
                );
              }
            },
            context: context,
          ),
          _buildTab(
            icon: Icons.settings,
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
