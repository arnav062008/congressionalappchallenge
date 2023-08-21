import 'package:congressionalappchallenge/pages/onboarding/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';
import 'meal_details.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final iconSize = screenWidth / 10;
    _signOut() async {
      await _firebaseAuth.signOut();
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(),
      backgroundColor: const Color(0xFF22282C),
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.9,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color(0xFF22282C)),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.03),
              _buildIconButton(
                icon: Icons.arrow_back_ios,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              _buildText('Settings', context,
                  fontSize: 24, fontWeight: FontWeight.w900),
              SizedBox(height: screenHeight * 0.06),
              _buildDivider(context),
              SizedBox(height: screenHeight * 0.03),
              _buildText('Preferences', context, fontSize: 18),
              SizedBox(height: screenHeight * 0.06),
              _buildDivider(context),
              SizedBox(height: screenHeight * 0.03),
              _buildText(
                'Account Settings',
                context,
                fontSize: 18,
              ),
              SizedBox(height: screenHeight * 0.06),
              _buildDivider(context),
              SizedBox(height: screenHeight * 0.03),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetail(),
                    ),
                  );
                },
                child: _buildText(
                  'Meal Details',
                  context,
                  fontSize: 18,
                ),
              ), // Adjusted size for "Meal Details" text

              SizedBox(height: screenHeight * 0.06),

              _buildDivider(context),

              SizedBox(height: screenHeight * 0.03),
              GestureDetector(
                child: _buildText(
                  'Sign Out',
                  context,
                  fontSize: 18,
                ),
                onTap: () {
                  _signOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    ),
                  );
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.05,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFEFCFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Center(
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
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text, BuildContext context,
      {double fontSize = 15, FontWeight fontWeight = FontWeight.normal}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.035,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFFEFCFB),
          fontSize: fontSize,
          fontFamily: 'Lato',
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget _buildDivider(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 1,
      color: const Color(0xFF2E343B),
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}
