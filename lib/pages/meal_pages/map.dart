import 'package:congressionalappchallenge/components/bottom_nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;

import '../../constants.dart';
import 'add_meal.dart';

class MapScreen extends StatefulWidget {
  final String? desc;
  final DateTime? date;
  final int? servingAmt;
  const MapScreen({Key? key, this.desc, this.date, this.servingAmt})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _initialPosition;
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  bool _markerPlaced = false;
  double? _selectedLatitude;
  double? _selectedLongitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  void _onMapDoubleTap(LatLng position) async {
    setState(() {
      _markerPlaced = true;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('new_location'),
          position: position,
        ),
      );
      _selectedLatitude = position.latitude;
      _selectedLongitude = position.longitude;
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      String address =
          "${placemark.street}, ${placemark.locality}, ${placemark.country}";
      if (kDebugMode) {
        print("New pin address: $address");
      }
    }
  }

  void _onDoneButtonPressed() {
    if (_selectedLatitude != null && _selectedLongitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MealAdd(
            latitude: _selectedLatitude,
            longitude: _selectedLongitude,
            descr: widget.desc,
            dates: widget.date,
            serve: widget.servingAmt,
          ),
        ),
      );
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
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  onTap: (position) => _onMapDoubleTap(position),
                ),
                Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.hintTextColor,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: _markerPlaced
                              ? MediaQuery.of(context).size.width * 0.65
                              : MediaQuery.of(context).size.width * 0.7,
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
                        const Spacer(),
                        _markerPlaced
                            ? Align(
                                alignment: Alignment.bottomLeft,
                                child: IconButton(
                                  color: AppColors.hintTextColor,
                                  onPressed: _onDoneButtonPressed,
                                  icon: const Icon(
                                    Icons.done,
                                    size: 25,
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavigationBarWidget(
                    currentTab: TabItem.AddMeal,
                  ),
                )
              ],
            ),
    );
  }
}
