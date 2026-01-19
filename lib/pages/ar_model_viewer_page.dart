import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARModelViewerPage extends StatefulWidget {
  const ARModelViewerPage({Key? key}) : super(key: key);

  @override
  State<ARModelViewerPage> createState() => _ARModelViewerPageState();
}

class _ARModelViewerPageState extends State<ARModelViewerPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Short delay to allow the model viewer to initialize
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
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
                    'Loading 3D Model...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                ModelViewer(
                  src: 'assets/models/tikionly04.glb',
                  alt: '3D Model',
                  ar: true,
                  autoRotate: true,
                  autoRotateDelay: 0,
                  rotationPerSecond: '30deg',
                  cameraControls: true,
                  disableZoom: false,
                  backgroundColor: Colors.black,
                  arModes: ['scene-viewer', 'webxr', 'quick-look'],
                  arScale: ArScale.auto,
                  arPlacement: ArPlacement.floor,
                  cameraOrbit: '0deg 75deg 2.5m',
                  minCameraOrbit: 'auto auto 0.5m',
                  maxCameraOrbit: 'auto auto 10m',
                  touchAction: TouchAction.panY,
                  interactionPrompt: InteractionPrompt.auto,
                  shadowIntensity: 1,
                  shadowSoftness: 1,
                ),
                // Instructions overlay
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
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
                          '🎯 3D Model Controls',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Drag to rotate the model\n• Pinch to zoom in/out\n• Tap AR button to view in AR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
