import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentTab: TabItem.AddMeal,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          const TopBarWidget(),
          const TitleWidget(),
          Expanded(
            child: MealDisplay(
              currentUserUid: FirebaseAuth.instance.currentUser!.uid,
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
    return StreamBuilder<QuerySnapshot>(
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
          return const Center(child: Text('No meals found.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((document) {
            final description = document['description'].toString();
            final servingAmount = document['servingAmount'].toString();

            return MealEntryWidget(
              description: description,
              servingAmount: servingAmount,
            );
          }).toList(),
        );
      },
    );
  }
}

class MealEntryWidget extends StatelessWidget {
  final String description;
  final String servingAmount;

  const MealEntryWidget({
    required this.description,
    required this.servingAmount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(70),
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
                      description,
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
                      servingAmount,
                      style: const TextStyle(color: AppColors.textColor),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
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

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        height: height * 0.072,
        child: const Text(
          'Meal History',
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
