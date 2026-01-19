import 'package:flutter/material.dart';
import 'package:particles_network/particles_network.dart';
import 'landing.dart';
import 'contact.dart';
import 'ar_ready_app.dart';
import 'ar_model_viewer_page.dart';
import 'test.dart';
import 'about.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

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
          // Dark overlay for better text readability
          Container(
            color: Colors.black.withOpacity(0.3),
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
                        "Products",
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
                        "Explore our AR products",
                        style: TextStyle(
                          fontSize: 24,
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
                      SizedBox(height: 40),
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
                                builder: (context) => const ARViewPage(),
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
                      SizedBox(height: 30),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ARModelViewerPage(),
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
                            "Product new package",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white),
                          ),
                        ),
                      ),

                      //New Button here

                      SizedBox(height: 40),
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
                        value: "Products",
                        child: Text(
                          "Products",
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
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LandingPage(),
                          ),
                        );
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
                      case "Products":
                        // Already on Products page
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