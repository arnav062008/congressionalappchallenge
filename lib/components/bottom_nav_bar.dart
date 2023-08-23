import 'package:congressionalappchallenge/constants.dart';
import 'package:flutter/material.dart';

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

  Widget buildTabIndicator(bool isActive) {
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
    final width = MediaQuery.of(context).size.width;
    final iconSize = width * 0.077;

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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Summary()),
                  );
                },
                icon: Icon(
                  Icons.house_outlined,
                  size: iconSize,
                  color:
                      currentTab == TabItem.Summary ? Colors.white : iconColor,
                ),
              ),
              buildTabIndicator(currentTab == TabItem.Summary),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MapPointScreen()),
                  );
                },
                icon: Icon(
                  Icons.map_outlined,
                  size: iconSize,
                  color: currentTab == TabItem.Map ? Colors.white : iconColor,
                ),
              ),
              buildTabIndicator(currentTab == TabItem.Map),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MealAdd()),
                  );
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  size: iconSize,
                  color:
                      currentTab == TabItem.AddMeal ? Colors.white : iconColor,
                ),
              ),
              buildTabIndicator(currentTab == TabItem.AddMeal),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
                icon: Icon(
                  Icons.settings_outlined,
                  size: iconSize,
                  color:
                      currentTab == TabItem.Settings ? Colors.white : iconColor,
                ),
              ),
              buildTabIndicator(currentTab == TabItem.Settings),
            ],
          ),
        ],
      ),
    );
  }
}
