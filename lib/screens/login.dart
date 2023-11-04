
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reearth/screens/OTP.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'Home.dart';





class Login extends StatefulWidget{
  late String verificationid;
  Map<String, dynamic> coordinates;
  List<dynamic> news;
  Login(this.coordinates,this.news);
  @override
  State<Login> createState()=>_Login();
}

class _Login extends State<Login>{
  Future<void> FetchDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id=prefs.getString("id");
    final data = await supabase
        .from('Users')
        .select('''
     name,phonenumber,email,
    address,city,country
  ''').eq('id',id);
    prefs.setString("Username", data[0]["name"]??"Anon User");
    prefs.setInt("phonenumber", data[0]["phonenumber"]??0 );
    prefs.setString("email", data[0]["email"]??"" );
    prefs.setString("address",  data[0]["address"] ??"");
    prefs.setString("city",  data[0]["city"] ??"");
    prefs.setString("country",  data[0]["country"]??"" );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    var phno=TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: 100.h,
          width: 100.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/trash.png"),
                fit: BoxFit.fill
          ),
        ),
        child: Center(
            child:Container(
              width: 90.w,
              height: 65.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.grey.shade800.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Welcome !",style: TextStyle(fontSize: 23.sp,fontFamily: 'Inter',color: Colors.white,fontWeight:FontWeight.w600 ),),
                        Text("Please Sign in to your account",style: TextStyle(fontSize: 16.sp,fontFamily: 'Inter',color: Colors.white,fontWeight:FontWeight.w300 ),),

                        Padding(
                          padding: const EdgeInsets.only(left:20.0,right: 20,top: 10),
                          child: TextField(
                            controller: phno,
                      keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(10),
                            ],
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter Phone Number',
                          labelStyle: TextStyle(color:Colors.grey.shade500,fontWeight: FontWeight.w400),
                          filled: true,
                        isDense: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color:Color.fromARGB(255,139,195,74),
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color:Color.fromARGB(255,139,195,74),
                              width: 1,
                            ),
                          ),
                      ),
                      style: TextStyle(color:Colors.grey.shade500),
                    ),
                        ),

                        Center(
                          child: SizedBox(
                            width: 50.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255,139,195,74), // Set the background color
                              ),
                                onPressed:() async {
                                  String phoneNumber = phno.text;

                                  if (validator.phone(phoneNumber) && phoneNumber.length == 10) {

                                  FirebaseAuth auth = FirebaseAuth.instance;
                                    await auth.verifyPhoneNumber(
                                      phoneNumber: "+91${phno.text}",
                                      verificationCompleted: (
                                          PhoneAuthCredential credential) async {
                                        await auth.signInWithCredential(
                                            credential);
                                      },
                                      verificationFailed: (FirebaseAuthException e) {
                                        if (e.code == 'invalid-phone-number') {
                                          Fluttertoast.showToast(
                                            msg: "Invalid Phone Number",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                          print('The provided phone number is not valid.');
                                        }
                                      },
                                      codeSent: (String verificationId,
                                          int? resendToken) async {
                                        String? existingUserId;
                                        String? newUserId;
                                        var phoneNumber = int.parse(phno.text);
                                        final data =await supabase
                                            .from('Users')
                                            .select('id')
                                            .eq('phonenumber', phoneNumber);
                                        print(data);
                                        if (data != null) {
                                          if (data.isNotEmpty) {
                                            // User with the same phone number already exists
                                            existingUserId = data[0]['id'];
                                            print('User with the same phone number already exists. ID: $existingUserId');
                                          }
                                        }
                                          if( existingUserId ==null) {
                                            // User with the phone number doesn't exist, insert a new record
                                            var uuid = Uuid();
                                            newUserId = uuid.v4();

                                            await supabase.from('Users').insert(
                                                [
                                                  {
                                                    'id': newUserId,
                                                    'created_at': DateTime.now()
                                                        .toString(),
                                                    'phonenumber': phoneNumber,
                                                    'city':'Mumbai',
                                                    'country':'India'
                                                  },
                                                ]);
                                          }
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        String? userIdToSave = existingUserId ?? newUserId;
                                        prefs.setString('id', userIdToSave!);
                                        prefs.setBool('phoneauth', true);
                                        widget.verificationid = verificationId;
                                        print(verificationId);
                                        await FetchDetails();

                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(
                                            builder: (context) =>
                                                OTP(widget.verificationid,widget.coordinates,widget.news)
                                        ));
                                      },
                                      codeAutoRetrievalTimeout: (
                                          String verificationId) {},
                                    );
                                  }else {
                                    // Invalid phone number, show toast
                                    Fluttertoast.showToast(
                                      msg: "Invalid Phone Number",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                  }
                                ,
                              child: Text('Sign In',style: TextStyle(color:Colors.black,fontSize: 17.sp ),),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left:28.0,right: 28),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width:20.w,
                                height: 2,
                                decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Container(
                                width:20.w,
                                height: 2,
                                decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                              )

                            ],
                          ),
                        ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: Center(
                      child: SizedBox(
                      width: 50.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // Set the background color
                        ),
                        onPressed: () async{
                          final FirebaseAuth _auth = FirebaseAuth.instance;
                          final GoogleSignIn _googleSignIn = GoogleSignIn();
                          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
                            if (googleUser != null) {
                              final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                              // Create a new credential using the Google sign-in authentication
                              final OAuthCredential credential = GoogleAuthProvider.credential(
                                accessToken: googleAuth.accessToken,
                                idToken: googleAuth.idToken,
                              );
                              final UserCredential userCredential = await _auth.signInWithCredential(credential);
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('isLoggedIn', true);
                              final User? user = userCredential.user;
                              String? id;

                              final data = await supabase
                                  .from('Users')
                                  .select('id')
                                  .eq('email', user?.email)
                                  ;
                              print(data);

                              if (data != null && data.isNotEmpty) {
                                // User with the same email already exists
                                var existingUserId = data[0]['id'];
                                print('User with the same email already exists. ID: $existingUserId');
                                id = existingUserId;
                              }

                              if (id == null) {
                                // User with the email doesn't exist, insert a new record
                                var uuid = Uuid();
                                id = uuid.v4();

                                await supabase.from('Users').insert([
                                  {
                                    'id': id,
                                    'created_at': DateTime.now().toString(),
                                    'email': user?.email,
                                    'name': user?.displayName,
                                    'phonenumber': user?.phoneNumber,
                                    'city':'Mumbai',
                                    'country':'India'
                                  },
                                ]);
                              }

                              if (id != null) {
                                prefs.setString('id', id);
                              }

                              final namedata = await supabase
                                  .from('Users')
                                  .select('name').eq('email', user?.email);
                              prefs.setString("Username", namedata[0]["name"]);
                              uploadImage(user?.photoURL, id!);
                              prefs.setBool("phoneauth", false);
                              print('User signed in with Google: ${user?.displayName}');
                              var userid=prefs.getString("id");
                              await FetchDetails();
                              print(userid);
                              await downloadAndSaveImage(userid!);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Home(widget.coordinates,widget.news).animate().fadeIn()));

                            }


                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           FaIcon(FontAwesomeIcons.google,color: Colors.black,size: 18,), // Replace with the appropriate Google icon
                            SizedBox(width: 6), // Adjust the spacing as needed
                            Text(
                              'Sign In with Google',
                              style: TextStyle(color: Colors.black, fontSize: 15.sp),
                            ),
                          ],
                        ),
                      ),
                  ),),
                    )

                    ],
                    ),
                  ),
                ),
              ),
            ),
        )
        ,
      ),
    );
  }
}