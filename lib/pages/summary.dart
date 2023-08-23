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
          SizedBox(
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
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool isWeeklySelected;
  final bool isMonthlySelected;
  final VoidCallback onToggleWeek;
  final VoidCallback onToggleMonth;

  const CustomSwitch({
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
