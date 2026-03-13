import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:async';

import '../services/api_service.dart';
import 'package:image/image.dart' as img;

class LiveCameraSolver extends StatefulWidget {
  const LiveCameraSolver({super.key});

  @override
  State<LiveCameraSolver> createState() => _LiveCameraSolverState();
}

class _LiveCameraSolverState extends State<LiveCameraSolver> {

  CameraController? controller;
  List<CameraDescription>? cameras;

  String solution = "Point camera at equation";
  bool isReady = false;
  bool solving = false;

  Timer? timer;

  int cameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {

    cameras = await availableCameras();

    if (cameras == null || cameras!.isEmpty) {
      setState(() {
        solution = "No camera available";
      });
      return;
    }

    // Prefer back camera
    CameraDescription selectedCamera = cameras!.first;

    for (var camera in cameras!) {
      if (camera.lensDirection == CameraLensDirection.back) {
        selectedCamera = camera;
        break;
      }
    }

    cameraIndex = cameras!.indexOf(selectedCamera);

    controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await controller!.initialize();

    if (!mounted) return;

    setState(() {
      isReady = true;
    });

    startLiveDetection();
  }

  Future<void> switchCamera() async {

    if (cameras == null || cameras!.length < 2) return;

    cameraIndex = (cameraIndex + 1) % cameras!.length;

    await controller?.dispose();

    controller = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();

    if (!mounted) return;

    setState(() {});
  }

  void startLiveDetection() {

    timer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => detectMath(),
    );
  }

  Future<void> detectMath() async {

    if (controller == null || !controller!.value.isInitialized) return;
    if (solving) return;
    if (solution.contains("x =")) return;

    solving = true;

    try {

      final image = await controller!.takePicture();
      Uint8List bytes = await image.readAsBytes();

      img.Image original = img.decodeImage(bytes)!;

      img.Image processed = original;

      // Flip only if using front camera
      if (cameras![cameraIndex].lensDirection == CameraLensDirection.front) {
        processed = img.flipHorizontal(original);
      }

      Uint8List fixedBytes = Uint8List.fromList(img.encodeJpg(processed));

      final result = await ApiService.detectMath(fixedBytes);

      if (!mounted) return;

      setState(() {
        solution = result;
      });

    } catch (e) {
      print("Live detection error $e");
    }

    solving = false;
  }

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Math Solver"),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: switchCamera,
          ),
        ],
      ),
      body: Column(
        children: [

          const SizedBox(height: 20),

          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [

                SizedBox(
                  height: 300,
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CameraPreview(controller!),
                  ),
                ),

                // Scanner overlay
                Container(
                  width: 220,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Solution",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              solution,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              setState(() {
                solution = "Point camera at equation";
              });
            },
            child: const Text("Scan Again"),
          ),

        ],
      ),
    );
  }
}