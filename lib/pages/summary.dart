import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/components/bottom_nav_bar.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  final bool? monthly;
  const Summary({Key? key, this.monthly}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  List<Meals> _meals = [];
  final instance = FirebaseFirestore.instance
      .collection('meals')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  bool _isWeeklySelected = true;
  bool _isMonthlySelected = false;

  void _toggleSelectionWeek() {
    setState(() {
      _isWeeklySelected = true;
      _isMonthlySelected = false;
    });
  }

  void _toggleSelectionMonth() {
    setState(() {
      _isWeeklySelected = false;
      _isMonthlySelected = true;
    });
  }

  Future<void> getAllMyMeals() async {
    try {
      QuerySnapshot querySnapshot = await instance.get();
      List<Meals> meals = [];
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          meals.add(
            Meals(
              servingAmount: data["servingAmount"],
              date: data["date"],
              aided: data["aided"],
            ),
          );
        }
      }

      setState(() {
        _meals = meals;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAllMyMeals();
  }

  @override
  Widget build(BuildContext context) {
    double calculateAverageItemsPerDay(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime monday = today.subtract(Duration(days: today.weekday - 1));

      List<Meals> mealsSinceMonday = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(monday) || mealDate.isAtSameMomentAs(monday);
      }).toList();

      int totalItems = mealsSinceMonday.length;
      int daysSinceMonday = today.difference(monday).inDays + 1;

      return totalItems / daysSinceMonday;
    }

    double calculateTotalItemsThisWeek(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime monday = today.subtract(Duration(days: today.weekday - 1));

      List<Meals> mealsThisWeek = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(monday) || mealDate.isAtSameMomentAs(monday);
      }).toList();

      int totalItemsThisWeek = mealsThisWeek.length;
      return totalItemsThisWeek.toDouble();
    }

    double calculatePercentageChangeLastWeek(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime monday = today.subtract(Duration(days: today.weekday - 1));

      DateTime lastMonday = monday.subtract(const Duration(days: 7));

      List<Meals> mealsThisWeek = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(monday) || mealDate.isAtSameMomentAs(monday);
      }).toList();

      List<Meals> mealsLastWeek = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(lastMonday) && mealDate.isBefore(monday);
      }).toList();

      int totalItemsThisWeek = mealsThisWeek.length;
      int totalItemsLastWeek = mealsLastWeek.length;

      double percentageChange =
          ((totalItemsThisWeek - totalItemsLastWeek) / totalItemsLastWeek) *
              100;

      return percentageChange;
    }

    int calculateTotalServingAmountThisWeek(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime monday = today.subtract(Duration(days: today.weekday - 1));

      List<Meals> mealsThisWeek = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(monday) || mealDate.isAtSameMomentAs(monday);
      }).toList();

      int totalServingAmountThisWeek = 0;

      for (var meal in mealsThisWeek) {
        totalServingAmountThisWeek += meal.aided;
      }

      return totalServingAmountThisWeek;
    }

    double calculateAverageItemsPerMonth(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime firstDayOfMonth = DateTime(today.year, today.month, 1);

      List<Meals> mealsThisMonth = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(firstDayOfMonth) ||
            mealDate.isAtSameMomentAs(firstDayOfMonth);
      }).toList();

      int totalItemsThisMonth = mealsThisMonth.length;
      int daysInMonth = DateTime(today.year, today.month + 1, 0).day;

      return totalItemsThisMonth / daysInMonth;
    }

    double calculateTotalItemsThisMonth(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime firstDayOfMonth = DateTime(today.year, today.month, 1);

      List<Meals> mealsThisMonth = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(firstDayOfMonth) ||
            mealDate.isAtSameMomentAs(firstDayOfMonth);
      }).toList();

      int totalItemsThisMonth = mealsThisMonth.length;
      return totalItemsThisMonth.toDouble();
    }

    double calculatePercentageChangeLastMonth(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime firstDayOfMonth = DateTime(today.year, today.month, 1);

      DateTime lastMonth = DateTime(today.year, today.month - 1, 1);

      List<Meals> mealsThisMonth = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(firstDayOfMonth) ||
            mealDate.isAtSameMomentAs(firstDayOfMonth);
      }).toList();

      List<Meals> mealsLastMonth = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(lastMonth) &&
            mealDate.isBefore(firstDayOfMonth);
      }).toList();

      int totalItemsThisMonth = mealsThisMonth.length;
      int totalItemsLastMonth = mealsLastMonth.length;

      double percentageChange =
          ((totalItemsThisMonth - totalItemsLastMonth) / totalItemsLastMonth) *
              100;

      return percentageChange;
    }

    int calculateTotalServingAmountThisMonth(List<Meals> meals) {
      DateTime today = DateTime.now();
      DateTime firstDayOfMonth = DateTime(today.year, today.month, 1);

      List<Meals> mealsThisMonth = meals.where((meal) {
        DateTime mealDate = meal.date.toDate();
        return mealDate.isAfter(firstDayOfMonth) ||
            mealDate.isAtSameMomentAs(firstDayOfMonth);
      }).toList();

      int totalServingAmountThisMonth = 0;

      for (var meal in mealsThisMonth) {
        totalServingAmountThisMonth += meal.aided;
      }

      return totalServingAmountThisMonth;
    }

    int totalServingAmountMonth = calculateTotalServingAmountThisMonth(_meals);
    double percentageChangeLastMonth =
        calculatePercentageChangeLastMonth(_meals);
    double totalItemsThisMonth = calculateTotalItemsThisMonth(_meals);
    double averageMealsPerMonth = calculateAverageItemsPerMonth(_meals);

    int totalServingAmount = calculateTotalServingAmountThisWeek(_meals);
    double percentageChangeLastWeek = calculatePercentageChangeLastWeek(_meals);
    double totalItemsThisWeek = calculateTotalItemsThisWeek(_meals);
    double averageMealsPerDay = calculateAverageItemsPerDay(_meals);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentTab: TabItem.Summary,
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
            padding: const EdgeInsets.fromLTRB(30, 70, 0, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.summarize,
                    size: 40,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                const Text(
                  'Summary',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(
                      width: width * 0.8,
                      child: Text(
                        totalServingAmount == 0
                            ? "You Can Step it Up, No Meals Donated this Week"
                            : 'Great Job, You Have Donated ${_isWeeklySelected ? totalServingAmount.toString() : totalServingAmountMonth.toString()} Meals This ${_isWeeklySelected ? "Week" : "Month"}',
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 20,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: width * 0.5,
                      height: 43,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: width * 0.5,
                              height: 43,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF23292E),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.50, color: Color(0xFF353B3F)),
                                  borderRadius: BorderRadius.circular(78),
                                ),
                              ),
                            ),
                          ),
                          CustomSwitch(
                            isWeeklySelected: _isWeeklySelected,
                            isMonthlySelected: _isMonthlySelected,
                            onToggleWeek: _toggleSelectionWeek,
                            onToggleMonth: _toggleSelectionMonth,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    children: List.generate(4, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.5, color: AppColors.cardColor),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isWeeklySelected
                                ? Text(
                                    index == 0
                                        ? totalItemsThisWeek.toString()
                                        : index == 1
                                            ? averageMealsPerDay
                                                        .toString()
                                                        .length >
                                                    3
                                                ? averageMealsPerDay
                                                    .toString()
                                                    .substring(0, 3)
                                                : averageMealsPerDay.toString()
                                            : index == 2
                                                ? percentageChangeLastWeek !=
                                                        double.infinity
                                                    ? "${percentageChangeLastWeek.toString()}%"
                                                    : "Not enough data"
                                                : totalServingAmount.toString(),
                                    style: const TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 12,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                : Text(
                                    index == 0
                                        ? totalItemsThisMonth.toString()
                                        : index == 1
                                            ? averageMealsPerMonth
                                                        .toString()
                                                        .length >
                                                    3
                                                ? averageMealsPerMonth
                                                    .toString()
                                                    .substring(0, 3)
                                                : averageMealsPerMonth
                                                    .toString()
                                            : index == 2
                                                ? percentageChangeLastMonth !=
                                                        double.infinity
                                                    ? "${percentageChangeLastMonth.toString()}%"
                                                    : "Not enough data"
                                                : totalServingAmountMonth
                                                    .toString(),
                                    style: const TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 12,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                            Center(
                              child: Text(
                                index == 0
                                    ? "Total Meals"
                                    : index == 1
                                        ? "Average Meals Per Day This ${_isWeeklySelected ? "Week" : "Month"}"
                                        : index == 2
                                            ? "From Last ${_isWeeklySelected ? "Week" : "Month"}"
                                            : "People Aided",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF5E6469),
                                  fontSize: 10,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Meals {
  final int servingAmount;
  final Timestamp date;
  final int aided;

  Meals({
    required this.aided,
    required this.date,
    required this.servingAmount,
  });
}

class CustomSwitch extends StatelessWidget {
  final bool isWeeklySelected;
  final bool isMonthlySelected;
  final VoidCallback onToggleWeek;
  final VoidCallback onToggleMonth;

  const CustomSwitch({
    super.key,
    required this.isWeeklySelected,
    required this.isMonthlySelected,
    required this.onToggleWeek,
    required this.onToggleMonth,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 41,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            left: isWeeklySelected ? 0 : width * 0.25,
            right: isWeeklySelected ? width * 0.25 : 0,
            child: Container(
              width: width * 0.25,
              height: 41,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(78),
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onToggleWeek,
                  child: Container(
                    height: 41,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(78),
                        bottomLeft: Radius.circular(78),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Weekly',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isWeeklySelected
                              ? AppColors.hintTextColor
                              : AppColors.textColor,
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onToggleMonth,
                  child: Container(
                    height: 41,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(78),
                        bottomRight: Radius.circular(78),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Monthly',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isMonthlySelected
                              ? AppColors.hintTextColor
                              : AppColors.textColor,
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
