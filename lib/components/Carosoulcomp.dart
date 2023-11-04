import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CarouselItems extends StatelessWidget{
  CarouselItems(this.filename,this.title1,this.title2,this.desc);
  String filename;
  String title1;
  String title2;
  String desc;
  @override
  Widget build(BuildContext context){
    return  Container(
      width:100.w,
      height: 100.h,
      /////Background///////////
      decoration: BoxDecoration(
        image: DecorationImage(
          image:  ExactAssetImage('assets/backgrounds/$filename'),
          fit: BoxFit.cover,
        ),
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              width: 190,
              height: 43,
              child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 190,
                            height: 43,
                            decoration: const BoxDecoration(
                              borderRadius : BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color : Color.fromARGB(255,139,195,74),
                            )
                        )
                    ), Center(
                      child: Text(title1, textAlign: TextAlign.center, style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Inter',
                              fontSize: 21,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1
                          ),),
                    )
                  ]
              )
          ),


          Padding(
            padding: const EdgeInsets.only(top:28.0),
            child: Text(title2,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:21.sp),),
          ),


          Padding(
            padding: const EdgeInsets.only(bottom: 100.0,left: 20,right: 20,top:20),
            child: Text(desc,style: TextStyle(color: Colors.white,fontSize:15.sp),textAlign: TextAlign.center,),
          )
        ],
      )
    );
  }
}