import 'package:flutter/material.dart';

import 'add_meal.dart';
import 'meal_locate.dart';
import 'summary.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(),
      backgroundColor: const Color(0xFF22282C),
      body: Center(
        child: Container(
          width: screenWidth *
              0.9, // Adjust the width using a fraction of screen width
          height: screenHeight *
              0.9, // Adjust the height using a fraction of screen height
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color(0xFF22282C)),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: screenWidth * 0.72,
                height: screenHeight * 0.072,
                child: const Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFEFCFB),
                    fontSize: 20,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: screenWidth * 0.9,
                height: 1,
                color: const Color(0xFF2E343B),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: screenWidth * 0.7,
                height: screenHeight * 0.035,
                child: const Text(
                  'Preferences',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFEFCFB),
                    fontSize: 15,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Container(
                width: screenWidth * 0.9,
                height: 1,
                color: const Color(0xFF2E343B),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: screenWidth * 0.7,
                height: screenHeight * 0.035,
                child: const Text(
                  'Account Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFEFCFB),
                    fontSize: 15,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Container(
                width: screenWidth * 0.9,
                height: 1,
                color: const Color(0xFF2E343B),
              ),
              SizedBox(height: screenHeight * 0.05),
              SizedBox(
                width: screenWidth * 0.7,
                height: screenHeight * 0.035,
                child: const Text(
                  'Sign Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFEFCFB),
                    fontSize: 15,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: screenWidth *
                      0.85, // Adjust the width using a fraction of screen width
                  height: screenHeight *
                      0.05, // Adjust the height using a fraction of screen height
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFEFCFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: SizedBox(
                      child: Text(
                        'Deactivate Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF555553),
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final iconSize = width / 10;

    return Container(
      width: width * 0.866,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: const ShapeDecoration(
        color: Color(0xFF2E343B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPointScreen()),
              );
            },
            icon: Icon(
              Icons.map_outlined,
              size: iconSize,
              color: Colors.white,
            ),
          ),
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
              color: Colors.white,
            ),
          ),
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
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
