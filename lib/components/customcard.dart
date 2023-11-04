import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const CustomCard({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        width: 390, // Adjusted width to ensure right border visibility
        height: 290,
        child: Stack(
          children: [
            Positioned(
              right: 20, // Adjusted position to align with the right edge
              child: Container(
                width: 360, // Adjusted width to ensure right border visibility
                height: 290,
                child: Stack(
                  children: [
                    Positioned(
                      left: 260,
                      top: 209,
                      child: Container(
                        width: 79,
                        height: 32,
                        child: Stack(
                          children: [
                            Container(
                              width: 79,
                              height: 32,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3DEC02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 6,
                      top: 0,
                      child: Container(
                        width: 350,
                        height: 266,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 205,
                      top: 65,
                      child: SizedBox(
                        width: 145,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 235,
                      top: 23,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 13,
                      child: Container(
                        width: 178,
                        height: 240,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: AssetImage(imageUrl),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 210,
                      left: 220,
                      child: Container(
                        height: 35,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 139, 195, 74),
                            elevation: 1,
                          ),
                          onPressed: () {},
                          child: Text(
                            'Read More',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
