import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:congressionalappchallenge/pages/onboarding/login.dart';
import 'package:congressionalappchallenge/pages/settings_pages/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';
import 'user_details_extra.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    Future<void> signOut(context) async {
      await firebaseAuth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    }

    Future<void> deleteAccount(context) async {
      final currentUser = firebaseAuth.currentUser;

      if (currentUser != null) {
        try {
          await currentUser.delete();
          await FirebaseFirestore.instance
              .collection("users")
              .doc(currentUser.uid)
              .delete();
          if (kDebugMode) {
            print("Account and user document deleted successfully.");
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        } catch (e) {
          if (kDebugMode) {
            print("Error deleting account or user document: $e");
          }
        }
      } else {
        if (kDebugMode) {
          print("No user is currently logged in.");
        }
      }
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
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PreferencesScreen(),
                          ),
                        ),
                        child: _buildText('Preferences', context,
                            fontSize: 18, icon: Icons.library_add_check),
                      ),
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      _buildText('Account Settings', context,
                          fontSize: 18, icon: Icons.person),
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
                        child: _buildText('Extra Info', context,
                            fontSize: 18, icon: Icons.info),
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
                          signOut(context);
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          deleteAccount(context);
                        },
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
      {double fontSize = 15,
      FontWeight fontWeight = FontWeight.normal,
      IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: icon != null
                ? MediaQuery.of(context).size.width * 0.14
                : MediaQuery.of(context).size.width * 0.07),
        icon != null
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              )
            : Container(),
        SizedBox(width: MediaQuery.of(context).size.width * 0.07),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: icon != null
                ? MediaQuery.of(context).size.width * 0.4
                : MediaQuery.of(context).size.width * 0.6,
            child: Text(
              text,
              textAlign: icon != null ? null : TextAlign.center,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: fontSize,
                fontFamily: 'Lato',
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 1,
      color: AppColors.cardColor,
    );
  }
}
