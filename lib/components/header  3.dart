import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reearth/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../screens/profile.dart';

class Header3 extends StatefulWidget{
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  Header3(this.coordinates, this.news);
  @override
  State<Header3> createState()=>_Header3();
}
class _Header3 extends State<Header3>{
  late SharedPreferences prefs;
  String? username;
  late String id;
    late Uint8List imgfile;
 late String city="Mumbai";
 late String country="India";
  TextEditingController _nameController = TextEditingController();
  Future<void> updateName(String field,String data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id=prefs.getString("id");

      await supabase
          .from('Users')
          .update({ field: data })
          .match({ 'id': id });
    prefs.setString("Username", data);
  }

  @override
  void initState() {
    super.initState();
    loadData();
    fetchdata();
  }
  Future<void> fetchdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("Username");

    setState(() {
      _nameController.text = name ?? "Anon User";
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
      height: 40.h,
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
            child: Text("Profile",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w600,fontSize: 21.sp),),
          ),

          Positioned(
              top: 150,
              right: 140,
              child:  Container(
                width: 102,
                height: 99,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image:MemoryImage(imgfile) ,
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              )

          ),

          Padding(
            padding: const EdgeInsets.only(top:240.0,left: 130),
            child:  TextField(
              onSubmitted: (value) async{
                await updateName("name", _nameController.text);
              },
              controller: _nameController,
              style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 20.sp),
              decoration: InputDecoration(
                hintText:  _nameController.text==""?"Anon User":_nameController.text,
                hintStyle: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 20.sp),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:295.0,left: 130),
            child: Text("Joined November 2023",style: TextStyle(color:Colors.grey.shade700,fontWeight: FontWeight.w400,fontSize: 15.sp),),
          ),

        ],
      ),
    );
  }
}

