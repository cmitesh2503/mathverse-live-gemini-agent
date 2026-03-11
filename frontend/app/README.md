# MathVerse Live – AI Math Tutor

MathVerse Live is a multimodal AI-powered math tutor that helps students solve and understand math problems using real-time camera input, voice interaction, and conversational AI.

The system allows students to point their camera at handwritten equations, upload homework images, or ask questions through text or voice. The AI tutor explains solutions step-by-step and supports follow-up questions to promote conceptual understanding.

---

# Features

### Live Camera Math Solver
Point your camera at a handwritten equation and MathVerse will detect and solve it instantly with step-by-step explanations.

### Conversational AI Tutor
Students can ask math questions using text or voice and receive clear explanations. Follow-up questions are supported through conversational memory.

### Homework Image Solver
Upload a homework image and the AI will analyze the equation and provide a detailed solution.

### Voice Interaction
Students can ask questions verbally using speech-to-text and listen to explanations using text-to-speech.

### Persistent Learning Memory
Conversation history is stored so students can continue previous learning sessions.

---

# Tech Stack

Frontend  
Flutter (Web)

Backend  
FastAPI (Python)

AI Models  
Google Gemini

Cloud Platform  
Google Cloud Platform

Cloud Services Used

- Vertex AI (Gemini)
- Cloud Run
- Firestore
- Cloud Storage

---

# Architecture Diagram

Student (Browser)

↓ Camera / Voice / Text

Flutter Frontend

↓ REST API

FastAPI Backend (Cloud Run)

↓ AI Requests

Gemini AI (Vertex AI)

↓ Reasoning + Vision

Conversation Memory Service

↓ Storage