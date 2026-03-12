import 'package:flutter/material.dart';
import '../services/api_service.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {

  List messages = [];
  List sessions = [];

  String sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late stt.SpeechToText speech;
  late FlutterTts tts;

  bool isListening = false;

  @override
  void initState() {
    super.initState();

    speech = stt.SpeechToText();
    tts = FlutterTts();

    loadSessions();
  }

  // ============================
  // LOAD SESSIONS
  // ============================

  Future loadSessions() async {

    final data = await ApiService.getSessions();

    setState(() {
      sessions = data;
    });
  }

  // ============================
  // LOAD CHAT HISTORY
  // ============================

  Future loadHistory(String id) async {

    final history = await ApiService.getHistory(id);

    setState(() {

      sessionId = id;
      messages = history;
    });

    scrollToBottom();
  }

  // ============================
  // AUTO SCROLL
  // ============================

  void scrollToBottom() {

    Future.delayed(const Duration(milliseconds: 200), () {

      if (scrollController.hasClients) {

        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ============================
  // SEND MESSAGE
  // ============================

  Future sendMessage() async {

    String question = controller.text;

    if (question.isEmpty) return;

    setState(() {

      messages.add({
        "role": "user",
        "content": question
      });
    });

    controller.clear();

    scrollToBottom();

    final answer = await ApiService.askTutor(question, sessionId);

    setState(() {

      messages.add({
        "role": "assistant",
        "content": answer
      });
    });

    scrollToBottom();

    await tts.speak(answer);

    loadSessions();
  }

  // ============================
  // NEW CHAT
  // ============================

  void newChat() {

    setState(() {

      sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      messages = [];
    });

    loadSessions();
  }

  // ============================
  // START MIC
  // ============================

  Future startListening() async {

    bool available = await speech.initialize();

    if (available) {

      setState(() {
        isListening = true;
      });

      speech.listen(
        onResult: (result) {

          setState(() {
            controller.text = result.recognizedWords;
          });

        },
      );
    }
  }

  // ============================
  // STOP MIC
  // ============================

  Future stopListening() async {

    await speech.stop();

    setState(() {
      isListening = false;
    });
  }

  // ============================
  // UI
  // ============================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Ask AI Tutor"),
      ),

      body: Row(
        children: [

          // ============================
          // SIDEBAR
          // ============================

          Container(
            width: 250,
            color: Colors.grey[200],
            child: Column(
              children: [

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: newChat,
                  child: const Text("New Chat"),
                ),

                const SizedBox(height: 10),

                const Text("Your chats"),

                Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {

                      final s = sessions[index];

                      return ListTile(
                        title: Text(s["title"]),
                        onTap: () => loadHistory(s["id"]),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          // ============================
          // CHAT AREA
          // ============================

          Expanded(
            child: Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {

                      final msg = messages[index];

                      bool isUser = msg["role"] == "user";

                      return Align(
                        alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,

                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg["content"]),
                        ),
                      );
                    },
                  ),
                ),

                // ============================
                // INPUT BAR
                // ============================

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [

                      IconButton(
                        icon: Icon(
                          isListening ? Icons.mic : Icons.mic_none,
                        ),
                        onPressed: () {

                          if (isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }

                        },
                      ),

                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Ask a math question...",
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: sendMessage,
                      ),

                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: () {
                          tts.stop();
                        },
                      )

                    ],
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}