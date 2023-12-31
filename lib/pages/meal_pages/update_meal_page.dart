import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:congressionalappchallenge/pages/meal_pages/meal_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/bottom_nav_bar.dart';

class MealUpdate extends StatefulWidget {
  const MealUpdate({
    Key? key,
    required this.description,
    required this.servingAmount,
    required this.date,
    required this.mealId,
  }) : super(key: key);

  final String mealId;
  final String description;
  final int servingAmount;
  final Timestamp date;

  @override
  State<MealUpdate> createState() => _MealUpdateState();
}

class _MealUpdateState extends State<MealUpdate> {
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.description);
  late DateTime? selectedDate = widget.date.toDate();
  late int servingAmounts = 1;
  late final TextEditingController _servingAmount = TextEditingController(
    text: widget.servingAmount.toString(),
  );
  CollectionReference meals = FirebaseFirestore.instance.collection('meals');

  void onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  void _updateMealInFirebase(context) async {
    try {
      await meals.doc(widget.mealId).update({
        'description': descriptionController.text,
        'date': selectedDate,
        'servingAmount': int.parse(_servingAmount.text),
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'aided': 0,
      });

      // Show update success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Meal data updated!'),
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
    } catch (error) {
      // Show update error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update meal data.'),
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
      if (kDebugMode) {
        print('Error updating meal: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentTab: TabItem.AddMeal,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.add_box,
                    size: 40,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                const Text(
                  'Update Meals', // Change the screen title to 'Update Meals'
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 28,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.98,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MealHistory()),
                    );
                  },
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.history,
                      size: 40,
                      color: AppColors.textColor,
                    ),
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
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  const TitleWidget(),
                  SizedBox(height: height * 0.05),
                  TextBox(
                    number: false,
                    texts: 'Description',
                    width: width * 0.64,
                    height: height * 0.09,
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 20),
                  Transform.scale(
                    scale: 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Set time',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: height * 0.093,
                          child: CupertinoTheme(
                            data: const CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.dateAndTime,
                              initialDateTime: selectedDate,
                              onDateTimeChanged: onDateChanged,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: width * 0.4,
                                  height: height * 0.06,
                                  decoration: ShapeDecoration(
                                    color: AppColors.textColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                    child: TextBox(
                                      number: true,
                                      texts: "Serving Amount",
                                      width: width * 0.64,
                                      height: height * 0.09,
                                      controller: _servingAmount,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    child: const Icon(
                                      Icons.add_circle,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      _updateMealInFirebase(
                                          context); // Call the update function here
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          width * 0.08, width * 0.1, width * 0.08, width * 0.08),
      child: Row(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MealHistory(),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: width * 0.1,
              height: width * 0.1,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              child: const Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        width: width * 0.71,
        height: height * 0.072,
        child: const Text(
          'Update Meals',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 20,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final double width;
  final double height;
  final bool number;
  final String texts;
  final TextEditingController controller;

  const TextBox({
    super.key,
    required this.number,
    required this.width,
    required this.height,
    required this.controller,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: AppColors.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          keyboardType: number ? TextInputType.number : null,
          inputFormatters:
              number ? [FilteringTextInputFormatter.digitsOnly] : [],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: texts,
            hintStyle: const TextStyle(
              color: AppColors.hintTextColor,
              fontSize: 15,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
