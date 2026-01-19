import 'package:flutter/material.dart';
import 'package:kvtechhub_arapp_test/pages/contact.dart';
import 'package:particles_network/particles_network.dart';
import 'productPage.dart';
import 'about.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Particles Background
          ParticleNetwork(
            particleCount: 150,
            maxSpeed: 0.2,
            maxSize: 0.5,
            lineWidth: 0.5,
            lineDistance: 150,
            particleColor: Colors.red,
            lineColor: Colors.red,
            touchColor: Colors.white,
            touchActivation: true,
            drawNetwork: false,
            fill: true,
            isComplex: false,
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [

                      SizedBox(height: 60),
                      Text(
                        "Quantix",
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(240, 20, 37, 1.0),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        "Experience",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Reality",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Reinvented",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),


                      Text(
                        "Bring the future to your fingertips.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Bring your vision to life.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 150),
    
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AboutPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
                          ),
                          child: Text(
                            "Learn More",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
    
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProductPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
                          ),
                          child: Text(
                            "Scan a product",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white),
                          ),
                        ),
                      ),

                      SizedBox(height: 40),



                      // Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Flexible(
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         children: [
                      //           _myElevatedButtons(context, "Permissions", _onPermissionsPressed),

                      //           _myElevatedButtons(context, "Access Camera", _onAccessCameraPressed),

                      //           _myElevatedButtons(context, "Check out the menu", _onCheckMenuPressed),

                      //           _myElevatedButtons(context, "More about us", _onMoreAboutUsPressed),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Floating burger menu button
          Positioned(
            top: 56.0,
            right: 16.0,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100, 100, 0, 0),
                    items: [
                      PopupMenuItem(
                        value: "Home",
                        child: Text(
                          "Home",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: "About",
                        child: Text(
                          "About",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: "Contact",
                        child: Text(
                          "Contact",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: "Settings",
                        child: Text(
                          "Settings",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    color: Color.fromRGBO(240, 20, 37, 0.2), // Red menu background with 80% opacity
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                  ).then((value) {
                    switch (value) {
                      case "Home":
                        // Navigate to Home
                        break;
                      case "About":
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AboutPage(),
                          ),
                        );
                        break;
                      case "Contact":
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ContactPage(),
                          ),
                        );
                        break;
                      case "Settings":
                        // Navigate to Settings
                        break;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
