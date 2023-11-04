import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reearth/components/customcard.dart';
import 'package:reearth/components/header6.dart';
import 'package:reearth/screens/Booking.dart';
import 'package:reearth/screens/community.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/bottomNav.dart';
import '../components/header.dart';
import '../components/indicator.dart';
import '../main.dart';
import 'Home.dart';
import 'package:flutter/material.dart';

class Insights extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  Insights(this.coordinates, this.news);
  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
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
    }if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Community(widget.coordinates, widget.news).animate().fadeIn(duration: 500.milliseconds)),
      );
    }
  }
  late int metals=0; // Example value for metals (replace with actual values)
  late int plastics=0 ; // Example value for plastics (replace with actual values)
  late int ewaste=0 ; // Example value for e-waste (replace with actual values)
  late int paper=0;
  late int Totalprice=0;
  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDateTime = ' ${_formatTime(dateTime)} (${_formatDate(dateTime)})';
    return formattedDateTime;
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
  }
  ///////////////////////logic//////////////////////
  Future<List<Widget>> getCenterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    final data = await supabase
        .from('Transactions')
        .select()
        .eq("userid", id) .order('created_at', ascending: false);

    if (data != null) {
      List<Widget> centerCards = [];
      for (var transaction in data) {
        String centerId = transaction['centerid'];
        final centerData = await supabase
            .from('Vendors')
            .select()
            .eq("id", centerId)
        ;

        if (centerData != null) {
          String centerName = centerData[0]['name'];
          String centerAddress =  centerData[0]['address'];
          String centerCity =  centerData[0]['city'];
          String centerCountry = centerData[0]['country'];

          // Create a card widget for the center
          Widget centerCard = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(20)
              ),
              height: 20.h,
              width: 70.w,
              child:Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      centerName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ) ,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${centerAddress} ,${centerCity} ,${centerCountry}  ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                  )
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Price of Transaction: ₹ ${transaction["totalprice"]}  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'Timing Details: ${_formatDateTime(transaction["created_at"])}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    ),
                  )
                ],
              ),
              // You can add more properties like images or buttons as needed.
            ),
          );

          // Add the center card to the list
          centerCards.add(centerCard);
        }
      }

      // Now you have a list of center cards that you can use in your ListView
      return centerCards;
    }

    // If there is no data, return an empty list
    return [];
  }



  Future<void> gettotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    final data = await supabase
        .from('Transactions')
        .select('totalprice')
        .eq("userid", id);

    int totalSum = 0;

    if (data != null) {
      for (var transaction in data) {
        totalSum += transaction['totalprice'] as int;
      }
    }

    print(totalSum);

    await calculateCategorySums(); // Call calculateCategorySums after getting total

    setState(() {
      Totalprice = totalSum;
    });
  }



  Future<void> calculateCategorySums() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");

    final response = await supabase
        .from('Transactions')
        .select('prices')
        .eq("userid", id);

print(response);
    List<int> individualPrices = [0,0,0,0];
    if (response != null ) {
      for (var transaction in response) {
        if (transaction != null) {
          // Ensure the data is in the expected format
          individualPrices[0]+=int.parse(transaction["prices"][0].toString());
          individualPrices[1]+=int.parse(transaction["prices"][1].toString());
          individualPrices[2]+=int.parse(transaction["prices"][2].toString());
          individualPrices[3]+=int.parse(transaction["prices"][3].toString());

        }
      }
    }


    setState(() {
      print(individualPrices[0]);
      plastics=individualPrices[0];
      ewaste=individualPrices[1];
      metals=individualPrices[2];
      paper=individualPrices[3];
    });


  }

   int touchedIndex = -1;
  Widget createDoughnutChart(double metals, double plastics, double ewaste, double paper) {

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[

          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(metals,plastics,paper,ewaste),
                ),
              ),
            ),
          ),
         SizedBox(width: 80,),
         Padding(
           padding: const EdgeInsets.only(left:10.0),
           child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: Colors.teal,
                  text: 'Metals',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color:Colors.lightGreenAccent,
                  text: 'Plastics',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.green,
                  text: 'Paper',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Colors.greenAccent,
                  text: 'E-Waste',
                  isSquare: true,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
         ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(double metals,double plastic,double paper,double ewaste) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.teal,
            value:metals,
            title: '₹ ${metals}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.black,

            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.lightGreenAccent,
            value:plastic,
            title: '₹ ${plastics}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value:paper,
            title: '₹ ${paper}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.greenAccent,
            value:ewaste,
            title: '₹ ${ewaste}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          );
        default:
          throw Error();
      }
    });
  }


  late Future<List<Widget>> centerDataFuture; // Add this line

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettotal();
    centerDataFuture = getCenterData(); // Assign the Future to centerDataFuture

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
                    Header6(widget.coordinates,widget.news),

                    Flexible(
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [

                              Padding(
                                padding: const EdgeInsets.only(left:28.0),
                                child: Row(children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Total ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Transaction',
                                          style: TextStyle(
                                            color: Colors.lightGreenAccent,
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],),
                              ) ,

                            Padding(
                                padding: const EdgeInsets.only(left:28.0,top: 20),
                                child: Row(children: [
                                  Text(
                                    '\₹${Totalprice}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left:28.0,top: 20),
                              child: Row(children: [
                                Text(
                                  'Analytics',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                )
                              ],),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height:30.h,
                                    width: 100.w,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:28.0),
                                        child: createDoughnutChart(double.parse(metals.toString()),
                                            double.parse(plastics.toString()),double.parse(ewaste.toString()),
                                            double.parse(paper.toString())),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:28.0),
                              child: Row(children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Transaction ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'History',
                                        style: TextStyle(
                                          color: Colors.lightGreenAccent,
                                          fontSize: 20,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],),
                            ) ,
                            /////////////////////////////////////////
                            // Add a FutureBuilder to handle the asynchronous operation
                            SizedBox(height: 10,),
                            FutureBuilder(
                              future: centerDataFuture, // Call your function here
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Loading indicator while waiting
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  List<Widget> centerCards = snapshot.data as List<Widget>;
                                  return SizedBox(
                                    width: 105.w,
                                    height: 19.h,
                                    child: ListView(
                                      scrollDirection:Axis.horizontal,
                                      children: centerCards,
                                    ),
                                  ); // This should be your list of center cards
                                }
                              },
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






