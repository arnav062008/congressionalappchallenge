// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:congressionalappchallenge/components/bottom_nav_bar.dart';
import 'package:congressionalappchallenge/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;

import 'meal_detail_popup.dart';

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
            DateTime date = (data['date'] as Timestamp).toDate();

            if (data["servingAmount"] > 0 && date.isBefore(DateTime.now())) {
              mapPoints.add(MapPoint(
                documentID: documentSnapshot.id,
                uid: data['uid'],
                servingAmount: data["servingAmount"],
                latitude: data["latitude"],
                longitude: data["longitude"],
                description: data["description"],
              ));
            }
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                const Align(
                    alignment: Alignment.bottomCenter,
                    child: BottomNavigationBarWidget(currentTab: TabItem.Map)),
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
  final String documentID;

  MapPoint({
    required this.documentID,
    required this.description,
    required this.servingAmount,
    required this.latitude,
    required this.longitude,
    required this.uid,
  });
}
