import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';
import 'settings.dart' as settings;

class MealDetail extends StatelessWidget {
  const MealDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double dividerHeight = height * 0.043333;
    final TextEditingController phoneNumController = TextEditingController();
    final TextEditingController allergenController = TextEditingController();
    void saveDetails() async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> currentData =
          documentSnapshot.data() as Map<String, dynamic>;
      final String phoneNum = phoneNumController.text;
      final String allergens = allergenController.text;

      user.update({
        "name": currentData['name'],
        "email": currentData['email'],
        "phone": phoneNum,
        "allergens": allergens,
      }).then((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Details saved!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        if (kDebugMode) {
          print('Error adding meal: $error');
        }
      });
    }

    Widget sectionDivider() => Container(
          width: width * 0.6,
          height: 1,
          color: const Color(0xFF2E343B),
        );

    Widget sectionTitle(String title) => Padding(
          padding: EdgeInsets.fromLTRB(width * 0.1, 0, 0, 0),
          child: SizedBox(
            width: width * 0.7,
            height: height * 0.035,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFFFEFCFB),
                fontSize: 15,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(
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
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: dividerHeight),
                      sectionDivider(),
                      SizedBox(height: dividerHeight),
                      sectionTitle('Phone Number'),
                      PhoneNumberTextBox(
                        width: width,
                        height: height,
                        controller: phoneNumController,
                      ),
                      SizedBox(height: dividerHeight),
                      sectionDivider(),
                      SizedBox(height: dividerHeight),
                      sectionTitle('Allergens: '),
                      TextBoxs(
                        obsc: false,
                        width: width,
                        height: height,
                        nameController: allergenController,
                        icon: Icons.fastfood,
                        text: "Allergens:",
                      ),
                      const Spacer(),
                      GestureDetector(
                          child: Container(
                            width: width * 0.7,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width * 0.02),
                              color: AppColors.accentColor,
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.04),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Confirm",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            if (phoneNumController.text.length != 10) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const BasicAlert(
                                      text: 'Phone Number is not 10 Char',
                                      title: 'Error with Detail Save',
                                    );
                                  });
                            } else {
                              if (allergenController.text.isNotEmpty) {
                                saveDetails();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const BasicAlert(
                                      text: 'Allergens are Empty',
                                      title: 'Error with Detail Save',
                                    );
                                  },
                                );
                              }
                            }
                          }),
                      SizedBox(height: height * 0.03),
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
}

class PhoneNumberTextBox extends StatelessWidget {
  const PhoneNumberTextBox({
    super.key,
    required this.width,
    required this.height,
    required this.controller,
  });
  final TextEditingController controller;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.6,
      height: height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.02),
        border: Border.all(color: Colors.white, width: width * 0.01),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0.04),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
              child: Icon(
                Icons.phone,
                color: AppColors.hintTextColor.withOpacity(0.8),
                size: width * 0.06,
              ),
            ),
            SizedBox(width: width * 0.015),
            Expanded(
              child: TextField(
                style: TextStyle(
                  color: AppColors.hintTextColor,
                  fontSize: width * 0.04,
                ),
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: 'Phone Number: ',
                  hintStyle: TextStyle(
                    color: AppColors.hintTextColor,
                    fontSize: width * 0.04,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextBoxs extends StatelessWidget {
  const TextBoxs({
    super.key,
    required this.obsc,
    required this.width,
    required this.height,
    required this.icon,
    required TextEditingController nameController,
    required this.text,
  }) : _nameController = nameController;
  final String text;
  final bool obsc;
  final double width;
  final double height;
  final IconData icon;
  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.6,
      height: height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.02),
        border: Border.all(color: Colors.white, width: width * 0.01),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0.04),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
              child: Icon(
                icon,
                color: AppColors.hintTextColor.withOpacity(0.8),
                size: width * 0.06,
              ),
            ),
            SizedBox(width: width * 0.015),
            Expanded(
              child: TextField(
                obscureText: obsc,
                style: TextStyle(
                  color: AppColors.hintTextColor,
                  fontSize: width * 0.04,
                ),
                controller: _nameController,
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: text,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: AppColors.hintTextColor,
                    fontSize: width * 0.04,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BasicAlert extends StatelessWidget {
  const BasicAlert({Key? key, required this.text, required this.title})
      : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
