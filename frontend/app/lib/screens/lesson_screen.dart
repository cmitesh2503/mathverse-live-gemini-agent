import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'camera_solver.dart';
import 'tutor_screen.dart';
import 'live_camera_solver.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {

  Map<String, dynamic>? lesson;
  String intro = "";

  @override
  void initState() {
    super.initState();
    loadLesson();
  }

  Future loadLesson() async {

    lesson = await ApiService.getLesson();

    final data = await ApiService.startLesson();
    intro = data["message"];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (lesson == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text("MathVerse Lesson"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [

            Text(
              intro,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            const Text(
              "Concept",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(lesson!["concept"]),

            const SizedBox(height: 20),

            const Text(
              "Examples",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            ...(lesson!["examples"] as List)
                .map((e) => Text("• $e"))
                .toList(),

            const SizedBox(height: 20),

            const Text(
              "Homework",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            ...(lesson!["homework"] as List)
                .map((e) => Text("• $e"))
                .toList(),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              label: const Text("Solve Homework with Camera"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CameraSolver(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.visibility),
              label: const Text("Live Camera Solver"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveCameraSolver(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(Icons.smart_toy),
              label: const Text("Ask AI Tutor"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TutorScreen(),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}