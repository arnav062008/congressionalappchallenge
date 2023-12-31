import 'package:congressionalappchallenge/pages/settings_pages/settings.dart';
import 'package:flutter/cupertino.dart';
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
    bool notificationsValue = false;

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
                      Row(
                        children: [
                          _buildText('Notifications', context,
                              fontSize: 18, icon: Icons.notifications_active),
                          CupertinoSwitch(
                            value: notificationsValue,
                            onChanged: (bool? value) {
                              setState(() {
                                notificationsValue = value ?? false;
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      Row(
                        children: [
                          _buildText('Face ID', context,
                              fontSize: 18, icon: Icons.face),
                          CupertinoSwitch(
                            value: notificationsValue,
                            onChanged: (bool? value) {
                              setState(() {
                                notificationsValue = value ?? false;
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(height: height * 0.06),
                      _buildDivider(context),
                      SizedBox(height: height * 0.03),
                      Row(
                        children: [
                          _buildText('Location Access', context,
                              fontSize: 18, icon: Icons.location_pin),
                          CupertinoSwitch(
                            value: notificationsValue,
                            onChanged: (bool? value) {
                              setState(() {
                                notificationsValue = value ?? false;
                              });
                            },
                          )
                        ],
                      ),
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
                  color: AppColors.hintTextColor,
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
