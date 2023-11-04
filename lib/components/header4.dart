import 'dart:typed_data';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reearth/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../screens/profile.dart';

class Header4 extends StatefulWidget{
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  Header4(this.coordinates, this.news);
  @override
  State<Header4> createState()=>_Header4();
}
class _Header4 extends State<Header4>{
  late SharedPreferences prefs;
  String? username;
  late String id;
  late  Uint8List imgfile;
  late String city="Mumbai";
  late String country="India";
  @override
  void initState() {
    super.initState();
    loadData();
    fetchdata();
  }
  Future<void> fetchdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      city = prefs.getString("city")??"Mumbai";
      country = prefs.getString("country")??"India";
    });
  }
  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("Username");
      id=prefs.getString("id")!;
      print("Header id:$id");
    });
    final String path =(await getTemporaryDirectory()).path;
    final bool check=prefs.getBool("phoneauth")??false;
    if(check==false){
      File rfile= await File("$path/user.png");
      imgfile=rfile.readAsBytesSync();
    }else{
      File rfile= await File("$path/default.png");
      imgfile=rfile.readAsBytesSync();
    }

  }
  Widget build(BuildContext context){
    return Container(
      height: 25.h,
      child: Stack(
        children: [
          Container(
            color:Colors.lightGreenAccent,
            height:10.h,
            width:100.w,
          ),
          Positioned(
            top: -30,
            left: 0,
            child: Container(
              width: 100.w,
              height: 30.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/components/semi.png"),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Container(
              width: 100.w,
              height:25.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/components/recycle.png")
                  )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:60.0,left: 35),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:5.0),
                  child: FaIcon(FontAwesomeIcons.mapPin,size: 15,),
                ),
                Text("$city $country",style: TextStyle(color:Colors.grey.shade800,fontWeight: FontWeight.w400,fontSize: 15.sp),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:80.0,left: 35),
            child: Text("Live Tracking",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w600,fontSize: 21.sp),),
          ),

          Positioned(
              top: 50,
              right: 35,
              child:  GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Profile(widget.coordinates,widget.news).animate().fadeIn(duration: 1.seconds)));
                },
                child: Container(
                  width: 82,
                  height: 79,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image:MemoryImage(imgfile),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )

          ),


        ],
      ),
    );
  }
}

