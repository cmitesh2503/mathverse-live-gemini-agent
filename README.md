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

Firestore Database


Architecture flow:

Frontend → FastAPI → Gemini AI → Memory Service → Firestore

---

# How It Works

1. Student opens the MathVerse web app.
2. The student can either:
   - Ask a question via chat
   - Use voice input
   - Point the camera at an equation
   - Upload a homework image
3. The frontend sends the request to the FastAPI backend.
4. The backend sends the problem to Gemini AI.
5. Gemini generates step-by-step reasoning.
6. The response is returned to the frontend and optionally read aloud.

---

# Reproducible Testing Instructions

Judges can test the project locally by following these steps.

## Step 1 — Clone the repository

git clone https://github.com/YOUR_USERNAME/mathverse-live-gemini-agent

cd mathverse-live-gemini-agent


---

## Step 2 — Backend Setup

Navigate to backend folder


cd backend


Create virtual environment


python -m venv venv


Activate environment

Windows


venv\Scripts\activate


Install dependencies


pip install -r requirements.txt


Create `.env` file


GEMINI_API_KEY=YOUR_GEMINI_API_KEY
GEMINI_MODEL=gemini-2.5-flash


Run backend


uvicorn app.main:app --reload


Backend will run on


http://127.0.0.1:8000


Swagger API documentation is available at


http://127.0.0.1:8000/docs


---

## Step 3 — Frontend Setup

Open a new terminal.

Navigate to frontend folder


cd frontend/app


Install Flutter dependencies


flutter pub get


Run the web application


flutter run -d chrome


The app will open in the browser.

---

# Demo Flow for Judges

Test these features in the running app:

### 1 Ask AI Tutor

Ask a question such as:


Solve 2x + 3 = 11


Then ask a follow-up question:


Why subtract 3?


The AI will maintain conversation context.

---

### 2 Live Camera Solver

Open the live camera feature.

Write an equation on paper:


3x + 6 = 18


Point the camera at the equation.

The system will detect and solve it step-by-step.

---
