import 'dart:ffi';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reearth/components/HomeMenu.dart';
import 'package:reearth/components/NavigationMenu.dart';
import 'package:reearth/components/bottomNav.dart';
import 'package:reearth/components/header.dart';
import 'package:reearth/components/header5.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:io';
import '../main.dart';
import 'addinfo.dart';


class Community extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  Community(this.coordinates,this.news);

  @override
  _Community createState() => _Community();
}

class _Community extends State<Community> {
  int _selectedIndex = 2;

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





class CommunityScreen extends StatefulWidget{
  Map<String, dynamic> coordinates;
  List< dynamic> news;
  CommunityScreen(this.coordinates,this.news);
  State<CommunityScreen> createState()=>_CommunityScreen();
}

class _CommunityScreen extends State<CommunityScreen>{
  TextEditingController _searchController = TextEditingController();
  // Controllers for the input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phnoController = TextEditingController();
  late List<dynamic> data;
  List<dynamic> filteredData = [];
   late File pickedImage;
  Future<void>getandupload(File adfile,String title,String desc,String phno,String price)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
print(price);
    await supabase.from('Listings').insert([
      {
        'title': title,
        'desc': desc,
        'author': prefs.getString("id"),
        'authorcontact': phno,
        'price': int.parse(price),
      },
    ]);


      final String path = await supabase.storage.from('avataars').upload(
        'public/$title.png',
        adfile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );





  }

  void _filterList(String query) {
    setState(() {
      filteredData = data
          .where((item) =>
      item['title'].toLowerCase().contains(query.toLowerCase()) ||
          item['desc'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    setupRealtimeListener();
  }

  void setupRealtimeListener() {
    supabase.from('Listings')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> newData) {
      setState(() {
        data = newData;
        data.sort((a, b) => b['created_at'].compareTo(a['created_at'])); // Sort by timestamp, newest first
        _filterList(_searchController.text); // Apply filtering
      });
    });
  }
  final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
  final RegExp titleRegex = RegExp(r'^.{1,30}$');
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBody: true,
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
                    Header5(widget.coordinates,widget.news),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height:150),
//////////////////////////////SeachBar///////////////////////////////////////////////////
                        Positioned(
                          bottom: 6,
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  _filterList(value);
                                },
                                decoration: InputDecoration(
                                  hintText: "Try searching for ...",
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide.none
                                  ),
                                  filled: true,
                                  fillColor:Colors.grey.withOpacity(0.4),
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      // Handle search action
                                      print(_searchController.text);


                                    },
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () async {

                                      showDialog(
                                        context: context,
                                         builder: (BuildContext context) {
                                        return Theme(
                                            data: ThemeData(
                                              // Set the background color of the AlertDialog
                                              backgroundColor: Colors.white,
                                            ),
                                            child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                              title:  Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("Create ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),Text("Listing ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.lightGreen),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              content: Container(
                                                height: 300,
                                                width: 300,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    TextFormField(

                                                      controller: titleController,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                      ),
                                                      decoration: InputDecoration(
                                                          prefixIcon: IconButton(
                                                            icon: Icon(Icons.book,color: Colors.black,),
                                                            onPressed: () {
                                                              // Handle search action
                                                              print(_searchController.text);


                                                            },
                                                          ),
                                                          isDense: true,
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(25.0),
                                                            borderSide: BorderSide(
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(25.0),
                                                            borderSide: BorderSide(
                                                              color:  Colors.black,
                                                            ),
                                                          ),
                                                          hintText: "Enter Title",
                                                          hintStyle: TextStyle(color: Colors.grey.shade800)
                                                      ),
                                                    ),
                                                                                                        Padding(


                                                      padding: const EdgeInsets.only(top:18.0),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        controller: descController,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                        ),
                                                        decoration: InputDecoration(
                                                            prefixIcon: IconButton(
                                                              icon: Icon(Icons.storage,color: Colors.black),
                                                              onPressed: () {
                                                                // Handle search action
                                                                print(_searchController.text);


                                                              },
                                                            ),
                                                            isDense: true,
                                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(25.0),
                                                              borderSide: BorderSide(
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(25.0),
                                                              borderSide: BorderSide(
                                                                color:  Colors.black,
                                                              ),
                                                            ),
                                                            hintText: "Enter Description",
                                                            hintStyle: TextStyle(color: Colors.grey.shade800)
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top:18.0),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        controller: phnoController,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                        ),
                                                        decoration: InputDecoration(
                                                            prefixIcon: IconButton(
                                                              icon: Icon(Icons.phone,color: Colors.black),
                                                              onPressed: () {
                                                                // Handle search action
                                                                print(_searchController.text);


                                                              },
                                                            ),
                                                            isDense: true,
                                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(25.0),
                                                              borderSide: BorderSide(
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(25.0),
                                                              borderSide: BorderSide(
                                                                color:  Colors.black,
                                                              ),
                                                            ),
                                                            hintText: "Enter Phone Number",
                                                            hintStyle: TextStyle(color: Colors.grey.shade800)
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top:18.0),
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        controller:priceController,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                        ),
                                                        decoration: InputDecoration(
                                                            prefixIcon: IconButton(
                                                              icon: Icon(Icons.wallet,color: Colors.black),
                                                              onPressed: () {
                                                                // Handle search action
                                                                print(_searchController.text);


                                                              },
                                                            ),
                                                            isDense: true,
                                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(25.0),
                                                              borderSide: BorderSide(
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(25.0),
                                                              borderSide: BorderSide(
                                                                color:  Colors.black,
                                                              ),
                                                            ),
                                                            hintText: "Enter Price",
                                                            hintStyle: TextStyle(color: Colors.grey.shade800)
                                                        ),
                                                      ),
                                                    ),
                                                  ElevatedButton(onPressed: () async {
                                                  if (titleController.text.isEmpty || !titleRegex.hasMatch(titleController.text)) {
                                                    showToast("Title should be between 1 and 30 characters");
                                                   } else if (phnoController.text.isEmpty || !phoneRegex.hasMatch(phnoController.text)) {
                                                      showToast("Invalid phone number. Please enter 10 digits.");
                                                         } else if (descController.text.isEmpty) {
                                                      showToast("Description cannot be empty");
                                                        } else if (priceController.text.isEmpty) {
                                                    showToast("Price cannot be empty");
                                                            } else {
                                                    final ImagePicker _picker = ImagePicker();

                                                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                                                    if (image != null) {
                                                       pickedImage = File(image.path);
                                                    }
                                                    await getandupload(pickedImage, titleController.text, descController.text, phnoController.text, priceController.text);

                                                    print("${titleController.text}");
                                                    titleController.text="";
                                                    descController.text="";
                                                    priceController.text="";
                                                    phnoController.text="";

                                                    Navigator.of(context).pop(true);
                                                  }}, child: Text("Choose Image and Submit"))


                                              ],
                                                ),
                                              ),

                                            ));
                                      },
                                      );


                                    },
                                  ),
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
////////////////////////////////////////////////////////////////////////////////////////////
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: ListView.builder(
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomListCard(
                                        widget.coordinates,
                                          widget.news,
                                          filteredData[index]['title'],
                                          filteredData[index]['desc'],
                                          filteredData[index]['authorcontact'],
                                          filteredData[index]['price'],
                                        ),
                                      ),

                                );
                              },
                            ),
                          ),
                        ),
                      ],
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


class CustomListCard extends StatefulWidget{
  Map<String, dynamic> coordinates;
  List< dynamic> news;
  final String title;
  final String  desc;final String phno;
  final int price;


  CustomListCard(this.coordinates,this.news,this.title,this.desc,this.phno,this.price);
  @override
  _CustomListCard createState() => _CustomListCard();
}

class _CustomListCard extends State<CustomListCard>{



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context)=>Info(widget.coordinates,widget.news,widget.title,widget.desc,widget.phno,widget.price)));

      },
      child: Container(
        width: 349,
        height: 236,

        decoration:  ShapeDecoration(
          image:DecorationImage(
            image: CachedNetworkImageProvider(
            "https://kwypawgdpzmezidelkvo.supabase.co/storage/v1/object/public/avataars/public/${widget.title}.png",
              cacheManager: DefaultCacheManager()
            ),
            fit: BoxFit.cover,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 350,
                height: 236,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.02, 1.40),
                    end: Alignment(0.02, -1),
                    colors: [Colors.black87, Colors.black.withOpacity(0)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 184,
              child: SizedBox(
                width: 335,
                child: Text(
                  widget.desc,
                  style: TextStyle(
                    color: Color(0xFF9D9D9D),
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 145,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 259,
              top: 145,
              child: Container(
                width: 53,
                height: 27,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 53,
                        height: 27,
                        decoration: ShapeDecoration(
                          color: Color(0xFF3DEC02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 7,
                      child: Text(
                        '₹ ${widget.price.toString()}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
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
          ],
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




