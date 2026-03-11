import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:async';

import '../services/api_service.dart';

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

controller = CameraController(
  cameras!.first,
  ResolutionPreset.high,
  enableAudio: false,
);

await controller!.initialize();

if (!mounted) return;

setState(() {
  isReady = true;
});

startLiveDetection();


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

  final result = await ApiService.detectMath(bytes);

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

            // Scanner overlay box
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