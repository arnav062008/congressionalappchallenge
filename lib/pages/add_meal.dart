import 'package:congressionalappchallenge/pages/map.dart';
import 'package:congressionalappchallenge/pages/summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealAdd extends StatefulWidget {
  const MealAdd({Key? key}) : super(key: key);

  @override
  State<MealAdd> createState() => _MealAddState();
}

class _MealAddState extends State<MealAdd> {
  final TextEditingController descriptionController = TextEditingController();
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  void onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(),
      backgroundColor: const Color(0xFF22282C),
      body: Column(
        children: [
          TopBarWidget(),
          const SizedBox(height: 8),
          TitleWidget(),
          const SizedBox(height: 8),
          Container(
            width: 351,
            height: 500,
            decoration: ShapeDecoration(
              color: const Color(0xFF2E343B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: height * 0.05),
                TextBox(
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
                          color: Color(0xFFFEFCFB),
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
                            onTap: () {
                              // Handle save button action here
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF39ACE7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFEFCFB),
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
                                width: 156,
                                height: 42,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFEFCFB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Serving Amount',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF555553),
                                      fontSize: 15,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapScreen()),
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
                          SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 45,
                                color: Colors.white,
                              )
                            ],
                          )
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

class BottomNavigationBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final iconSize = width / 10;

    return Container(
      width: width * 0.866,
      height: MediaQuery.of(context).size.height * 0.13,
      decoration: const ShapeDecoration(
        color: Color(0xFF2E343B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Summary()),
              );
            },
            icon: Icon(
              Icons.house_outlined,
              size: iconSize,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.map_outlined,
              size: iconSize,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MealAdd()),
              );
            },
            icon: Icon(
              Icons.add_circle_outline,
              size: iconSize,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings_outlined,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class TopBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width * 0.08),
      child: Align(
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
    );
  }
}

class TitleWidget extends StatelessWidget {
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

class TextBox extends StatelessWidget {
  final double width;
  final double height;
  final TextEditingController controller;

  const TextBox({
    required this.width,
    required this.height,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: const Color(0xFFFEFCFB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Write a description',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
