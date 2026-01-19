// import 'package:flutter/material.dart';
// import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
// import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
// import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
// import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
// import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
// import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
// import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
// import 'package:ar_flutter_plugin_2/models/ar_node.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;

// class HelloWorldPage extends StatefulWidget {
//   const HelloWorldPage({Key? key}) : super(key: key);

//   @override
//   State<HelloWorldPage> createState() => _HelloWorldPageState();
// }

// class _HelloWorldPageState extends State<HelloWorldPage> {
//   ARSessionManager? arSessionManager;
//   ARObjectManager? arObjectManager;
//   ARAnchorManager? arAnchorManager;
  
//   List<ARNode> nodes = [];
//   List<ARAnchor> anchors = [];
  
//   bool _isLoading = true;
//   String? _errorMessage;
  
//   // Scaling variable for zoom slider
//   double _scaleFactor = 1.0;
  
//   // Firebase Storage model URL (converted from gs:// to https://)
//   static const String modelUrl = "https://firebasestorage.googleapis.com/v0/b/blogapp-1c7ac.firebasestorage.app/o/models%2FtikiMud.glb?alt=media";

//   @override
//   void initState() {
//     super.initState();
//     _requestCameraPermission();
//   }

//   Future<void> _requestCameraPermission() async {
//     final status = await Permission.camera.request();
//     if (status != PermissionStatus.granted) {
//       setState(() {
//         _errorMessage = 'Camera permission is required for AR functionality';
//         _isLoading = false;
//       });
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     arSessionManager?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text(
//           'AR Experience',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Color.fromRGBO(240, 20, 37, 1.0)),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: _isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     color: Color.fromRGBO(240, 20, 37, 1.0),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Downloading 3D Model...',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : _errorMessage != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 64,
//                         color: Color.fromRGBO(240, 20, 37, 1.0),
//                       ),
//                       SizedBox(height: 16),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: Text(
//                           _errorMessage!,
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () => openAppSettings(),
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                           backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
//                         ),
//                         child: Text(
//                           'Open Settings',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : Stack(
//                   children: [
//                     ARView(
//                       onARViewCreated: onARViewCreated,
//                       planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
//                     ),
//                     Align(
//                       alignment: FractionalOffset.bottomCenter,
//                       child: Padding(
//                         padding: EdgeInsets.only(bottom: 30),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               onPressed: onRemoveEverything,
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0),
//                                 ),
//                                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                                 backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
//                                 elevation: 8,
//                                 shadowColor: Color.fromRGBO(240, 20, 37, 0.5),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.delete_sweep, color: Colors.white),
//                                   SizedBox(width: 8),
//                                   Text(
//                                     "Remove All",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Instructions
//                     Positioned(
//                       top: 20,
//                       left: 20,
//                       right: 100,
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color.fromRGBO(240, 20, 37, 0.9),
//                               Color.fromRGBO(240, 20, 37, 0.7),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(240, 20, 37, 0.3),
//                               blurRadius: 10,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               '🎯 AR Controls',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               '• Tap surfaces to place 3D model\n• Drag to move object\n• Rotate with 2 fingers\n• Use zoom slider',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Vertical zoom slider
//                     Positioned(
//                       right: 20,
//                       top: 150,
//                       bottom: 150,
//                       child: Container(
//                         width: 60,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color.fromRGBO(240, 20, 37, 0.8),
//                               Color.fromRGBO(180, 15, 30, 0.8),
//                             ],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(240, 20, 37, 0.3),
//                               blurRadius: 10,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.all(8),
//                               child: Icon(Icons.add, color: Colors.white, size: 22),
//                             ),
//                             Expanded(
//                               child: RotatedBox(
//                                 quarterTurns: 3,
//                                 child: Slider(
//                                   value: _scaleFactor,
//                                   min: 0.1,
//                                   max: 5.0,
//                                   divisions: 49,
//                                   activeColor: Colors.white,
//                                   inactiveColor: Colors.white38,
//                                   thumbColor: Colors.white,
//                                   onChanged: _onZoomSliderChanged,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(8),
//                               child: Icon(Icons.remove, color: Colors.white, size: 22),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }

//   void onARViewCreated(
//     ARSessionManager sessionManager,
//     ARObjectManager objectManager,
//     ARAnchorManager anchorManager,
//     ARLocationManager locationManager,
//   ) {
//     arSessionManager = sessionManager;
//     arObjectManager = objectManager;
//     arAnchorManager = anchorManager;

//     arSessionManager!.onInitialize(
//       showFeaturePoints: false,
//       showPlanes: true,
//       showWorldOrigin: false,
//       handlePans: true,
//       handleRotation: true,
//       handleTaps: true,
//     );

//     arObjectManager!.onInitialize();
//     arObjectManager!.onNodeTap = onNodeTapped;
//     arObjectManager!.onPanStart = onPanStarted;
//     arObjectManager!.onPanChange = onPanChanged;
//     arObjectManager!.onPanEnd = onPanEnded;
//     arObjectManager!.onRotationStart = onRotationStarted;
//     arObjectManager!.onRotationChange = onRotationChanged;
//     arObjectManager!.onRotationEnd = onRotationEnded;
    
//     arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    
//     print("AR scene ready - tap on detected surfaces to place objects");
//   }

//   Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
//     if (hitTestResults.isEmpty) {
//       print("No surface detected");
//       return;
//     }
    
//     final hit = hitTestResults.firstWhere(
//       (h) => h.type == ARHitTestResultType.plane,
//       orElse: () => hitTestResults.first,
//     );
    
//     await _addModelAtPosition(hit);
//   }

//   Future<void> _addModelAtPosition(ARHitTestResult hit) async {
//     print("Attempting to add 3D model to anchor...");
    
//     // Create anchor at hit position
//     final newAnchor = ARPlaneAnchor(
//       transformation: hit.worldTransform,
//     );
    
//     bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
//     if (didAddAnchor != true) {
//       print("Failed to add anchor");
//       return;
//     }
//     anchors.add(newAnchor);
    
//     // Calculate scale based on slider
//     final scale = vector.Vector3(
//       0.02 * _scaleFactor,
//       0.02 * _scaleFactor,
//       0.02 * _scaleFactor,
//     );
    
//     // Create node with model from Firebase Storage URL
//     final newNode = ARNode(
//       type: NodeType.webGLB,
//       uri: modelUrl,
//       scale: scale,
//       position: vector.Vector3(0, 0, 0),
//       rotation: vector.Vector4(1.0, 0.0, 0.0, 0.0),
//     );
    
//     bool? didAddNode = await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
//     print("Add node result: $didAddNode");
    
//     if (didAddNode == true) {
//       nodes.add(newNode);
//       print("Successfully placed 3D model at tapped location!");
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("3D Model placed! Use gestures to interact ✨"),
//             duration: Duration(seconds: 2),
//             backgroundColor: Color.fromRGBO(240, 20, 37, 1.0),
//           ),
//         );
//       }
//     } else {
//       print("Failed to add 3D object to anchor");
//       arAnchorManager!.removeAnchor(newAnchor);
//       anchors.remove(newAnchor);
//     }
//   }

//   void onRemoveEverything() async {
//     for (var anchor in anchors) {
//       await arAnchorManager!.removeAnchor(anchor);
//     }
//     anchors.clear();
//     nodes.clear();
//     print("Removed all AR objects and anchors");
//   }

//   void _onZoomSliderChanged(double value) {
//     setState(() {
//       _scaleFactor = value;
//     });
    
//     // Note: ar_flutter_plugin_2 doesn't support dynamic scale updates
//     // New nodes placed will use the updated scale
//     print("Zoom slider changed to scale factor: $_scaleFactor");
//     print("New models will be placed at scale: ${0.02 * _scaleFactor}");
//   }

//   void onNodeTapped(List<String> nodeNames) {
//     for (final name in nodeNames) {
//       print("Node tapped: $name");
//     }
//   }

//   void onPanStarted(String nodeName) {
//     print("Started moving node [$nodeName]");
//   }

//   void onPanChanged(String nodeName) {
//     print("Continuing to move node [$nodeName]");
//   }

//   void onPanEnded(String nodeName, Matrix4 transform) {
//     print("Finished moving node [$nodeName] to new position");
//   }

//   void onRotationStarted(String nodeName) {
//     print("Started rotating node [$nodeName]");
//   }

//   void onRotationChanged(String nodeName) {
//     print("Continuing to rotate node [$nodeName]");
//   }

//   void onRotationEnded(String nodeName, Matrix4 transform) {
//     print("Finished rotating node [$nodeName]");
//   }
// }