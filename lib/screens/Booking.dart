import 'dart:ui';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reearth/components/CustomTextField.dart';
import 'package:reearth/components/HomeMenu.dart';
import 'package:reearth/components/NavigationMenu.dart';
import 'package:reearth/components/bottomNav.dart';
import 'package:reearth/components/header.dart';
import 'package:reearth/main.dart';
import 'package:reearth/screens/ongoing.dart';
import 'package:reearth/screens/profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/graph.dart';
import '../components/header2.dart';

class Booking extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  Booking(this.coordinates,this.news);

  @override
  _Booking createState() => _Booking();
}

class _Booking extends State<Booking> {
  int _selectedIndex = 1;


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




class BookingScreen extends StatefulWidget{
  Map<String, dynamic> coordinates;
  List< dynamic> news;

  BookingScreen(this.coordinates,this.news);
  State<BookingScreen> createState()=>_BookingScreen();
}

class _BookingScreen extends State<BookingScreen>{
  bool isOngoing = false;
  var id;// Initialize the boolean variable for ongoing transaction
  final ongoingstream = supabase.from('Transactions').stream(primaryKey: ['id']);

  late String? selectedCenter;
  String? selectedValue;
  late DateTime _selectedDate=DateTime.now();
  late List<Map<String, dynamic>> center = [];
  late List<String> timings = []; // Change timings to a list of strings
  late TimeOfDay? selectedTime; // Add selectedTime variable




  // ... Other code ...

  Future<void> fetchTimingCentersFromSupabase(String centername) async {
    final response = await supabase.from('Vendors').select().eq("name", "$centername");
    List<String> timingData = [];
    for (var i in response) {
      for (var t in i["Timings"]) {
        timingData.add(t);
      }
    }

    // Remove duplicates from timingData list
    List<String> uniqueTimings = timingData.toSet().toList();

    setState(() {
      timings = uniqueTimings;
    });
    print("$timings");
  }


  void onRecyclingCenterChanged(String selectedCenter) async {
    await fetchTimingCentersFromSupabase(selectedCenter);
  }


  Future<void> fetchCentersFromSupabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var city=prefs.getString("city");
    final response = await supabase.from('Vendors').select().eq("city", city);
    List<Map<String, dynamic>>data=[];
    for(var i in response){
      data.add({"name":i["name"],"address":i["address"]});
    }
    setState(() {
     center=data ;
    });
  }



  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
    fetchCentersFromSupabase();
    selectedValue = null;
    selectedTime = null;
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }


  Future<void> _checkSelectedTime() async {
    if (selectedTime != null) {
      final currentTime = TimeOfDay.now();

      final startTime = TimeOfDay(hour: 5, minute: 0);
      final endTime = TimeOfDay(hour: 19, minute: 0);

      if (selectedTime!.hour < startTime.hour ||
          (selectedTime!.hour == startTime.hour && selectedTime!.minute < startTime.minute) ||
          selectedTime!.hour > endTime.hour ||
          (selectedTime!.hour == endTime.hour && selectedTime!.minute > endTime.minute)) {
        Fluttertoast.showToast(
          msg: "Please select a time between 5 AM and 7 PM",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          selectedTime = null;
        });
      }
    }
  }




  TextEditingController metalsController = TextEditingController();
 TextEditingController plasticController = TextEditingController();
 TextEditingController paperController = TextEditingController();
 TextEditingController ewasteController = TextEditingController();
  TextEditingController peBagsController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          // Hide the keyboard when user taps outside of a text field
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgrounds/home.png"),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/backgrounds/home.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
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
                            Flexible(
                              child: SingleChildScrollView(
                                physics: ClampingScrollPhysics(),
                                child: Column(
                                children:[
                                  SizedBox(height: 210,),
                                  CalendarTimeline(
                                  showYears: false,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                                  onDateSelected: (date) => setState(() => _selectedDate = date),
                                  leftMargin: 20,
                                  monthColor: Colors.black,
                                  dayColor: Colors.black,
                                  dayNameColor: Colors.white,
                                  activeDayColor: Colors.white,
                                  activeBackgroundDayColor: Colors.lightGreenAccent,
                                  dotsColor: Colors.white,
                                  locale: 'en',
                                ),
                                //////////////////////////////////centers//////////

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.mapMarkerAlt, size: 35,),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 2,
                                          height: 50,
                                          color: Colors.lightGreenAccent,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(

                                              isExpanded: true,
                                              hint: const Row(
                                                children: [
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Select Recycling Center',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              items: center
                                                  .map((center) => DropdownMenuItem<String>(
                                                value: center['name'],
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      center['name'],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 2.0),
                                                      child: Text(
                                                        center['address'],
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                                  .toList(),
                                              value: selectedValue, // Set the selected value here
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedValue = value; // Update the selected value
                                                  onRecyclingCenterChanged(selectedValue!); // Fetch timings
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 53,
                                                width: 59.w,
                                                padding: const EdgeInsets.only(left: 14, right: 14),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(14),
                                                  border: Border.all(
                                                    color: Colors.transparent,
                                                  ),
                                                  color: Colors.transparent,
                                                ),
                                                elevation: 0,
                                              ),
                                              iconStyleData: const IconStyleData(
                                                icon: Icon(
                                                  Icons.arrow_forward_ios_outlined,
                                                ),
                                                iconSize: 14,
                                                iconEnabledColor: Colors.black,
                                                iconDisabledColor: Colors.black,
                                              ),
                                              dropdownStyleData: DropdownStyleData(
                                                maxHeight: 250,
                                                width: 250,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(14),
                                                  color: Colors.white,
                                                ),
                                                offset: const Offset(-20, 0),
                                                scrollbarTheme: ScrollbarThemeData(
                                                  radius: const Radius.circular(40),
                                                  thickness: MaterialStateProperty.all(6),
                                                  thumbVisibility: MaterialStateProperty.all(true),
                                                ),
                                              ),
                                              menuItemStyleData: const MenuItemStyleData(
                                                height: 40,
                                                padding: EdgeInsets.only(left: 14, right: 14),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),


                                  /////////////////////////////////////////////////////////timings/////////////

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FaIcon(FontAwesomeIcons.clock, size: 35,),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 2,
                                            height: 50,
                                            color: Colors.lightGreenAccent,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              elevation: 0,
                                              foregroundColor: Colors.black
                                            ),
                                            onPressed: () async {
                                              final TimeOfDay? picked = await showTimePicker(

                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if (picked != null && picked != selectedTime) {
                                                setState(() {
                                                  selectedTime = picked;
                                                });
                                               await  _checkSelectedTime();
                                              }
                                            },
                                            child: Text(
                                              selectedTime != null
                                                  ? 'Selected Time: ${selectedTime!.format(context)}'
                                                  : 'Select Time',
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 13,
                                        ),
                                      ],
                                    ),


                                  //////////////////////////////quantity//////////////////////////////////////////////////
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Text(
                                    "Enter Quantity (in Kgs)",
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                                  ),
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 30.w,
                                      height: 11.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:3.0),
                                            child: Text("Plastics"),
                                          ),
                                          CustomTextField(label: "",controller: plasticController,),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 30,),
                                    Container(
                                      width: 30.w,
                                      height: 11.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:3.0),
                                            child: Text("E-Waste"),
                                          ),
                                          CustomTextField(label: "",controller: ewasteController,)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 30.w,
                                      height: 11.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:3.0),
                                            child: Text("Paper"),
                                          ),
                                          CustomTextField(label: "",controller: paperController,)
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 30,),
                                    Container(
                                      width: 30.w,
                                      height: 11.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top:3.0),
                                            child: Text("Metals"),
                                          ),
                                          CustomTextField(label: "",controller: metalsController,)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:128.0,top:20),
                                        child: Container(
                                          width: 40.w,
                                          height: 11.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 3.0),
                                                child: Text("Number of PE Bags"),
                                              ),
                                              CustomTextField(label: "",controller: peBagsController,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  /////////////////////////////////////////////button///////////////////////


                                  StreamBuilder(
                                    stream: ongoingstream, // Use the stream here
                                    builder: (context, snapshot) {
                                       if (snapshot.hasData) {
                                        List<dynamic> data = snapshot.data as List<dynamic>;
                                        String vendorid="";
                                        bool isOngoing = false;
                                        for (var item in data) {
                                          bool isItemOngoing = item['ongoing'] as bool;
                                          vendorid=item['centerid'] as String;
                                          if (isItemOngoing) {
                                            isOngoing = true; // Set isOngoing to true if any item is ongoing
                                            break; // Break loop if any ongoing item is found
                                          }
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top:13.0),
                                          child: ElevatedButton(
                                            onPressed: () async{

                                              if (isOngoing) {
                                                // Handle the live tracking navigation
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => CurrentScreen(widget.coordinates, widget.news,vendorid).animate().fadeIn(duration: Duration(seconds: 1))),
                                                );
                                              } else {
                                                if(selectedValue==null){
                                                  Fluttertoast.showToast(
                                                    msg: "Select a Recycling Center",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                                if(selectedTime == null){
                                                  Fluttertoast.showToast(
                                                    msg: "Select Timing for Pickup",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                }
                                               int plasticPrice = ((double.tryParse(plasticController.text) ?? 0) * 20).round();
                                                int ewastePrice =( (double.tryParse(ewasteController.text) ?? 0) * 130).round();
                                                int metalsPrice = ((double.tryParse(metalsController.text) ?? 0) * 80).round();
                                                int paperPrice = ((double.tryParse(paperController.text) ?? 0) * 33).round();
                                                int pePrice = ((double.tryParse(peBagsController.text) ?? 0) * 1).round();



                                                // Calculate the total price
                                                 int totalPrice = plasticPrice + ewastePrice + metalsPrice + paperPrice+pePrice;

                                                  // Show a confirmation dialog to the user
                                                  bool confirmTransaction = await showDialog(
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
                                                                child: Text("Transaction Details",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                                                              ),
                                                            ),
                                                            content: Container(
                                                              height: 190,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("Plastics (${plasticController.text.isEmpty ? '0' : plasticController.text}kg)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("${plasticPrice}rs",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ), Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("E-Waste (${ewasteController.text.isEmpty ? '0' : ewasteController.text}kg)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("${ewastePrice}rs",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ), Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("Paper (${paperController.text.isEmpty ? '0' : paperController.text}kg)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("${paperPrice}rs",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ), Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("Metals (${metalsController.text.isEmpty ? '0' : metalsController.text}kg)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                        Padding(
                                                                          padding:const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("${metalsPrice}rs",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),Padding(
                                                                    padding: const EdgeInsets.all(5.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("PE Bags(${peBagsController.text.isEmpty ? '0' : peBagsController.text})",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                        Padding(
                                                                          padding:const EdgeInsets.only(left:8.0,right: 8,top:3),
                                                                          child: Text("${pePrice}rs",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text("Total Rewards Earned: ${totalPrice} rs",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text('Cancel'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(false); // Return false to indicate cancellation
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text('Confirm'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(true); // Return true to indicate confirmation
                                                                },
                                                              ),
                                                            ],
                                                          ));
                                                    },
                                                  );

                                                  // Proceed with the transaction if the user confirmed
                                                  if (confirmTransaction == true) {
                                                    // Your existing transaction logic here...
                                                    // ...
                                                    int totalPrice = plasticPrice + ewastePrice + metalsPrice + paperPrice + pePrice;

                                                    if(totalPrice>=50){
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    String? uid=prefs.getString("id");
                                                    final response = await supabase
                                                        .from('Transactions')
                                                        .select('ongoing').eq("userid",uid);
                                                    final response2 = await supabase
                                                        .from('Vendors')
                                                        .select('id').eq("name",selectedValue);
                                                    print(response);
                                                    bool isOngoing = false;

                                                    for (var record in response) {
                                                      if (record['ongoing'] == true) {
                                                        isOngoing = true;
                                                        break; // Exit the loop if any ongoing transaction is found
                                                      }
                                                    } // Default to false if ongoing column is null

                                                    if (!isOngoing) {
                                                      int plasticValue = (double.tryParse(plasticController.text)??0).round();
                                                      int eWasteValue = (double.tryParse(ewasteController.text)??0).round();
                                                      int metalsValue = (double.tryParse(metalsController.text)??0).round();
                                                      int paperValue = (double.tryParse(paperController.text)??0).round();
                                                      // Create a new transaction since there is no ongoing transaction
                                                      // Use the center ID and user ID to create the transaction entry
                                                      // Replace centerId and userId with your actual values
                                                      await supabase.from('Transactions').insert([
                                                        {
                                                          'prices':[plasticPrice+pePrice,ewastePrice,metalsPrice,paperPrice],
                                                          'totalprice':totalPrice,
                                                          'material':[plasticValue.toString(),eWasteValue.toString(),metalsValue.toString(),paperValue.toString()],
                                                          'date':"${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                                                          'Time':"${selectedTime?.hour}:${selectedTime?.minute.toString().padLeft(2, '0')}",
                                                          'centerid': response2[0]["id"],
                                                          'userid': uid,
                                                          'ongoing': true,
                                                          'isDispatched':false,
                                                          'pebags':[peBagsController.text,pePrice],
                                                          'iron':["",""],
                                                          'copper':["",""]// Set as ongoing
                                                          // Add other fields as needed
                                                        }
                                                      ]);
                                                      prefs.setBool("isonline", true);
                                                      prefs.setString("vendorid",response2[0]["id"] );
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
                                                              title: Center(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.green,
                                                                      borderRadius: BorderRadius.circular(48)
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(20.0),
                                                                    child: FaIcon(
                                                                      FontAwesomeIcons.check,
                                                                      size: 70,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              content: Padding(
                                                                padding: const EdgeInsets.all(0),
                                                                child: Container(
                                                                  height: 270,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text("Booking Confirmed",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),),
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text("Thank you for your commitment to recycling and taking a step towards a greener future! ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text("Instructions",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text(" Separate plastics, e-waste, metals, and paper. Make sure items are clean and dry. Group materials together for easy handling. Place recyclables in a visible spot on your property. We'll arrive on the scheduled date you chose.Keep the area clear and be available to assist if needed.",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: Text('OK'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );

                                                    }

                                                    //_checkAddress();
                                                    print("${selectedTime?.hour}:${selectedTime?.minute.toString().padLeft(2, '0')}");
                                                    print(selectedValue);
                                                    print("${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}");
                                                    print("${metalsController.text},${paperController.text}");
                                                    }else{
                                                      Fluttertoast.showToast(
                                                        msg: "Minimum transaction amount is 50 rs",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    }
                                                  }
                                                }
                                              },
                                            child:  SizedBox(
                                              width: 45.w,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    isOngoing ? "Live Tracking" : "Confirm Transaction",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 22.0),
                                                    child: Container(
                                                      width: 23,
                                                      height: 23,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(50),
                                                        color: Colors.lightGreenAccent,
                                                      ),
                                                      child: Center(
                                                        child: FaIcon(
                                                          FontAwesomeIcons.arrowRight,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Handle error state
                                        return Text("Error fetching data");
                                      }
                                    },
                                  ),

                                ]),
                              ),
                            ),
                            Header2(widget.coordinates,widget.news),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


