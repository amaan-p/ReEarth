import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reearth/components/HomeMenu.dart';
import 'package:reearth/components/NavigationMenu.dart';
import 'package:reearth/components/bottomNav.dart';
import 'package:reearth/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/header4.dart';
import 'Booking.dart';
import 'Home.dart';
import 'community.dart';

class CurrentScreen extends StatefulWidget{

  Map<String, dynamic> coordinates;
  List< dynamic> news;
  String vendorid;
  CurrentScreen(this.coordinates,this.news,this.vendorid);
  State<CurrentScreen> createState()=>_CurrentScreen();
}



class _CurrentScreen extends State<CurrentScreen>{
  int _selectedIndex = 1;

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

  late GoogleMapController mapController;
  late dynamic response=[];
  late  final vendorloc = supabase.from('Vendors').stream(primaryKey: ['id']).eq("id",widget.vendorid);
  late final ongoingstream= supabase.from('Transactions').stream(primaryKey: ['id']).eq("centerid",widget.vendorid);

  late String _mapStyle;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late String vendorname="";
  late String metal="";
  late String plastic="";
  late String ewaste="";
  late String paper="";
  late String totalprice="";
  late String bag="";
  Future<void>getVendorDetails()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");

    final response = await supabase
        .from('Transactions')
        .select()
        .eq("ongoing", true);
    final vendorid=response[0]["centerid"];
    final data = await supabase
        .from('Vendors')
        .select()
        .eq("id", vendorid);
    setState(() {
      vendorname=data[0]["name"];
       plastic =  response[0]["material"][0]!=""
          ? response[0]["material"][0]
          : "0";
      ewaste= response[0]["material"][1]!=""
          ? response[0]["material"][1]
          : "0";
      paper= response[0]["material"][2]!=""
          ? response[0]["material"][2]
          : "0";;
      metal= response[0]["material"][3]!=""
          ? response[0]["material"][3]
          : "0";
      bag=response[0]["pebags"][0]!=""
          ? response[0]["pebags"][0]
          : "0";
      totalprice=response[0]["totalprice"].toString();
    });
  }

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





  @override
  void initState() {
    super.initState();
    addCustomIcon();
      rootBundle.loadString('assets/map_style.txt').then((string) {
        setState(() {
          _mapStyle = string;
        });
      });

    getVendorDetails();
  }

  @override
  Widget build(BuildContext context){
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
                child: Stack(
                  children: [
                    Flexible(child:StreamBuilder(
                      stream: vendorloc,
                      builder: (context,snapshot){
                        List<dynamic> data = snapshot.data as List<dynamic>;
                        var item=data[0];
                        double latitude = item['Latitude'] as double;
                        double longitude = item['Longitude'] as double;
                        return GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                              mapController.setMapStyle(_mapStyle);
                            },
                            initialCameraPosition: CameraPosition(target: LatLng(19.287140,72.868843),
                                zoom:10
                            ),
                          markers:{
                            Marker(markerId:MarkerId('clientloc'),
                              position: LatLng(19.102883,  72.837421),
                            ),
                              Marker(markerId:MarkerId('vendorloc'),
                                position: LatLng(latitude, longitude),
                                icon: markerIcon,
                                )
                          }
                        );
                      },
                    ) ),



                    Padding(
                      padding: const EdgeInsets.only(top:650.0,left: 15),
                      child: Container(
                        width: 360,
                        height: 140,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 360,
                                height: 134,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 27,
                              top: 19,
                              child: Text(
                                vendorname,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 119,
                              top: 80,
                              child: Text(
                                'Paper:${paper}kg',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 118,
                              top: 54,
                              child: Text(
                                'Metals:${metal}kg',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 54,
                              child: Text(
                                'Plastics:${plastic}kg',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 24,
                              top: 80,
                              child: Text(
                                'E-Waste:${ewaste}kg',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ),Positioned(
                              left: 24,
                              top: 105,
                              child: Text(
                                'PE Bags :${bag}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                            ),






                            GestureDetector(
                             onTap: ()async{
                               final response = await supabase
                                   .from('Transactions')
                                   .select()
                                   .eq("ongoing", true);
                                print(response);

///Navigator.of(context).pop(true);
                               await supabase
                                   .from('Transaction')
                                   .update({ 'ongoing': false })
                                   .match({ 'id': response[0]["id"] });
                             },
                              child: Positioned(
                                left: 219,
                                top: 33,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:209.0,top: 35),
                                  child: Container(
                                    width: 127,
                                    height: 47,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          child: Container(
                                            width: 127,
                                            height: 47,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFF3DEC02),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 29,
                                          top: 9,
                                          child: Text(
                                            '\₹${totalprice}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w300,
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
                          ],
                        ),
                      ),
                    ),




                    Container(
                        width: 100.w,
                        height: 100.h,
                        child:   StreamBuilder(
                          stream: ongoingstream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> data = snapshot.data as List<dynamic>;
                              int price=0;
                              String vendorid = "";
                              bool isDispatched = false;
                              for (var item in data) {
                                bool isItemOngoing = item['isDispatched'] as bool;
                                vendorid = item['centerid'] as String;
                                if (isItemOngoing) {
                                  isDispatched = true;
                                  price = int.parse(item['totalprice'].round().toString()); // Convert to integer
                                  print(data);
                                  break;
                                }
                              }

                              if (isDispatched) {
                                return Center(
                                  child: Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.4),
                                    ),

                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 80.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child:  Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("Confirm ", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                                                    Text("Payment", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.lightGreen)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text("\₹${price}", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final response = await supabase.from('Transactions').select().eq("ongoing", true);
                                                    print(response);
                                                    print(response[0]["id"]);
                                                    await supabase.from('Transactions').update({'ongoing': false, 'isDispatched': false}).match({'id': response[0]["id"]});

                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => Booking(widget.coordinates, widget.news)),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 25.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Icon(Icons.wallet,color: Colors.lightGreen,),
                                                        Text("Confirm",style: TextStyle(color: Colors.lightGreenAccent),),
                                                      ],
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 306,
                                                  child: Text(
                                                    "Congratulations! Your recycling transaction was successful. You've taken a positive step towards a greener future. Now, it's time to claim your well-deserved rewards. Thank you for being a part of our mission to create a more sustainable world!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w300,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } return Container(
                                child: Text(""),
                              );

                            } else {
                              return Text("error");
                            }
                          },
                        )
                    ),


                    Header4(widget.coordinates,widget.news),

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



