import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {

  static const baseUrl = "https://mathverse-backend-zy5nl44jwq-uc.a.run.app";

  // ---------------------------
  // GET LESSON
  // ---------------------------
  static Future<Map<String, dynamic>> getLesson() async {

    final response = await http.get(
      Uri.parse("$baseUrl/lesson"),
    );

    return jsonDecode(response.body);
  }

  // ---------------------------
  // START LESSON
  // ---------------------------
  static Future<Map<String, dynamic>> startLesson() async {

    final response = await http.get(
      Uri.parse("$baseUrl/start-lesson"),
    );

    return jsonDecode(response.body);
  }

  // ---------------------------
  // ASK TUTOR
  // ---------------------------
  static Future<String> askTutor(String question, String sessionId) async {

    final response = await http.post(
      Uri.parse("$baseUrl/ask-tutor"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "question": question,
        "session_id": sessionId
      }),
    );

    final data = jsonDecode(response.body);

    return data["answer"];
  }

  // ---------------------------
  // SOLVE HOMEWORK
  // ---------------------------
  static Future<String> solveHomework(Uint8List imageBytes) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/solve-homework"),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        imageBytes,
        filename: "homework.png",
      ),
    );

    final response = await request.send();

    final respStr = await response.stream.bytesToString();

    final data = jsonDecode(respStr);

    return data["solution"];
  }

  // ---------------------------
  // LIVE CAMERA DETECT
  // ---------------------------
  static Future<String> detectMath(Uint8List imageBytes) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/detect-math"),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        "file",
        imageBytes,
        filename: "camera.png",
      ),
    );

    final response = await request.send();

    final respStr = await response.stream.bytesToString();

    final data = jsonDecode(respStr);

    return data["solution"];
  }

  // ---------------------------
  // GET SESSIONS
  // ---------------------------
  static Future<List> getSessions() async {

    final response = await http.get(
      Uri.parse("$baseUrl/sessions"),
    );

    final data = jsonDecode(response.body);

    return data["sessions"];
  }

  // ---------------------------
  // GET CHAT HISTORY
  // ---------------------------
  static Future<List> getHistory(String sessionId) async {

    final response = await http.get(
      Uri.parse("$baseUrl/chat-history/$sessionId"),
    );

    final data = jsonDecode(response.body);

    return data["history"];
  }

}