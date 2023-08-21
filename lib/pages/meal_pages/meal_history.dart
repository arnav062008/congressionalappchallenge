import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/bottom_nav_bar.dart';

class MealHistory extends StatefulWidget {
  @override
  State<MealHistory> createState() => _MealHistoryState();
}

class _MealHistoryState extends State<MealHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(),
      backgroundColor: const Color(0xFF22282C),
      body: Column(
        children: [
          TopBarWidget(),
          TitleWidget(),
          Expanded(
            child: MealDisplay(
                currentUserUid: FirebaseAuth.instance.currentUser!.uid),
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
            final description = document['description'].toString() ?? '';
            final servingAmount = document['servingAmount'].toString() ?? '';

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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2E343B),
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
                    color: const Color(0xFF23292E),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.50, color: Color(0xFF353B3F)),
                      borderRadius: BorderRadius.circular(78),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      description,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 171,
                  height: 41,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF23292E),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.50, color: Color(0xFF353B3F)),
                      borderRadius: BorderRadius.circular(78),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      servingAmount,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF23292E),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}

class TopBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          width * 0.08, width * 0.1, width * 0.08, width * 0.04),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
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
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
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
            color: Color(0xFFFEFCFB),
            fontSize: 20,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
