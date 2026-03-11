import 'dart:typed_data';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ApiService {

static const String baseUrl = "http://127.0.0.1:8000";

// ===============================
// FIX IMAGE ORIENTATION
// ===============================
static Uint8List fixOrientation(Uint8List bytes) {

final image = img.decodeImage(bytes);

if (image == null) return bytes;

final corrected = img.bakeOrientation(image);

return Uint8List.fromList(img.encodeJpg(corrected, quality: 95));

}

// ===============================
// GET LESSON
// ===============================
static Future<Map<String, dynamic>> getLesson() async {

try {

  final response = await http
      .get(Uri.parse("$baseUrl/lesson"))
      .timeout(const Duration(seconds: 20));

  return jsonDecode(response.body);

} catch (e) {

  return {
    "concept": "Failed to load lesson",
    "examples": [],
    "homework": []
  };

}

}

// ===============================
// START LESSON
// ===============================
static Future<String> startLesson() async {

try {

  final response = await http
      .get(Uri.parse("$baseUrl/start-lesson"))
      .timeout(const Duration(seconds: 20));

  final data = jsonDecode(response.body);

  return data["message"] ?? "";

} catch (e) {

  return "Unable to start lesson.";

}

}

// ===============================
// ASK TUTOR
// ===============================
static Future<String> askTutor(String question) async {


try {

  final response = await http.post(
    Uri.parse("$baseUrl/ask-tutor"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "question": question,
      "session_id": "student_1"
    }),
  ).timeout(const Duration(seconds: 40));

  final data = jsonDecode(response.body);

  return data["answer"] ?? "No answer returned.";

} catch (e) {

  return "AI tutor unavailable.";

}

}

// ===============================
// LIVE MATH DETECTION
// ===============================
static Future<String> detectMath(Uint8List imageBytes) async {

try {

  final image = img.decodeImage(imageBytes);

  if (image == null) {
    return "Invalid image";
  }

  // Fix mirror issue from webcam
  final flipped = img.flipHorizontal(image);

  // Crop center area (focus on equation)
  final cropped = img.copyCrop(
    flipped,
    x: (flipped.width * 0.2).toInt(),
    y: (flipped.height * 0.35).toInt(),
    width: (flipped.width * 0.6).toInt(),
    height: (flipped.height * 0.3).toInt(),
  );

  final jpg = Uint8List.fromList(img.encodeJpg(cropped, quality: 95));

  var request = http.MultipartRequest(
    'POST',
    Uri.parse("$baseUrl/detect-math"),
  );

  request.files.add(
    http.MultipartFile.fromBytes(
      'file',
      jpg,
      filename: "frame.jpg",
    ),
  );

  var response = await request.send();
  var res = await http.Response.fromStream(response);

  final data = jsonDecode(res.body);

  return data["solution"] ?? "Unable to detect equation";

} catch (e) {

  return "Detection failed";

}

}

// ===============================
// HOMEWORK SOLVER
// ===============================
static Future<String> solveHomework(Uint8List imageBytes) async {

try {

  final corrected = fixOrientation(imageBytes);

  var request = http.MultipartRequest(
    'POST',
    Uri.parse("$baseUrl/solve-homework"),
  );

  request.files.add(
    http.MultipartFile.fromBytes(
      'file',
      corrected,
      filename: "homework.jpg",
    ),
  );

  var response = await request.send();
  var res = await http.Response.fromStream(response);

  final data = jsonDecode(res.body);

  return data["solution"] ?? "No solution";

} catch (e) {

  return "Solver failed";

}


}
static Future<String> getHistory(String sessionId) async {

  final response = await http.get(
    Uri.parse("$baseUrl/chat-history/$sessionId"),
  );

  final data = jsonDecode(response.body);

  return data["history"];
}
}
