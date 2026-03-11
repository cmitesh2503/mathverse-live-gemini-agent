import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../services/api_service.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {

  final SpeechToText speech = SpeechToText();
  final FlutterTts tts = FlutterTts();
  final TextEditingController controller = TextEditingController();

  bool isListening = false;
  bool isLoading = false;

  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    initSpeech();
    loadHistory();
  }

  // ===============================
  // LOAD HISTORY FROM BACKEND
  // ===============================

  Future<void> loadHistory() async {

    try {

      String history = await ApiService.getHistory("student_1");

      setState(() {
        messages.add({
          "role": "assistant",
          "text": history
        });
      });

    } catch (e) {
      print("History error $e");
    }

  }

  // ===============================
  // INIT SPEECH
  // ===============================

  Future<void> initSpeech() async {

    await speech.initialize();

    await tts.setLanguage("en-US");
    await tts.setSpeechRate(0.4);

  }

  // ===============================
  // ASK AI
  // ===============================

  Future<void> askAI() async {

    if (controller.text.isEmpty) return;

    String question = controller.text;

    setState(() {

      messages.add({
        "role": "user",
        "text": question
      });

      isLoading = true;

    });

    controller.clear();

    String response = await ApiService.askTutor(question);

    setState(() {

      messages.add({
        "role": "assistant",
        "text": response
      });

      isLoading = false;

    });

    await tts.speak(response);

  }

  // ===============================
  // SPEECH INPUT
  // ===============================

  void startListening() async {

    bool available = await speech.initialize();

    if (!available) return;

    setState(() {
      isListening = true;
    });

    speech.listen(
      onResult: (result) {
        controller.text = result.recognizedWords;
      },
    );
  }

  void stopListening() {

    speech.stop();

    setState(() {
      isListening = false;
    });
  }

  // ===============================
  // STOP AI SPEAKING
  // ===============================

  void stopAI() async {
    await tts.stop();
  }

  // ===============================
  // CHAT BUBBLE
  // ===============================

  Widget chatBubble(Map<String,String> message){

    bool isUser = message["role"] == "user";

    return Container(

      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,

      margin: const EdgeInsets.symmetric(vertical: 6),

      child: Container(

        padding: const EdgeInsets.all(12),

        constraints: const BoxConstraints(maxWidth: 320),

        decoration: BoxDecoration(

          color: isUser ? Colors.blue : Colors.grey[300],

          borderRadius: BorderRadius.circular(12),

        ),

        child: Text(

          message["text"] ?? "",

          style: TextStyle(

            color: isUser ? Colors.white : Colors.black,
            fontSize: 16,

          ),
        ),
      ),
    );
  }

  // ===============================
  // UI
  // ===============================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Ask AI Tutor"),
      ),

      body: Column(

        children: [

          // CHAT HISTORY

          Expanded(

            child: ListView.builder(

              padding: const EdgeInsets.all(12),

              itemCount: messages.length,

              itemBuilder: (context,index){

                return chatBubble(messages[index]);

              },

            ),
          ),

          if(isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          // INPUT BAR

          Container(

            padding: const EdgeInsets.all(10),

            child: Row(

              children: [

                Expanded(

                  child: TextField(

                    controller: controller,

                    decoration: const InputDecoration(
                      hintText: "Ask a math question...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: askAI,
                ),

                IconButton(
                  icon: Icon(isListening ? Icons.mic_off : Icons.mic),
                  onPressed: isListening ? stopListening : startListening,
                ),

                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: stopAI,
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}