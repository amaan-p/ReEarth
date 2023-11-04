import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reearth/screens/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reearth/screens/Carosoul.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


Future<Map<String, dynamic>> fetchCoordinates() async {
    final response = await http.get(Uri.parse('https://pn15gyhuh7.execute-api.us-east-1.amazonaws.com/dev/coordinates'));
      final data = json.decode(response.body);
      return Map<String, dynamic>.from(data);

}


Future<List<dynamic>> fetchNews() async {
  final response = await http.get(Uri.parse('https://rbz0e4fz1d.execute-api.us-east-1.amazonaws.com/dev/news'));
    final data = json.decode(response.body);
    return List<dynamic>.from(data);
}


Future<Map<String, double>> getposition() async {
  //try {
    //Position _currentPosition = await Geolocator.getCurrentPosition(
      //desiredAccuracy: LocationAccuracy.low,
    //);
    return {"long": 72.837421, "lat": 19.102883};
 // } catch (e) {
   // print("Error getting position: $e");"""
  //  return {"long": 0.0, "lat": 0.0}; // Return default values or handle the error as needed

}


Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kwypawgdpzmezidelkvo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3eXBhd2dkcHptZXppZGVsa3ZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODgwMTI5MjMsImV4cCI6MjAwMzU4ODkyM30.NXeWOn88TBg4bLDQzJUfVVn85t5AVVt0JVP-jCgRY_M',
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.storage.request();
  runApp(ResponsiveSizer(
    builder: (context, orientation, screenType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
        ),
        home: SplashScreen(),
      );
    },
  ));
}

final supabase = Supabase.instance.client;

void uploadImage(String? photoUrl, String id) async {
  if (photoUrl == null) {
    return; // Return if the photo URL is null
  }

  final http.Response response = await http.get(Uri.parse(photoUrl));

  if (response.statusCode == 200 ) {
    final Uint8List imageData = response.bodyBytes;

    try {
      // Upload the image data to Supabase Storage
      final uploadResponse = await supabase.storage
          .from('avataars')
          .uploadBinary(
        'public/$id.png',
        imageData,
      );

    } catch (e) {
      // Handle the case when the resource already exists (409 error)
      print('Image upload error: ${e.toString()}');

      // Perform an update instead of insert
      final updateResponse =await supabase.storage.from('avatars').updateBinary(
        'public/$id.png',
        imageData,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );


    }
  }
}


Future<Uint8List> getNewsImage(String id) async {
  final Uint8List file = await supabase
      .storage
      .from('Newsimages')
      .download('public/$id.jpg');
  return file;
}







Future<void> downloadAndSaveImage(String id) async {
  final Uint8List file = await supabase.storage.from('avataars').download('public/$id.png');
print(file);
  final String path =(await getTemporaryDirectory()).path;
  File sourcefile = await File('${path}/user.png').create();
  print("Saved image under :  $path/user.png");
  sourcefile.writeAsBytes(file);

}

Future<void> saveDeafultimage() async {
  final Uint8List file = await supabase.storage.from('avataars').download('public/Default.png');

  print(file);
  final String path =(await getTemporaryDirectory()).path;
  File sourcefile = await File('${path}/default.png').create();
  print("Saved image under :  $path/default.png");
  sourcefile.writeAsBytes(file);

}






class SplashScreen extends StatefulWidget{
  State<SplashScreen> createState()=>_SplashScreen();

}
class _SplashScreen extends State<SplashScreen>{
  @override
  Widget build(BuildContext context){

    Timer(
        const Duration(seconds: 1),
            () async {
              final coordinates = await fetchCoordinates();
              final news = await fetchNews();
              await saveDeafultimage();
              Position? _currentPosition = await Geolocator.getLastKnownPosition(
                forceAndroidLocationManager: true
              );
              SharedPreferences prefs = await SharedPreferences.getInstance();
              bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
              prefs.setDouble("long", _currentPosition!.longitude);
              prefs.setDouble("lat", _currentPosition!.latitude);
              print(" lattitude:${_currentPosition!.latitude}");

              if(isLoggedIn){
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>Home(coordinates,news).animate().fadeIn(duration: 2.seconds))
                );
              }else{
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) =>CarosoulScreen(coordinates,news).animate().fadeIn(duration: 2.seconds))
              );
              }
        });

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body:Column(
          children: [
            Container(
              width:100.w,
              height: 100.h,
              /////Background///////////
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:  ExactAssetImage('assets/backgrounds/trashbag.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child:  BackdropFilter(
                filter:  ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child:  Container(
                  decoration:  BoxDecoration(color: Colors.black.withOpacity(0.8)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        width: 100.w,
                        height: 50.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:  ExactAssetImage('assets/components/logo.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top:50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Re",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30.sp),),
                            Text("Earth",style: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold,fontSize: 30.sp),)
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: Center(
                          child:Text("There is no Planet B",style: TextStyle(color: Colors.white,fontSize: 16.sp),),

                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),])


            //////////////text/////////////
    );
  }
}

