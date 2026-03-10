# MathVerse Live – Adaptive AI Tutor

## 🚀 Overview

MathVerse Live is a real-time multimodal adaptive AI math tutor built using Gemini Live API on Google Cloud.

It listens, sees, explains visually, generates graphs, and assigns personalized homework aligned to a student’s curriculum, grade level, and learning pace.

Communication between the frontend and backend is handled using **bi-directional WebSocket streaming**, enabling low-latency real-time interaction.

This project is being developed as part of a next-generation Live AI Agent challenge.

---

## 🎯 Problem Statement

Students often struggle with mathematics due to:

- Lack of real-time personalized guidance
- One-size-fits-all teaching approaches
- No curriculum-aware adaptive feedback
- Limited visual explanation support
- No instant homework evaluation

Traditional tutoring is expensive, inaccessible, and not always adaptive.

---

## 💡 Solution

MathVerse Live is a real-time AI-powered math tutor that:

- Understands live voice input
- Scans handwritten homework using camera
- Solves problems step-by-step visually
- Generates graphs dynamically
- Adapts explanations based on grade & board
- Assigns personalized homework
- Tracks mastery and learning progression

The system leverages **Gemini Live API with bi-directional WebSocket streaming** to enable real-time multimodal interaction.


## ✨ Core Features

- 🎤 Live voice tutoring (interruptible)
- 📸 Homework scanning via camera
- 🧮 Step-by-step visual equation solving
- 📊 Automatic graph generation
- 📝 Personalized homework generation
- 📚 Curriculum-aware adaptation (Board + Grade based)
- 📈 Student mastery tracking
- 🔄 Bi-directional real-time streaming architecture


## 🏗 Architecture Overview

## 🏗 Architecture Overview

```
Flutter Frontend (Web & Mobile)
        ↕ WebSocket (Bi-directional)
FastAPI Backend (Cloud Run)
        ↕ WebSocket (Gemini Live API)
Gemini Live API (Vertex AI)
        ↓
Tool Layer:
    - Equation Extraction
    - Stepwise Solver
    - Graph Generator
    - Homework Generator
        ↓
Firestore (Student Profile + Curriculum)
Cloud Storage (Graphs + Generated Assets)
```
---

## 🛠 Tech Stack

Frontend:
- Flutter (Web + Mobile)

Backend:
- FastAPI (Python)
- WebSocket (Bi-directional streaming)

AI:
- Gemini Live API (Bi-directional Streaming via Vertex AI)
- Google GenAI SDK

Cloud:
- Google Cloud Run
- Firestore
- Cloud Storage
- Vertex AI

Version Control:
- GitHub
----
```
## 📂 Project Structure

mathverse-live-gemini-agent/
│
├── frontend/ # Flutter app
├── backend/ # FastAPI backend
│ ├── app/
│ │ ├── websocket/ # WebSocket session manager
│ │ ├── gemini/ # Gemini Live client abstraction
│ │ ├── tools/ # Tool-based logic (future)
│ │ ├── services/ # Firestore & business logic (future)
│ │ └── main.py
├── docs/ # Architecture & documentation
├── demo-assets/ # Screenshots & demo materials
└── README.md
```

---

## 📌 Current Status

Day 1:
- Project structure initialized
- Flutter frontend skeleton created
- FastAPI backend skeleton created
- Google Cloud project configured

Day 2:
- Implemented WebSocket bi-directional communication
- Added Connection Manager for session handling
- Integrated Gemini client streaming skeleton