import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

class OTP extends StatefulWidget{
  final String verificationid;
  Map<String, dynamic> coordinates;
  List<dynamic> news;
  OTP(this.verificationid,this.coordinates,this.news);
  @override
  State<OTP> createState()=>_OTP();
}

class _OTP extends State<OTP>{
  @override
  Widget build(BuildContext context){
    var otp_controller=TextEditingController();
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Text("Enter the 6 Digit Code",style: TextStyle(fontSize: 23.sp,fontFamily: 'Inter',color: Colors.white,fontWeight:FontWeight.w600 ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 38.0),
                        child: Text("A Message has been sent to your device",style: TextStyle(fontSize: 16.sp,fontFamily: 'Inter',color: Colors.white,fontWeight:FontWeight.w300 ),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:40.0,right: 40,top:10,bottom:20),
                        child:PinCodeTextField(
                          controller: otp_controller,
                          length: 6,
                          obscureText: false,
                          textStyle: TextStyle(color:Colors.white),
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Color.fromARGB(255,139,195,74),
                            inactiveFillColor: Colors.black,
                            inactiveColor: Colors.grey.shade500,
                            activeColor: Color.fromARGB(255,139,195,74),
                            selectedColor: Color.fromARGB(255,139,195,74),
                            selectedFillColor: Colors.black,


                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          keyboardType: TextInputType.number,

                          onCompleted: (v) {
                            debugPrint("Completed");
                          },
                          onChanged: (value) {
                          },
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 70.0),
                        child: Center(
                          child: SizedBox(
                            width: 50.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255,139,195,74), // Set the background color
                              ),
                                onPressed:() async{
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  print(widget.verificationid);
                                  PhoneAuthCredential credential =PhoneAuthProvider.credential(verificationId: widget.verificationid, smsCode: otp_controller.text);
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setBool('isLoggedIn', true);
                                    Navigator.pushReplacement(context, MaterialPageRoute(   builder: (context) => Home(widget.coordinates,widget.news)
                                    ));
                                  }
                                ,
                              child: Text('Sign In',style: TextStyle(color:Colors.black,fontSize: 17.sp ),),
                            ),
                          ),
                        ),
                      ),


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