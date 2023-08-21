import 'package:flutter/material.dart';

import '../pages/meal_pages/add_meal.dart';
import '../pages/meal_pages/meal_locate.dart';
import '../pages/settings_pages/settings.dart';
import '../pages/summary.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  // Color constants
  static const Color backgroundColor = Color(0xFF2e343b);
  static const Color shadowColor = Color(0xB22e343b);
  static const Color iconColor = Color(0xFFCDCDCD);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final iconSize = width * 0.077;

    // Navigation icons
    final summaryIcon = IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Summary()),
        );
      },
      icon: Icon(
        Icons.house_outlined,
        size: iconSize,
        color: iconColor,
      ),
    );

    final mapIcon = IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapPointScreen()),
        );
      },
      icon: Icon(
        Icons.map_outlined,
        size: iconSize,
        color: iconColor,
      ),
    );

    final addMealIcon = IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MealAdd()),
        );
      },
      icon: Icon(
        Icons.add_circle_outline,
        size: iconSize,
        color: iconColor,
      ),
    );

    final settingsIcon = IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Settings()),
        );
      },
      icon: Icon(
        Icons.settings_outlined,
        size: iconSize,
        color: iconColor,
      ),
    );

    return Container(
      width: 411,
      height: 64,
      decoration: const BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: Offset(0, -2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          summaryIcon,
          mapIcon,
          addMealIcon,
          settingsIcon,
        ],
      ),
    );
  }
}
