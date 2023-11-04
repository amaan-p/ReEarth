import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reearth/screens/announcements.dart';
import 'package:reearth/screens/insights.dart';
import 'package:reearth/screens/map.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';


class HomeMenu extends StatefulWidget{
  final Map<String, dynamic> coordinates;
  final List< dynamic> news;
  HomeMenu(this.coordinates,this.news);
  State<HomeMenu> createState()=>_HomeMenu();
}

class _HomeMenu extends State<HomeMenu>{
  String _currentLocation = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = 'Location services are disabled.';
      });
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = 'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _currentLocation = 'Location permissions are denied (actual value: $permission).';
        });
        return;
      }
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation =
        'Latitude: ${position.latitude}\nLongitude: ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        _currentLocation = 'Error: ${e.toString()}';
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return  Container(
      width: 370,
      height: 267,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => News(widget.coordinates,widget.news)),
              );
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 177,
                    height: 270,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/components/waste.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top:150,
                  right: 200,
                  child: InkWell(
                    onTap: (){

                    },
                    child: Container(
                      width: 177,
                      height: 270,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.bottomCenter,
                          end: AlignmentDirectional.topCenter,
                          colors: [Colors.black, Colors.transparent],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0,bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Latest News About \nRecycling Materials',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => News(widget.coordinates,widget.news)),
                                  );
                                }, icon:FaIcon(FontAwesomeIcons.angleRight,color: Color.fromARGB(255,139,195,74),size: 30,),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Insights(widget.coordinates,widget.news)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top:2.0),
              child: Stack(
                children: [
                  Positioned(
                    left: 184,
                    top: 135,
                    child: Container(
                      width: 187,
                      height: 129,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/components/insights.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                      ),

                    ),
                  ),
                  Positioned.fill(
                    left: 184,
                    top: 135,
                    child: Container(
                      decoration:ShapeDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.bottomCenter,
                          end: AlignmentDirectional.topCenter,
                          colors: [Colors.black, Colors.transparent],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                        ),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'View Insights',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                IconButton(onPressed: (){

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Insights(widget.coordinates,widget.news)),
                                  );
                                }, icon:FaIcon(FontAwesomeIcons.angleRight,color: Color.fromARGB(255,139,195,74),size: 30,))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: ()async{
              print("map");
              {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen(
                    widget.coordinates,
                    widget.news
                   ).animate(delay: 0.5.seconds)),
                );
              }
            },
            child: Stack(
              children: [
                Positioned(
                  left: 184,
                  top: 0,
                  child: Container(
                    width: 187,
                    height: 129,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/components/map.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  left: 184,
                  bottom:135,
                  child: Container(
                    width: 187,
                    height: 129,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.bottomCenter,
                        end: AlignmentDirectional.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0,bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(

                                'View Nearby \nRecycling Centers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              IconButton(onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MapScreen(
                                    widget.coordinates,
                                    widget.news,
                                    )),
                                );
                              }, icon:FaIcon(FontAwesomeIcons.angleRight,color: Color.fromARGB(255,139,195,74),size: 30,))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

