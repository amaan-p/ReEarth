import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reearth/components/customcard.dart';
import 'package:reearth/screens/Booking.dart';
import 'package:reearth/screens/community.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/bottomNav.dart';
import '../components/header.dart';
import '../main.dart';
import 'Home.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  String title;String desc;String phno;int price;

  Info(this.coordinates, this.news,this.title,this.desc,this.phno,this.price);
  @override
  State<Info> createState() => _Info();
}

class _Info extends State<Info> {
  int _selectedIndex = 2;

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
    }if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommunityScreen(widget.coordinates, widget.news).animate().fadeIn(duration: 500.milliseconds)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left:18.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.lightGreenAccent,size: 40,weight:15 ,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
      body: Container(
        width: 430,
        height: 932,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              top: -50,
              bottom: 200,
              child:  CachedNetworkImage(
                imageUrl: "https://kwypawgdpzmezidelkvo.supabase.co/storage/v1/object/public/avataars/public/${widget.title}.png",
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.02, 1.00),
                    end: Alignment(0.02, -1),
                    colors: [Colors.black,Colors.black,Colors.black.withOpacity(0.9),Colors.black.withOpacity(0.6),Colors.black.withOpacity(0.3),Colors.black.withOpacity(0), Colors.black.withOpacity(0.1)],
                  ),
                ),
              ),
            ),
            Center(
              child: Positioned(
                top: 450,
                child: Padding(
                  padding: const EdgeInsets.only(top:100.0),
                  child: Text(
                    "${widget.title}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 591,
              left:15,
              child: Center(
                child: SizedBox(
                  width: 364,
                  height: 161,
                  child: Text(
                    '${widget.desc}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:238.0),
              child: Center(
                child: Positioned(
                  left: 112,
                  top: 497,
                  child: Container(
                    width: 209,
                    height: 46,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 209,
                            height: 46,
                            decoration: ShapeDecoration(
                              color: Color(0xFF3DEC02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 26,
                          top: 13,
                          child: Text(
                            'Asking Price : ₹ ${widget.price.toString()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 650.0),
                child: Center(
                  child: Positioned(
                    left: 123,
                    top: 637,
                    child: GestureDetector(
                      onTap: (){
                        launchUrl(Uri.parse("tel://${widget.phno}") );
                      },
                      child: Container(
                        width: 209,
                        height: 46,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 209,
                                height: 46,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF3DEC02),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 22,
                              top: 13,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Icon(Icons.phone),
                                  ),
                                  Text(
                                    'Contact Seller',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



