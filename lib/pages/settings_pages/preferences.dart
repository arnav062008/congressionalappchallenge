import 'package:congressionalappchallenge/pages/settings_pages/settings.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';
import '../../constants.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentTab: TabItem.Settings,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: height * 0.37,
            decoration: const ShapeDecoration(
              color: AppColors.accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 70, 30, 0),
            child: Row(
              children: [
                GestureDetector(
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.settings,
                      size: 40,
                      color: AppColors.hintTextColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  },
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                const Text(
                  'Preferences',
                  style: TextStyle(
                    color: AppColors.hintTextColor,
                    fontSize: 28,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.98,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: width * 0.86861313868,
              height: height * 0.76670716889,
              decoration: const ShapeDecoration(
                color: AppColors.accentColor2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x51131313),
                    blurRadius: 16,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Container(
                  width: width * 0.9,
                  height: height * 0.9,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      color: AppColors.accentColor2,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: const Column(
                    children: [],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
