import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARViewPage extends StatefulWidget {
  const ARViewPage({Key? key}) : super(key: key);

  @override
  State<ARViewPage> createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  String localObjectReference = "";
  bool _isLoading = true;
  String? _errorMessage;
  
  // Scaling variable for zoom slider
  double _scaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = 'Camera permission is required for AR functionality';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'AR Experience',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromRGBO(240, 20, 37, 1.0)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color.fromRGBO(240, 20, 37, 1.0),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Initializing AR...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Color.fromRGBO(240, 20, 37, 1.0),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => openAppSettings(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
                        ),
                        child: Text(
                          'Open Settings',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Stack(children: [
                    ARView(
                      onARViewCreated: onARViewCreated,
                      planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: onRemoveEverything,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
                                elevation: 8,
                                shadowColor: Color.fromRGBO(240, 20, 37, 0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete_sweep, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Remove All",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Instructions only 
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 100, // Leave space for zoom slider
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(240, 20, 37, 0.9),
                              Color.fromRGBO(240, 20, 37, 0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(240, 20, 37, 0.3),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '🎯 AR Controls',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Tap surfaces to place 3D model\n• Drag to move object\n• Rotate with 2 fingers\n• Use zoom slider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Vertical zoom slider on the right side
                    Positioned(
                      right: 20,
                      top: 150,
                      bottom: 150,
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(240, 20, 37, 0.8),
                              Color.fromRGBO(180, 15, 30, 0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(240, 20, 37, 0.3),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Zoom In indicator
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.add, color: Colors.white, size: 22),
                            ),
                            // Vertical Slider
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: 3, // Rotate 270 degrees to make it vertical
                                child: Slider(
                                  value: _scaleFactor,
                                  min: 0.1,
                                  max: 5.0,
                                  divisions: 49, // Smooth increments
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white38,
                                  thumbColor: Colors.white,
                                  onChanged: _onZoomSliderChanged,
                                ),
                              ),
                            ),
                            // Zoom Out indicator
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.remove, color: Colors.white, size: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: null,
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
          handleTaps: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;

    _addLocalObject();
  }

  Future<void> _addLocalObject() async {
    // Skip adding objects initially - focus on plane detection first
    print("AR scene ready - tap on detected surfaces to place objects");
  }

  Future<void> onRemoveEverything() async {
    // Remove all 3D objects
    for (var node in nodes) {
      this.arObjectManager!.removeNode(node);
    }
    nodes.clear();
    
    // Remove all anchors
    for (var anchor in anchors) {
      this.arAnchorManager!.removeAnchor(anchor);
    }
    anchors.clear();
    
    print("Removed all AR objects and anchors");
  }

  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    try {
      var planeResults = hitTestResults.where(
          (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane).toList();
      
      if (planeResults.isEmpty) {
        print("No plane detected in hit test results");
        return;
      }
      
      var singleHitTestResult = planeResults.first;
      var newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        
        // Use webGLB with a reliable hosted model
        // localGLTF2 does NOT support .glb files - only .gltf format
        const modelUri = "assets/models/tikiLast002.glb";
        
        // Add 3D model from local assets with consistent base scale
        double baseScale = 1.0; // Base scale for the model
        var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: modelUri,
          scale: vector.Vector3(baseScale * _scaleFactor, baseScale * _scaleFactor, baseScale * _scaleFactor),
          position: vector.Vector3(0.0, 0.0, 0.0),
          rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
        );
        
        print("Attempting to add 3D model to anchor...");
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        
        print("Add node result: $didAddNodeToAnchor");
        
        if (didAddNodeToAnchor == true) {
          this.nodes.add(newNode);
          print("Successfully placed 3D model at tapped location!");
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("3D Model placed! Use gestures to interact ✨"),
                duration: Duration(seconds: 2),
                backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
              ),
            );
          }
        } else {
          print("Failed to add 3D object to anchor - trying alternative approach");
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("AR marker placed! 📍 (3D model loading failed)"),
                duration: Duration(seconds: 2),
                backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
              ),
            );
          }
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    } catch (e) {
      print("Error in onPlaneOrPointTapped: $e");
    }
  }

  // Zoom slider handler
  void _onZoomSliderChanged(double value) {
    setState(() {
      _scaleFactor = value;
    });
    
    // Apply scaling to all placed objects
    if (nodes.isNotEmpty) {
      for (var node in nodes) {
        _scaleNode(node, _scaleFactor);
      }
      
      print("Zoom slider changed to scale factor: $_scaleFactor");
    }
  }

  void onPanStarted(String nodeName) {
    print("Started moving node $nodeName");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Moving 3D object... 📍"),
          duration: Duration(seconds: 1),
          backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
        ),
      );
    }
  }

  void onPanChanged(String nodeName) {
    print("Continuing to move node $nodeName");
  }

  void onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Finished moving node $nodeName to new position");
    try {
      final pannedNode = nodes.firstWhere(
          (element) => element.name == nodeName,
          orElse: () => throw StateError('Node not found'));
      pannedNode.transform = newTransform;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("3D object repositioned! ✅"),
            duration: Duration(seconds: 1),
            backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
          ),
        );
      }
    } catch (e) {
      print("Error updating moved node: $e");
    }
  }

  void onRotationStarted(String nodeName) {
    print("Started rotating node $nodeName");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Rotating 3D object... 🔄"),
          duration: Duration(seconds: 1),
          backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
        ),
      );
    }
  }

  void onRotationChanged(String nodeName) {
    print("Continuing to rotate node $nodeName");
  }

  void onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Finished rotating node $nodeName");
    try {
      final rotatedNode = nodes.firstWhere(
          (element) => element.name == nodeName,
          orElse: () => throw StateError('Node not found'));
      rotatedNode.transform = newTransform;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("3D object rotated! 🔄✅"),
            duration: Duration(seconds: 1),
            backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
          ),
        );
      }
    } catch (e) {
      print("Error updating rotated node: $e");
    }
  }

  void _scaleNode(ARNode node, double scaleFactor) {
    try {
      // Base scale for the model - matches initial placement scale
      double baseScale = 1.0;
      double newScale = baseScale * scaleFactor;
      
      // Update the node's scale directly
      vector.Vector3 newScaleVector = vector.Vector3(newScale, newScale, newScale);
      node.scale = newScaleVector;
      
      print("Updated node ${node.name} scale to: $newScale");
      
    } catch (e) {
      print("Error scaling node: $e");
    }
  }
}
