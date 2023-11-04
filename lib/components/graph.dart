import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class LineChartExample extends StatefulWidget{
  Map<String, dynamic> coordinates;
  LineChartExample(this.coordinates);
  @override
  _LineChartExampleState createState() => _LineChartExampleState();
}

class _LineChartExampleState extends State<LineChartExample> {
  int _selectedIndex = 0; // Index of the selected data

  List<List<FlSpot>> graphData = [];

  @override
  void initState() {
    super.initState();
    // Call the method to process the coordinates passed through the widget
    processGraphData(widget.coordinates);
  }

  // Process the coordinates passed through the widget and update graphData list
  void processGraphData(Map<String, dynamic> coordinates) {
    try {
      for (String option in options) {
        final List<dynamic> data = coordinates[option];
        final List<FlSpot> spots = data.map((coordinate) {
          final x = coordinate['x'];
          final y = coordinate['y'];
          return FlSpot(x.toDouble(), y.toDouble());
        }).toList();
        graphData.add(spots);
      }
    } catch (e) {
      print('Error processing graph data: $e');
    }
  }
  List<String> options = [
    "Plastics",
    "PE Bags",
    "Paper",
    "E-Waste",
    "Metals",
    "Iron",
    "Copper"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:18.0),
      child: Container(
        width: 90.w,
        height: 31.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,

        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Set horizontal scroll direction
                child: Row(
                  children: List.generate(
                    options.length,
                        (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 18.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _selectedIndex == index
                              ? Colors.lightGreenAccent
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            options[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 80.w,
              height: 23.h,
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                        enabled: false
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 8,
                    titlesData: LineTiles.getTitleData(),
                    gridData: FlGridData(show: true,
                    horizontalInterval: 1),
                    lineBarsData: [
                      LineChartBarData(
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 4.0,
                            color: Color.fromARGB(255,139,195,74),
                            strokeColor: Colors.white,
                            strokeWidth: 1.0,
                          ),
                        ),
                        spots: graphData[_selectedIndex],
                        isCurved: true,
                        color: Colors.black,
                        barWidth: 2,
                      ),
                    ],
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        top: BorderSide.none,
                        left: BorderSide(color: Colors.grey.shade600, width: 1),
                        bottom: BorderSide(color: Colors.grey.shade600, width: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Current Prices",style: TextStyle(fontSize: 14.sp,)),
                  Text(" Per Kg",style: TextStyle(color: Color.fromARGB(255, 139, 195, 74),fontSize: 14.sp,),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class LineTiles{
  static getTitleData()=>FlTitlesData(
      show: true,
      topTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: false
          )
      ),
      rightTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: false
          )
      ),
      leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: (value,TitleMeta m){
              switch(value.toInt()){

                case 1:
                  return Text("20",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 2:
                  return Text("40",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 3:
                  return Text("60",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 4:
                  return Text("80",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 5:
                  return Text("100",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 6:
                  return Text("120",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 7:
                  return Text("140",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);


              }
              return Text("");
            },
          )
      ),
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: (value,TitleMeta m){
              switch(value.toInt()){

                case 1:
                  return Text("JUL",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 2:
                  return Text("AUG",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 3:
                  return Text("SEP",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 4:
                  return Text("OCT",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);
                case 5:
                  return Text("NOV",style: TextStyle(fontSize: 13.sp,fontWeight:FontWeight.w400,color: Colors.grey.shade600),);

              }
              return Text("");
            },
          )
      )
  );
}