// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class SharedBackground extends StatelessWidget {
//   final Widget child;

//   const SharedBackground({required this.child, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         VideoPlayerBackground(),
//         child,
//       ],
//     );
//   }
// }

// class VideoPlayerBackground extends StatefulWidget {
//   @override
//   _VideoPlayerBackgroundState createState() => _VideoPlayerBackgroundState();
// }

// class _VideoPlayerBackgroundState extends State<VideoPlayerBackground> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/background/appbg2.mov')
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//         _controller.setLooping(true);
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//         : Container(color: Colors.black);
//   }
// }