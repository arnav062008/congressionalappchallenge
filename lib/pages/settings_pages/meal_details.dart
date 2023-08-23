import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';

class MealDetail extends StatelessWidget {
  const MealDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final double dividerHeight = screenHeight * 0.043333;
    final TextEditingController _phoneNumController = TextEditingController();
    final TextEditingController _allergenController = TextEditingController();
    void _saveDetails() async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid);
      final String phoneNum = _phoneNumController.text;
      final String allergens = _allergenController.text;

      user.set({
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
          width: screenWidth * 0.9,
          height: 1,
          color: const Color(0xFF2E343B),
        );

    Widget sectionTitle(String title) => SizedBox(
          width: screenWidth * 0.7,
          height: screenHeight * 0.035,
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
        );

    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentTab: TabItem.Settings,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.9,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: AppColors.backgroundColor),
          child: Column(
            children: [
              SizedBox(height: dividerHeight),
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
              SizedBox(height: dividerHeight),
              SizedBox(
                width: screenWidth * 0.72,
                height: screenHeight * 0.072,
                child: const Text(
                  'Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFEFCFB),
                    fontSize: 20,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: dividerHeight),
              sectionDivider(),
              SizedBox(height: dividerHeight),
              sectionTitle('Phone Number'),
              PhoneNumberTextBox(
                width: screenWidth,
                height: screenHeight,
                controller: _phoneNumController,
              ),
              SizedBox(height: dividerHeight),
              sectionDivider(),
              SizedBox(height: dividerHeight),
              sectionTitle('Allergens: '),
              TextBoxs(
                obsc: false,
                width: screenWidth,
                height: screenHeight,
                nameController: _allergenController,
                icon: Icons.fastfood,
                text: "Allergens Food is Cooked Near:",
              ),
              const Spacer(),
              GestureDetector(
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      color: AppColors.accentColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 0.04),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    if (_phoneNumController.text.length != 10) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const BasicAlert(
                              text: 'Phone Number is not 10 Char',
                              title: 'Error with Detail Save',
                            );
                          });
                    } else {
                      if (_allergenController.text.isNotEmpty) {
                        _saveDetails();
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
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberTextBox extends StatelessWidget {
  PhoneNumberTextBox({
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
      width: width * 0.9,
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
      width: width * 0.9,
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
