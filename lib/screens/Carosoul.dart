import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reearth/components/Carosoulcomp.dart';
import 'package:reearth/screens/login.dart';

CarouselController controller = CarouselController();

class CarosoulScreen extends StatefulWidget{
  Map<String, dynamic> coordinates;
  List< dynamic> news;
  CarosoulScreen(this.coordinates,this.news);

@override
State<CarosoulScreen> createState()=>_CarosoulScreen();
}

class _CarosoulScreen extends State<CarosoulScreen>{
  int _currentIndex = 0;

  final List<Widget> _items = [
    CarouselItems("greenfuture.png", "Recycle Right", "Create a Greener Future", "Learn how to sort and identify recyclables with ease, ensuring they are properly disposed of.\n Join the movement for a greener planet – together, we can make a difference!").animate().fadeIn(duration:1.seconds),
    CarouselItems("movement.png", "Be The Change ", "Join the Movement", "Be the Change and make a positive impact.\n Learn how to do recycling effectively, ensuring they are diverted from landfills. Together, let's create a sustainable future for generations to come.").animate().fadeIn(duration: 1.seconds),
    CarouselItems("handshake.png", "Earn Rewards", "Recycle, Redeem, Rewards", "Start recycling with our app today and earn valuable rewards for your eco-conscious efforts.\n Discover the joy of turning trash into treasure as you sell your recyclables and contribute to a greener world").animate().fadeIn(duration: 1.seconds),
  ];
  @override
  Widget build(BuildContext context){
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(

        children: [
          /*Carosuel*/
          Expanded(
            child: CarouselSlider(
              carouselController: controller,
              options:  CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                enableInfiniteScroll: false,
                autoPlay: false,
                viewportFraction: 1.0,
                aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
                initialPage: 0,
              ), items: _items.map((items){
              return items;
            }).toList(),
            ),
          ),
          if (_currentIndex != _items.length - 1) // Hide the indicators on the last slide
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _items.map((item) {
                      int index = _items.indexOf(item);
                      return Container(
                        width: 9.0,
                        height: 9.0,
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _currentIndex == index
                                ? const Color.fromARGB(255,139,195,74)
                                : Colors.white,
                            width: 2.0,
                          ),
                          color: _currentIndex == index
                              ? const Color.fromARGB(255,139,195,74)
                              : Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          if (_currentIndex == _items.length - 1) // Show the "Sign In" button on the last slide
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255,139,195,74), // Set the background color
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Login(widget.coordinates,widget.news).animate().fadeIn()));
                      },
                      child: Text('Sign In',style: TextStyle(color:Colors.black ),),
                    ),
                  ),
                ),
              ],
            ),


        ],
      ),
    );
  }
}


