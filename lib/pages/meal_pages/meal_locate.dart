// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/components/bottom_nav_bar.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;

class MapPointScreen extends StatefulWidget {
  const MapPointScreen({Key? key, this.desc, this.date, this.serve})
      : super(key: key);
  final String? desc;
  final DateTime? date;
  final String? serve;

  @override
  _MapPointScreenState createState() => _MapPointScreenState();
}

class _MapPointScreenState extends State<MapPointScreen> {
  GoogleMapController? _mapController;
  LatLng? _initialPosition;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MapPoint> _mapPoints = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> getMapPointsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("meals").get();
      List<MapPoint> mapPoints = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          if (_isValidMapPointData(data)) {
            mapPoints.add(MapPoint(
              uid: data['uid'],
              servingAmount: data["servingAmount"],
              latitude: data["latitude"],
              longitude: data["longitude"],
              description: data["description"],
            ));
          }
        }
      }

      setState(() {
        _mapPoints = mapPoints;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  bool _isValidMapPointData(Map<String, dynamic> data) {
    return data.containsKey("servingAmount") &&
        data.containsKey("latitude") &&
        data.containsKey("longitude") &&
        data.containsKey("description") &&
        data.containsKey("uid");
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getMapPointsFromFirestore();
  }

  void _getCurrentLocation() async {
    l.Location location = l.Location();
    final hasPermission = await location.hasPermission();
    if (hasPermission == l.PermissionStatus.granted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    } else {
      final permissionStatus = await location.requestPermission();
      if (permissionStatus == l.PermissionStatus.granted) {
        _getCurrentLocation();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: _initialPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition!,
                    zoom: 10,
                  ),
                  markers: _mapPoints.map((point) {
                    return Marker(
                      markerId: MarkerId(point.uid),
                      position: LatLng(point.latitude, point.longitude),
                      onTap: () {
                        _showDetailsPopup(point);
                      },
                    );
                  }).toSet(),
                ),
                Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: mediaQuery.size.width * 0.8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(100),
                                right: Radius.circular(100),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search for an address',
                                  hintStyle: const TextStyle(
                                    color: AppColors.hintTextColor,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      String query = _searchController.text;
                                      if (query.isNotEmpty) {
                                        List<Location> locations =
                                            await locationFromAddress(query);
                                        if (locations.isNotEmpty) {
                                          Location location = locations.first;
                                          LatLng position = LatLng(
                                            location.latitude,
                                            location.longitude,
                                          );
                                          _mapController?.animateCamera(
                                            CameraUpdate.newLatLng(position),
                                          );
                                        }
                                      }
                                    },
                                    iconSize: mediaQuery.size.width * 0.06,
                                    icon: const Icon(Icons.search),
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
              ],
            ),
    );
  }

  void _showDetailsPopup(MapPoint mapPoint) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return DetailsPopup(
          mapPoint: mapPoint,
        );
      },
    );
  }
}

class MapPoint {
  final int servingAmount;
  final double latitude;
  final double longitude;
  final String description;
  final String uid;

  MapPoint({
    required this.description,
    required this.servingAmount,
    required this.latitude,
    required this.longitude,
    required this.uid,
  });
}

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

  void getAllergensForUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDocument = await usersCollection.doc(uid).get();

    if (userDocument.exists) {
      Map<String, dynamic> userData =
          userDocument.data() as Map<String, dynamic>;
      setState(() {
        allergen = userData["allergens"];
        phoneNum = userData["phone"];
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

  @override
  void initState() {
    super.initState();
    getAllergensForUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(
        currentTab: TabItem.Map,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.cardColor,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Serves: ${widget.mapPoint.servingAmount}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                          const SizedBox(
                            height: 10,
                          ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Allergen Information: $allergen",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Phone Number: $phoneNum",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email: ${FirebaseAuth.instance.currentUser?.email}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        backgroundColor: AppColors.cardColor,
        shadowColor: AppColors.cardColor,
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
