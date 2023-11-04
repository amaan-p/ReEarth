import 'package:flutter/material.dart';
import 'package:reearth/screens/Booking.dart';
import 'package:reearth/screens/community.dart';

import '../screens/Home.dart';
import 'bottomNav.dart';

class NavMenu extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List< dynamic> news;
  final int selectedindex;

  NavMenu(this.coordinates, this.selectedindex,this.news);

  @override
  _NavMenuState createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedindex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(widget.coordinates,widget.news),
          BookingScreen(widget.coordinates, widget.news),
          CommunityScreen(widget.coordinates, widget.news)
        ],
      ),
    );
  }
}
