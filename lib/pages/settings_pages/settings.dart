import 'package:congressionalappchallenge/constants.dart';
import 'package:congressionalappchallenge/pages/onboarding/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';
import 'meal_details.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    signOut() async {
      await firebaseAuth.signOut();
    }

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
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.settings,
                    size: 40,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: AppColors.textColor,
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
                color: AppColors.backgroundColor,
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
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      _buildText('Preferences', context, fontSize: 18),
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      _buildText(
                        'Account Settings',
                        context,
                        fontSize: 18,
                      ),
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MealDetail(),
                            ),
                          );
                        },
                        child: _buildText(
                          'Meal Details',
                          context,
                          fontSize: 18,
                        ),
                      ), // Adjusted size for "Meal Details" text

                      SizedBox(height: height * 0.06),

                      _buildDivider(context),

                      SizedBox(height: height * 0.03),
                      GestureDetector(
                        child: _buildText(
                          'Sign Out',
                          context,
                          fontSize: 18,
                        ),
                        onTap: () {
                          signOut().then(
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
                          width: width * 0.6,
                          height: height * 0.05,
                          decoration: ShapeDecoration(
                            color: AppColors.textColor,
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
                                  color: AppColors.hintTextColor,
                                  fontSize: 15,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
          color: AppColors.textColor,
          fontSize: fontSize,
          fontFamily: 'Lato',
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget _buildDivider(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 1,
      color: AppColors.cardColor,
    );
  }
}
