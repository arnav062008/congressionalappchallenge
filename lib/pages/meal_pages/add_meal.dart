import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:congressionalappchallenge/pages/meal_pages/meal_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/bottom_nav_bar.dart';
import 'add_meal_map.dart';

class MealAdd extends StatefulWidget {
  const MealAdd(
      {Key? key,
      this.latitude,
      this.longitude,
      this.desc,
      this.date,
      this.serving,
      this.descr,
      this.dates,
      this.serve})
      : super(key: key);
  final double? latitude;
  final double? longitude;
  final String? desc;
  final int? serving;
  final DateTime? date;
  final String? descr;
  final DateTime? dates;
  final int? serve;
  @override
  State<MealAdd> createState() => _MealAddState();
}

class _MealAddState extends State<MealAdd> {
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.descr);
  late DateTime? selectedDate = widget.date ?? DateTime.now();
  late int servingAmounts = 1;
  late final TextEditingController _servingAmount = TextEditingController(
    text: widget.serve.toString().isNotEmpty ? widget.serve.toString() : "",
  );
  CollectionReference meals = FirebaseFirestore.instance.collection('meals');

  @override
  void initState() {
    super.initState();

    selectedDate = widget.dates ?? DateTime.now();
    _servingAmount.text = widget.serve != null ? widget.serve.toString() : "";

    _servingAmount.addListener(() {
      final text = _servingAmount.text;
      if (text.isNotEmpty && !RegExp(r'^\d+$').hasMatch(text)) {
        _servingAmount.text = '1';
      }
    });
  }

  void onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  Future<bool> checkIfPhoneFieldExists() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return data.containsKey('phone');
    } else {
      return false;
    }
  }

  void _saveMealToFirebase(context) async {
    final hasPhoneField = await checkIfPhoneFieldExists();

    if (hasPhoneField) {
      final newMealRef = meals.doc();
      newMealRef.set({
        'description': descriptionController.text,
        'date': selectedDate,
        'latitude': widget.latitude ?? 0.0,
        'longitude': widget.longitude ?? 0.0,
        'servingAmount': int.parse(_servingAmount.text),
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'aided': 0,
      }).then((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Meal data saved!'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('More Details Must be Provided'),
            content: const Text("Go To Settings under More Details"),
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
                  'Add Meals',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                          servingAmt: _servingAmount
                                                  .text.isNotEmpty
                                              ? int.parse(_servingAmount.text)
                                              : 0,
                                          desc: descriptionController
                                                  .text.isNotEmpty
                                              ? descriptionController.text
                                              : null,
                                          date: selectedDate ?? DateTime.now(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.add_location_alt,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            widget.latitude != null
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      child: const Icon(
                                        Icons.add_circle,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        _saveMealToFirebase(context);
                                      },
                                    ),
                                  )
                                : const SizedBox()
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
          'Add Meals to be Donated',
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
