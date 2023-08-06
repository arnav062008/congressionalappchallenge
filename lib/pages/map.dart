import 'package:congressionalappchallenge/pages/add_meal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
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
      // If permission is not granted, request it.
      final permissionStatus = await location.requestPermission();
      if (permissionStatus == l.PermissionStatus.granted) {
        _getCurrentLocation(); // Retry getting the current location after permission is granted.
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
                latitude: _selectedLatitude, longitude: _selectedLongitude)),
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
                  onTap: (position) =>
                      _onMapDoubleTap(position), // Change onTap to onDoubleTap
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
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
                                    setState(() {
                                      _markers.clear();
                                      _markers.add(
                                        Marker(
                                          markerId:
                                              const MarkerId('search_result'),
                                          position: position,
                                        ),
                                      );
                                      _selectedLatitude = position.latitude;
                                      _selectedLongitude = position.longitude;
                                    });
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
                _markerPlaced
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: _onDoneButtonPressed,
                            icon: const Icon(
                              Icons.done,
                              size: 25,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
