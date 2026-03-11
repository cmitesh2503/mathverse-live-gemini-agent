import 'package:flutter/material.dart';

import 'screens/lesson_screen.dart';
import 'screens/tutor_screen.dart';
import 'screens/camera_solver.dart';
import 'screens/live_camera_solver.dart';

void main() {
  runApp(const MathVerseApp());
}

class MathVerseApp extends StatelessWidget {
  const MathVerseApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'MathVerse AI Tutor',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,

      routes: {

        "/lesson": (context) => const LessonScreen(),
        "/tutor": (context) => const TutorScreen(),
        "/camera": (context) => const CameraSolver(),
        "/live": (context) => const LiveCameraSolver(),

      },

      home: const LessonScreen(),
    );
  }
}