import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;

class MapPointScreen extends StatefulWidget {
  const MapPointScreen({super.key});

  @override
  _MapPointScreenState createState() => _MapPointScreenState();
}

class _MapPointScreenState extends State<MapPointScreen> {
  GoogleMapController? _mapController;
  LatLng? _initialPosition;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MapPoint> _mapPoints = []; // Initialize an empty list
  double? _selectedLatitude;
  double? _selectedLongitude;

  final TextEditingController _searchController = TextEditingController();

  Future<List<MapPoint>> getMapPointsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("meals").get();
      List<MapPoint> mapPoints = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          if (data.containsKey("servingAmount") &&
              data.containsKey("latitude") &&
              data.containsKey("longitude") &&
              data.containsKey("description")) {
            mapPoints.add(MapPoint(
              servingAmount: data["servingAmount"],
              latitude: data["latitude"],
              longitude: data["longitude"],
              description: data["description"],
            ));
          }
        }
      }

      return mapPoints;
    } catch (e) {
      print('Error fetching data: $e');
      return []; // Handle error here or return an empty list.
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getMapPointsFromFirestore().then((mapPoints) {
      setState(() {
        _mapPoints = mapPoints;
        print(_mapPoints.length);
      });
    });
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
      // If permission is not granted, request it.
      final permissionStatus = await location.requestPermission();
      if (permissionStatus == l.PermissionStatus.granted) {
        _getCurrentLocation(); // Retry getting the current location after permission is granted.
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
                      markerId: MarkerId(point.servingAmount.toString()),
                      position: LatLng(point.latitude, point.longitude),
                      onTap: () {
                        _showPointDetails(
                            point); // Show point details when marker is tapped
                      },
                    );
                  }).toSet(),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            color: Color(0xAAFFFFF),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for an address',
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    String query = _searchController.text;
                                    if (query.isNotEmpty) {
                                      List<Location> locations =
                                          await locationFromAddress(query);
                                      if (locations.isNotEmpty) {
                                        Location location = locations.first;
                                        LatLng position = LatLng(
                                          location.latitude!,
                                          location.longitude!,
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
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _showPointDetails(MapPoint point) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(point.servingAmount.toString()),
          content: Text(
              "Latitude: ${point.latitude}\nLongitude: ${point.longitude}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
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

  MapPoint(
      {required this.description,
      required this.servingAmount,
      required this.latitude,
      required this.longitude});
}

