import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reearth/components/HomeMenu.dart';
import 'package:reearth/components/NavigationMenu.dart';
import 'package:reearth/components/bottomNav.dart';
import 'package:reearth/components/header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/graph.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  Home(this.coordinates,this.news);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavMenu(widget.coordinates,_selectedIndex,widget.news),
    );
  }
}




class HomeScreen extends StatefulWidget{
  Map<String, dynamic> coordinates;
  List< dynamic> news;
  HomeScreen(this.coordinates,this.news);
  State<HomeScreen> createState()=>_HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backgrounds/home.png")
            )
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Header(widget.coordinates,widget.news),
                    LineChartExample(widget.coordinates),
                    Padding(
                      padding: const EdgeInsets.only(top:10,bottom: 8.0),
                      child: HomeMenu(widget.coordinates,widget.news),
                    ),
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







/*        Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    prefs.setString('id', "");
                    // Sign out from Google
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await googleSignIn.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }, child:Text("Logout")),
                ),*/



