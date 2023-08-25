import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../components/bottom_nav_bar.dart';
import '../../constants.dart';
import 'meal_locate.dart';

class DetailsPopup extends StatefulWidget {
  const DetailsPopup({Key? key, required this.mapPoint}) : super(key: key);
  final MapPoint mapPoint;

  @override
  _DetailsPopupState createState() => _DetailsPopupState();
}

class _DetailsPopupState extends State<DetailsPopup> {
  bool _isContainerVisible = false;
  String allergen = "N/A";
  String phoneNum = "N/A";
  String email = "N/A";

  void getAllergensForUser(MapPoint mapPoint) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDocument =
        await usersCollection.doc(mapPoint.uid).get();

    if (userDocument.exists) {
      Map<String, dynamic> userData =
          userDocument.data() as Map<String, dynamic>;
      setState(() {
        allergen = userData["allergens"];
        phoneNum = userData["phone"];
        email = userData["email"];
      });
    }
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        return address;
      } else {
        return "No address found";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  int _number = 1;

  @override
  void initState() {
    super.initState();
    getAllergensForUser(widget.mapPoint);
  }

  void _decrement() {
    if (_number > 0) {
      setState(() {
        _number = _number - 1;
      });
    }
  }

  void _increment() {
    if (_number < widget.mapPoint.servingAmount) {
      setState(() {
        _number = _number + 1;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Max Meals Reached'),
            content: const Text("No more meals available"),
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

    Future<void> decrementServingAmount(int amount) async {
      try {
        final DocumentReference mealRef = FirebaseFirestore.instance
            .collection('meals')
            .doc(widget.mapPoint.documentID);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(mealRef);
          int? currentAided =
              (snapshot.data() as Map<String, dynamic>)['aided'];
          if (snapshot.exists) {
            int currentServingAmount = snapshot['servingAmount'] ?? 0;
            if (currentServingAmount > 0) {
              transaction.update(
                mealRef,
                {
                  'servingAmount': currentServingAmount - amount,
                  'aided': currentAided! + currentServingAmount
                },
              );
            } else {
              print("Serving amount is already at 0.");
            }
          } else {
            print("Document does not exist.");
          }
        });
      } catch (e) {
        print("Error: $e");
      }
    }

    Text servingText = Text(
      _number > 1
          ? "Serves: ${widget.mapPoint.servingAmount} (-$_number)"
          : "Serves: ${widget.mapPoint.servingAmount}",
      style: const TextStyle(color: Colors.white),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: BottomNavigationBarWidget(
        currentTab: TabItem.Map,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.backgroundColor,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Meal Info: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: servingText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Description: ${widget.mapPoint.description.length > 20 ? "${widget.mapPoint.description.substring(0, 17)}..." : widget.mapPoint.description}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Extra Info: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Allergen Information: $allergen",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Phone Number: $phoneNum",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email: $email",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Quantity: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Container(
                            width: width * 0.35,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(width * 0.02),
                              color: AppColors.cardColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: _decrement,
                                  icon: const Icon(
                                    Icons.remove,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                Text(
                                  _number.toString(),
                                  style: const TextStyle(
                                    color: AppColors.textColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _increment,
                                  icon: const Icon(
                                    Icons.add,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              child: Container(
                                width: width * 0.3,
                                height: height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.02),
                                  color: AppColors.accentColor,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0.04,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Confirm",
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: width * 0.05,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                try {
                                  decrementServingAmount(_number).then(
                                    (value) => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Data Saved'),
                                          content:
                                              Text("$_number meals reduced"),
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
                                    ),
                                  );
                                } on Exception catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.05,
                )
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: _isContainerVisible
                ? 0
                : MediaQuery.of(context).size.height / 2,
            right: _isContainerVisible
                ? 0
                : -MediaQuery.of(context).size.width / 2,
            child: GestureDetector(
              onTap: _toggleContainerVisibility,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Serves ${widget.mapPoint.servingAmount.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        shadowColor: AppColors.backgroundColor,
        elevation: 100,
        title: FutureBuilder(
          future: getAddressFromLatLng(
              widget.mapPoint.latitude, widget.mapPoint.longitude),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('N/A');
            } else {
              return Text("${snapshot.data}");
            }
          },
        ),
      ),
    );
  }
}
