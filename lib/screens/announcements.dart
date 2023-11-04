import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reearth/components/customcard.dart';
import 'package:reearth/screens/Booking.dart';
import 'package:reearth/screens/community.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/bottomNav.dart';
import '../components/header.dart';
import '../main.dart';
import 'Home.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  final Map<String, dynamic> coordinates;
  final List<dynamic> news;
  News(this.coordinates, this.news);
  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
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
                    Header(widget.coordinates,widget.news),

                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:6,
                              itemBuilder: (BuildContext context, int index) {
                                final article = widget.news[index];
                                final imageId = (index + 1).toString();
                                return FutureBuilder<Uint8List>(
                                  future: getNewsImage(imageId),
                                  builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                    if (snapshot.hasData) {
                                      final imageBytes = snapshot.data!;
                                      return CustomCard(
                                        imageBytes,
                                        article['title'],
                                        article['snippet'],
                                        article['link']
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error loading image');
                                    } else {
                                      return Text(" ");
                                    }
                                  },
                                );
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



class CustomCard extends StatelessWidget {
  final Uint8List imageUrl;
  final String title;
  final String snippet;
  final String link;

  CustomCard(this.imageUrl, this.title, this.snippet,this.link);

  void openWebView(BuildContext context,link,title) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Webview(link,title)
    ));
  }


  String getLimitedTitle() {
    final words = title.split(' ');
    if (words.length <= 8) {
      return title;
    } else {
      return words.sublist(0, 8).join(' ') + '..';
    }
  }

  String getSnippet() {
    if (snippet.isNotEmpty) {
      return snippet;
    } else {
      final words = title.split(' ');
      final limitedWords = words.take(15).toList();
      return limitedWords.join(' ') + (words.length > 15 ? '...' : '');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0,left: 20,right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: MemoryImage(imageUrl),
            fit: BoxFit.cover
          )
        ),
        width: 370,
        height: 492,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 352,
                height: 492,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.02, 1.00),
                    end: Alignment(0.02, -1),
                    colors: [Colors.black, Colors.black.withOpacity(0)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 346,
              child: SizedBox(
                width: 320,
                child: Text(
                  getLimitedTitle(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 415,
              child: SizedBox(
                width: 248,
                child: Text(
                  getSnippet(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 280,
              top: 416,
              child: Container(
                width: 43,
                height: 41,
                  decoration: ShapeDecoration(
                    color: Color(0x00D9D9D9),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.50, color: Colors.white),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.angleRight,color: Colors.lightGreenAccent,), onPressed: () { openWebView(context,link,getLimitedTitle()); },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Webview extends StatefulWidget{
  String title;
  String link;
  Webview(this.link,this.title);
  @override
  State<Webview> createState()=> _Webview();
}
class _Webview extends State<Webview>{
  WebViewController? _controller;
  @override
  void initState() {
     _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.google.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.link));
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.title,style: TextStyle(fontSize: 16),),backgroundColor: Colors.lightGreenAccent,),
      body: WebViewWidget(controller: _controller!),
    );
  }
}