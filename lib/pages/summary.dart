import 'package:congressionalappchallenge/components/bottom_nav_bar.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
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
                      child: const Text(
                        'Great Job, You Have Donated 27 Meals This Week',
                        style: TextStyle(
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
                          border: Border.all(width: 0.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Top Text $index',
                              style: const TextStyle(
                                color: AppColors.textColor,
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
            ),
          )
        ],
      ),
    );
  }
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
