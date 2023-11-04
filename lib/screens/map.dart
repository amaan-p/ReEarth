
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/bottomNav.dart';
import '../main.dart';
import 'Booking.dart';
import 'Home.dart';
import 'package:flutter/material.dart';

import 'community.dart';


class MapScreen extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;


  MapScreen(this.coordinates, this.news);
  @override
  State<MapScreen> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  int _selectedIndex = 0;
  Set<Marker> markers = {}; // Set to store markers
  late GoogleMapController mapController;
  late CameraPosition _initialCameraPosition;
  late String _mapStyle;
late double Lat=19.0760;
late double Long=72.8777;
  List<dynamic> vendors = []; // List to store vendor data

  Future<void> fetchVendors() async {
    final response = await supabase.from('Vendors').select();
    setState(() {
      vendors = response as List<dynamic>;
    });
  }
  Future<void> fetchdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Lat = prefs.getDouble("lat")??19.0760;
      Long = prefs.getDouble("long")??72.8777;
      _initialCameraPosition = CameraPosition(
          target: LatLng(Lat,Long),
          zoom: 9
      );
    });
  }
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
        ), "assets/components/vmarker1.png")
        .then(
          (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }


  void initState() {
    super.initState();
    addCustomIcon();
    fetchdata().then((_) { // Wait for fetchdata() to complete
      rootBundle.loadString('assets/map_style.txt').then((string) {
        setState(() {
          _mapStyle = string;
          fetchVendors(); // Fetch vendor data after map style is loaded

        });
      });
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home(widget.coordinates, widget.news).animate().fadeIn(duration: 500.milliseconds)),
      );
    }
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Booking(widget.coordinates, widget.news).animate().fadeIn(duration: 500.milliseconds)),
      );
    }
    if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Community(widget.coordinates, widget.news).animate().fadeIn(duration: 500.milliseconds)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/home.png"),
          ),
        ),
        child: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.6),
                child: Stack(
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.w,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                          mapController.setMapStyle(_mapStyle);
                        },
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        initialCameraPosition: _initialCameraPosition,
                        markers: vendors.map((vendor) {
                          double latitude = vendor['Latitude'] as double;
                          double longitude = vendor['Longitude'] as double;
                          return Marker(
                            icon: markerIcon,
                            markerId: MarkerId('vendor_${vendor['id']}'),
                            position: LatLng(latitude, longitude),
                            infoWindow: InfoWindow(
                              title: vendor['name'],
                              snippet: "${vendor['address']}, ${vendor['city']}"// You can replace 'name' with the appropriate field from your vendor data
                            ),
                          );
                        }).toSet(),
                      ),

                    ),

                    Positioned(
                      left: 50,top:20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 275,
                          height: 58,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 275,
                                  height: 58,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF3DEC02),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Nearby Recycling Centers',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
