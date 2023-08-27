import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/pages/meal_pages/add_meal.dart';
import 'package:congressionalappchallenge/pages/meal_pages/update_meal_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';
import '../../constants.dart';

class MealHistory extends StatefulWidget {
  const MealHistory({super.key});

  @override
  State<MealHistory> createState() => _MealHistoryState();
}

class _MealHistoryState extends State<MealHistory> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentTab: TabItem.History,
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
                    Icons.history,
                    size: 40,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                const Text(
                  'Meal History',
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
                      MaterialPageRoute(builder: (context) => const MealAdd()),
                    );
                  },
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.add_box,
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
              child: MealDisplay(
                currentUserUid: FirebaseAuth.instance.currentUser!.uid,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MealDisplay extends StatelessWidget {
  final String currentUserUid;

  const MealDisplay({Key? key, required this.currentUserUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
            'Current and Previous Meals',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 20,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('meals')
              .where('uid', isEqualTo: currentUserUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No meals found.',
                  style: TextStyle(color: AppColors.textColor),
                ),
              );
            }

            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var document in snapshot.data!.docs)
                  MealEntryWidget(
                    date: document['date'],
                    description: document['description'].toString(),
                    aidGiven: document['aided'],
                    documentId: document.id,
                    servingAmount: document['servingAmount'],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class MealEntryWidget extends StatelessWidget {
  final String description;
  final int aidGiven;
  final int servingAmount;
  final Timestamp date;
  final String documentId;

  const MealEntryWidget({
    required this.description,
    required this.aidGiven,
    Key? key,
    required this.documentId,
    required this.date,
    required this.servingAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 171,
                  height: 41,
                  decoration: ShapeDecoration(
                    color: AppColors.backgroundColor,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 0.50,
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(78),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Description: ${description.length > 4 ? "${description.substring(0, 3)}..." : description}",
                      style: const TextStyle(color: AppColors.textColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 171,
                  height: 41,
                  decoration: ShapeDecoration(
                    color: AppColors.backgroundColor,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 0.50,
                        color: AppColors.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(78),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "People Served: ${aidGiven.toString()}",
                      style: const TextStyle(color: AppColors.textColor),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealUpdate(
                            mealId: documentId,
                            description: description,
                            servingAmount: servingAmount,
                            date: date,
                          )),
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.edit,
                    color: AppColors.textColor,
                    size: 35,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
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
        width * 0.08,
        width * 0.1,
        width * 0.08,
        width * 0.04,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Container(
            width: width * 0.1,
            height: width * 0.1,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.textColor,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
