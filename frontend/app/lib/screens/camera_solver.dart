import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class CameraSolver extends StatefulWidget {
  const CameraSolver({super.key});

  @override
  State<CameraSolver> createState() => _CameraSolverState();
}

class _CameraSolverState extends State<CameraSolver> {

  final ImagePicker picker = ImagePicker();

  Uint8List? imageBytes;
  String solution = "Capture or upload homework";
  bool loading = false;

  Future<void> pickImage(ImageSource source) async {

    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 1920,
    );

    if (image == null) return;

    imageBytes = await image.readAsBytes();

    setState(() {
      solution = "";
    });
  }

  Future<void> solve() async {

    if (imageBytes == null) return;

    setState(() {
      loading = true;
    });

    try {

      final result = await ApiService.solveHomework(imageBytes!);

      setState(() {
        solution = result;
      });

    } catch (e) {

      setState(() {
        solution = "Solver failed";
      });

    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Homework Solver"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Row(
              children: [

                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload"),
                ),

              ],
            ),

            const SizedBox(height: 20),

            if (imageBytes != null)
              Image.memory(
                imageBytes!,
                height: 250,
              ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: imageBytes == null ? null : solve,
              icon: const Icon(Icons.calculate),
              label: const Text("Solve"),
            ),

            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  solution,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}