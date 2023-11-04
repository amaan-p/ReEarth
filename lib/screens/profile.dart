import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reearth/components/customcard.dart';
import 'package:reearth/components/header%20%203.dart';
import 'package:reearth/screens/Booking.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../components/bottomNav.dart';
import '../components/header.dart';
import '../main.dart';
import 'Carosoul.dart';
import 'Home.dart';
import 'package:flutter/material.dart';

import 'community.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  Profile(this.coordinates, this.news);
  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  int _selectedIndex = 0;


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
    }   if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Community(widget.coordinates, widget.news).animate().fadeIn(duration: 500.milliseconds)),
      );
    }
  }
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  // Controllers for the input fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phnoController = TextEditingController();
  late List<dynamic> data=[];
  List<dynamic> filteredData = [];

  Future<void> DeleteListing(String title) async {

    await supabase
        .from('Listings')
        .delete()
        .eq("title", title);
    setupRealtimeListener();
  }


  Future<void> UpdateListing(String title,String desc,String phno,String price) async {
    final data = await supabase
        .from('Listings')
        .select().eq("title", title);
    final itemid=data[0]["id"];
    var pickedImage=await supabase
        .storage
        .from('avataars')
        .download('public/$title.png');
    print(pickedImage);
    final String tpath =(await getTemporaryDirectory()).path;
    File imageFile =await File('${tpath}/${title}.png').create();
    await imageFile.writeAsBytes(pickedImage);
    titleController.text=title;descController.text=desc;phnoController.text=phno;priceController.text=price;
    String oldtitle=title;
    await DefaultCacheManager().emptyCache();

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
                      Text("Update ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),Text("Listing ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.lightGreen),),
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
                          hintText: titleController.text,
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
                            hintText: descController.text,
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
                            hintText: phnoController.text,
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
                            hintText: priceController.text,
                            hintStyle: TextStyle(color: Colors.grey.shade800)
                        ),
                      ),
                    ),
                    ElevatedButton(onPressed: () async {
                      final ImagePicker _picker = ImagePicker();

                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);



                        if (image != null) {
                          pickedImage = await image.readAsBytes();
                          print("new:${pickedImage}");
                        };

                    }, child: Text("Choose Image"))


                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    titleController.text="";
                    descController.text="";
                    priceController.text="";
                    phnoController.text="";
                    Navigator.of(context).pop(false); // Return false to indicate cancellation
                  },
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () async{

                    await supabase
                        .from('Listings')
                        .upsert({ 'id': itemid,
                      'title': titleController.text,
                      'desc': descController.text,
                      'authorcontact': phnoController.text,
                      'price': int.parse(priceController.text)});

                  if(oldtitle==titleController.text){
                    await supabase.storage.from('avataars').updateBinary(
                      'public/${titleController.text}.png',
                      pickedImage,
                    );
                    print("update Sucessful");
                  }else{
                    await supabase.storage.from('avataars').uploadBinary(
                      'public/${titleController.text}.png',
                      pickedImage,
                    );
                  }
                    print("update Sucessful");
                    Navigator.of(context).pop(true); // Return true to indicate confirmation
                  },
                ),
              ],
            ));
      },
    );
    setupRealtimeListener();
  }

  Future<void> setupRealtimeListener() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    supabase.from('Listings')
        .stream(primaryKey: ['id']).eq("author", prefs.getString("id"))
        .listen((List<Map<String, dynamic>> newData) {
      setState(() {
        data = newData;
        data.sort((a, b) => b['created_at'].compareTo(a['created_at'])); // Sort by timestamp, newest first
        print(data);
      });
    });
  }
  @override
  void initState() {
    super.initState();
    fetchdata();
    setupRealtimeListener();
  }

Future<void> updateData(String field,String data) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id=prefs.getString("id");

  if(field=="phonenumber"){
    var numdata=int.parse(data);
    await supabase
        .from('Users')
        .update({ field: numdata })
        .match({ 'id': id });
    prefs.setInt(field, numdata);
  }else{
    await supabase
        .from('Users')
        .update({ field: data })
        .match({ 'id': id });
    prefs.setString(field, data);

  }
}
//all in one fetching
  Future<void> fetchdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? phoneNumber = prefs.getInt("phonenumber");
    String? email = prefs.getString("email");
    String? address = prefs.getString("address");
    String? country = prefs.getString("country");
    String? city = prefs.getString("city");

    setState(() {
      if(phoneNumber.toString()=="0"){
        _phoneController.text = "Enter Phone Number";
      }else{
        _phoneController.text =  phoneNumber.toString();

      }
      _emailController.text = email ?? "Enter Email";
      _addressController.text = address ?? "Enter address";
      _cityController.text = city ?? "Enter city";
      _countryController.text = country ?? "Enter country";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Header3(widget.coordinates,widget.news),


                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 28.0),
                                  child: Text("Active Listings",
                                    style: TextStyle(fontSize: 20.sp,color: Colors.black,fontWeight: FontWeight.w700)
                                    ,),
                                ),
                              ],
                            ),
                            Container(
                              width:95.w,
                              height: 24.h,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomListCard2(
                                          widget.coordinates,
                                          widget.news,
                                          data[index]['title'],
                                          data[index]['desc'],
                                          data[index]['authorcontact'],
                                          data[index]['price'],
                                              () {
                                            DeleteListing(data[index]['title']);
                                          },   () {
                                            UpdateListing(data[index]['title'], data[index]['desc'],data[index]['authorcontact'],  data[index]['price'].toString());
                                          },
                                        ),
                                      ),

                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:38.0),
                                  child: Text("Information",
                                    style: TextStyle(fontSize: 20.sp,color: Colors.black,fontWeight: FontWeight.w700)
                                    ,),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:38.0,top:20),
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.phone,size: 17,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0),
                                    child: Text("Phone Number:",
                                      style: TextStyle(fontSize: 17.sp,color: Colors.black,fontWeight: FontWeight.w500)
                                      ,),
                                  ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        width: 40.w,
                                        height: 45,
                                        child: TextField(
                                          onSubmitted: (value) async{
                                            await updateData("phonenumber", _phoneController.text);
                                          },
                                          controller: _phoneController,
                                          decoration: InputDecoration(
                                            hintText:  _phoneController.text,
                                            hintStyle: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  width: 70.w,
                                  height: 1,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:38.0),
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.envelope,size: 17,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0),
                                    child: Text("Email:",
                                      style: TextStyle(fontSize: 17.sp,color: Colors.black,fontWeight: FontWeight.w500)
                                      ,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Container(
                                      width: 60.w,
                                      height: 52,
                                      child: TextField(
                                        onSubmitted: (value) async{
                                         await updateData("email", _emailController.text);
                                        },
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          hintText:  _emailController.text==""?"Enter Email":_emailController.text,
                                          hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize:16.sp),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  width: 70.w,
                                  height: 1,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:38.0),
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.house,size: 17,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0),
                                    child: Text("Address:",
                                      style: TextStyle(fontSize: 17.sp,color: Colors.black,fontWeight: FontWeight.w500)
                                      ,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Container(
                                      width: 60.w,
                                      height: 52,
                                      child: TextField(
                                        onSubmitted: (value) async{
                                          await updateData("address", _addressController.text);
                                        },
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          hintText:  _addressController.text==""?"Enter Address":_addressController.text,
                                          hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize:16.sp),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  width: 70.w,
                                  height: 1,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:38.0),
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.city,size: 17,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0),
                                    child: Text("City:",
                                      style: TextStyle(fontSize: 17.sp,color: Colors.black,fontWeight: FontWeight.w500)
                                      ,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Container(
                                      width: 60.w,
                                      height: 52,
                                      child: TextField(
                                        onSubmitted: (value) async{
                                          await updateData("city", _cityController.text);
                                        },
                                        controller: _cityController,
                                        decoration: InputDecoration(
                                          hintText:  _cityController.text==""?"Enter City":_cityController.text,
                                          hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize:16.sp),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  width: 70.w,
                                  height: 1,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:38.0),
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.globe,size: 17,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:12.0),
                                    child: Text("Country:",
                                      style: TextStyle(fontSize: 17.sp,color: Colors.black,fontWeight: FontWeight.w500)
                                      ,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Container(
                                      width: 60.w,
                                      height: 52,
                                      child: TextField(
                                        onSubmitted: (value) async{
                                          await updateData("country", _countryController.text);
                                        },
                                        controller: _countryController,
                                        decoration: InputDecoration(
                                          hintText:  _countryController.text==""?"Enter Country":_countryController.text,
                                          hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize:16.sp),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(onPressed: ()async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setBool('isLoggedIn', false);
                                prefs.setString('id', "");
                                prefs.setBool("phoneauth", false);
                                // Sign out from Google
                                GoogleSignIn googleSignIn = GoogleSignIn();
                                await googleSignIn.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => CarosoulScreen(widget.coordinates,widget.news)),
                                );
                              }, child:Text("Logout",style: TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black
                              ),),
                            ),
                          ],
                        ),
                      ),
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






/*
*
*  Center(
          child: Padding(
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
                MaterialPageRoute(builder: (context) => SplashScreen()),
              );
            }, child:Text("Logout")),
          ),
        ),
*
* */
class CustomListCard2 extends StatefulWidget{
  Map<String, dynamic> coordinates;
  List< dynamic> news;
  final String title;
  final String  desc;final String phno;
  final int price;
  final Function() deleteListing; final Function() updateListing;


  CustomListCard2(this.coordinates,this.news,this.title,this.desc,this.phno,this.price,this.deleteListing,this.updateListing);
  @override
  _CustomListCard2 createState() => _CustomListCard2();
}

class _CustomListCard2 extends State<CustomListCard2>{



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context){
   return Container(
     width: 92.w,
     height: 22.h,
     decoration: BoxDecoration(
       color: Colors.lightGreenAccent,
       borderRadius: BorderRadius.circular(20)
     ),
     child: Row(
       children: [

      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 45.w,
          height: 19.h,
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            image:DecorationImage(
              image: CachedNetworkImageProvider(
                  "https://kwypawgdpzmezidelkvo.supabase.co/storage/v1/object/public/avataars/public/${widget.title}.png",
                  cacheManager: DefaultCacheManager()
              ),
              fit: BoxFit.cover,
            ),
        ),
      )
      ),

         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(top:18.0,left: 10),
               child: Center(
                 child: SizedBox(
                   width: 145,
                   child: Text(
                     "${widget.title}",
                     style: TextStyle(
                       color: Colors.black,
                       fontSize: 18,
                       fontFamily: 'Inter',
                       fontWeight: FontWeight.w600,
                       height: 0,
                     ),
                   ),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: SizedBox(
                 width: 140,
                 height: 80,
                 child: Text(
                   widget.desc,
                   style: TextStyle(
                     color: Colors.grey.shade800,
                     fontSize: 11,
                     fontFamily: 'Inter',
                     fontWeight: FontWeight.w400,
                     height: 0,
                   ),
                 ),
               ),
             ),
             Row(
               children: [
                 IconButton(onPressed: (){

                   widget.updateListing();
                 }, icon: Icon(Icons.edit,color: Colors.black)),
                 Padding(
                   padding: const EdgeInsets.only(left:28.0),
                   child: IconButton(onPressed: (){
                    widget.deleteListing();
                   }, icon: Icon(Icons.delete_forever,color: Colors.black)),
                 ),
               ],
             )
           ],
         )

       ],
     ),
   );
  }
}