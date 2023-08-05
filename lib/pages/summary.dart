import 'package:congressionalappchallenge/pages/add_meal.dart';
import 'package:congressionalappchallenge/pages/settings.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(),
      backgroundColor: const Color(0xFF22282C),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
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
          ),
          const SizedBox(
            width: 280,
            child: Text(
              'Great Job, You Have Donated 27 Meals This Week',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFEFCFB),
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 177,
              height: 43,
              child: Stack(
                children: [
                  Positioned(
                    left: 6,
                    top: 2,
                    child: Container(
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
                    ),
                  ),
                  const CustomSwitch(),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 366.06,
            height: 169.30,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: SizedBox(
                    width: 366.06,
                    height: 169.30,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 2.89,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 0.72,
                          top: 161.36,
                          child: SizedBox(
                            width: 5.05,
                            height: 7.94,
                            child: Text(
                              '0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 54.46,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 53.02,
                          top: 161.36,
                          child: SizedBox(
                            width: 3.61,
                            height: 7.94,
                            child: Text(
                              '1',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 106.03,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 103.87,
                          top: 161.36,
                          child: SizedBox(
                            width: 5.05,
                            height: 7.94,
                            child: Text(
                              '2',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 157.60,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 155.44,
                          top: 161.36,
                          child: SizedBox(
                            width: 5.05,
                            height: 7.94,
                            child: Text(
                              '3',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 209.18,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 207.01,
                          top: 161.36,
                          child: SizedBox(
                            width: 5.05,
                            height: 7.94,
                            child: Text(
                              '4',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 260.75,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 258.58,
                          top: 161.36,
                          child: SizedBox(
                            width: 5.05,
                            height: 7.94,
                            child: Text(
                              '5',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 312.32,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 310.15,
                          top: 161.36,
                          child: SizedBox(
                            width: 5.05,
                            height: 7.94,
                            child: Text(
                              '6',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 363.89,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 158.72,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 361.73,
                          top: 161.36,
                          child: SizedBox(
                            width: 4.33,
                            height: 7.94,
                            child: Text(
                              '7',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFEFCFB),
                                fontSize: 10,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 159.25,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 136.57,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 113.90,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 91.22,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 68.55,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 45.88,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 23.20,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 0.53,
                          child: Container(
                            width: 361,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 161.36,
                          child: Container(
                            width: 363.89,
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xFF555553),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 2.89,
                          top: 159.25,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(0.0, 0.0)
                              ..rotateZ(-1.57),
                            child: Container(
                              width: 159.25,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFF555553),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: width / height * 4,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            children: List.generate(4, (index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Top Text $index',
                      style: const TextStyle(
                        color: Color(0xFFFEFCFB),
                        fontSize: 12,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      index == 0
                          ? "Total Meals"
                          : index == 1
                              ? "Average Meals Per Week"
                              : index == 2
                                  ? "From Last Month"
                                  : "People Aided",
                      style: const TextStyle(
                        color: Color(0xFF5E6469),
                        fontSize: 12,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      decoration: ShapeDecoration(
        color: const Color(0xFF23292E),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0xFF353B3F)),
          borderRadius: BorderRadius.circular(78),
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            left: _isWeeklySelected ? 0 : 85, // Adjust the position as needed
            right: _isWeeklySelected ? 85 : 0, // Adjust the position as needed
            child: Container(
              width: 85,
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
                  onTap: () => _toggleSelectionWeek(),
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
                          color: _isWeeklySelected
                              ? const Color(0xFF555553)
                              : const Color(0xFFFEFCFB),
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
                  onTap: () => _toggleSelectionMonth(),
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
                          color: _isMonthlySelected
                              ? const Color(0xFF555553)
                              : const Color(0xFFFEFCFB),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
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
