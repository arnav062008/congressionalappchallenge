import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:congressionalappchallenge/pages/meal_pages/meal_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/bottom_nav_bar.dart';
import 'map.dart';

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
  final String? serve;
  @override
  State<MealAdd> createState() => _MealAddState();
}

class _MealAddState extends State<MealAdd> {
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.descr);
  late DateTime? selectedDate = widget.date ?? DateTime.now();
  late int servingAmounts = 1;
  late final TextEditingController _servingAmount =
      TextEditingController(text: widget.serve);
  CollectionReference meals = FirebaseFirestore.instance.collection('meals');

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
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

  void _saveMealToFirebase() async {
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
      bottomNavigationBar: BottomNavigationBarWidget(),
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          const TopBarWidget(),
          const SizedBox(height: 8),
          const TitleWidget(),
          const SizedBox(height: 8),
          Container(
            width: width * 0.8,
            height: height * 0.6,
            decoration: ShapeDecoration(
              color: AppColors.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70),
              ),
            ),
            child: Column(
              children: [
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
                                      builder: (context) => const MapScreen(),
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
                                      _saveMealToFirebase();
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
                    builder: (context) => MealHistory(),
                  ),
                );
              },
            ),
          ),
          Spacer(),
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