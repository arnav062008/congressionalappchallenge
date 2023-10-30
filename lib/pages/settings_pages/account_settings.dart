import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/pages/settings_pages/settings.dart'
    as settings;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';
import '../../constants.dart';
import '../onboarding/login.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  bool isChangePasswordVisible = false;
  TextEditingController newPasswordController = TextEditingController();
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
                      color: AppColors.textColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const settings.Settings()),
                    );
                  },
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                const Text(
                  'Account Settings',
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
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      _buildRowWithIcon(
                        'Change Password',
                        Icons.lock,
                        () {
                          setState(() {
                            isChangePasswordVisible = true;
                          });
                        },
                      ),
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      _buildRowWithIcon('Change Username', Icons.person, () {
                        // Add Face ID handling logic
                      }),
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      GestureDetector(
                        child: _buildText('Sign Out',
                            fontSize: 18, icon: Icons.logout_rounded),
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

  Widget _buildRowWithIcon(String text, IconData icon, VoidCallback onTap) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: _buildText(text, icon: icon),
        ),
      ],
    );
  }

  Widget _buildText(String text, {double fontSize = 15, IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: icon != null ? 60 : 30,
        ),
        if (icon != null)
          SizedBox(
            height: 40,
            child: Icon(
              icon,
              color: AppColors.hintTextColor,
            ),
          ),
        const SizedBox(width: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: icon != null ? 200 : 300,
            child: Text(
              text,
              textAlign: icon != null ? null : TextAlign.center,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: fontSize,
                fontFamily: 'Lato',
                fontWeight: FontWeight.normal,
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
