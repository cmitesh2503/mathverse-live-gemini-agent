from fastapi import FastAPI, WebSocket, WebSocketDisconnect, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware

from app.services.gemini_service import GeminiService
from app.services.vision_service import VisionService
from app.services.session_memory import SessionMemory
#from app.services import gemini_service

app = FastAPI(title="MathVerse AI Tutor API")

app.add_middleware(
CORSMiddleware,
allow_origins=["*",
        "http://localhost:5000",
        "http://127.0.0.1:5000"],
allow_credentials=True,
allow_methods=["*"],
allow_headers=["*"],
)

gemini_client = GeminiService()
vision_service = VisionService()
memory = SessionMemory()

@app.get("/")
def root():
    return {"status": "MathVerse backend running"}

@app.get("/lesson")
def get_lesson():


    return {
        "concept": """
    ```

    A linear equation is an equation where the variable has power 1.

    Example:
    2x + 5 = 13

    Our goal is to find the value of x.
    """,
    "examples": [
    "x + 5 = 10",
    "2x + 3 = 11"
    ],
    "homework": [
    "2x + 5 = 13",
    "4x - 7 = 9",
    "3(x + 2) = 15"
    ]
    }

@app.get("/start-lesson")
def start_lesson():


    return {
        "message": """
    ```

    Hello Aarav 👋

    Today we will learn Linear Equations.

    A linear equation is an equation where the variable has power 1.

    Example:
    2x + 5 = 13

    Our goal is to find the value of x.
    """
    }

@app.post("/ask-tutor")
async def ask_tutor(payload: dict):

    question = payload.get("question", "")
    session_id = payload.get("session_id", "student_session")

    student_context = {
        "name": "Aarav",
        "grade": "7",
        "board": "CBSE",
        "current_chapter": "Linear Equations"
    }

    try:

        response = gemini_client.chat_with_memory(
            session_id=session_id,
            message=question,
            student_context=student_context
        )

        return {"answer": response}

    except Exception as e:

        print("Tutor error:", e)

        return {"answer": "Sorry, I could not answer the question."}


@app.post("/solve-homework")
async def solve_homework(file: UploadFile = File(...)):


    image_bytes = await file.read()

    try:

        solution = vision_service.solve_math_from_image(image_bytes)

        return {"solution": solution}

    except Exception as e:

        print("Vision error:", e)

        return {"solution": "Sorry, I could not analyze the homework image."}

@app.post("/detect-math")
async def detect_math(file: UploadFile = File(...)):


    image_bytes = await file.read()

    try:

        solution = vision_service.solve_math_from_image(image_bytes)

        return {
            "detected": True,
            "solution": solution
        }

    except Exception as e:

        print("Live detection error:", e)

        return {
            "detected": False,
            "solution": "Unable to detect equation."
        }

# ======================================
# GET CHAT SESSIONS
# ======================================

@app.get("/sessions")
def get_sessions():
    
    try:
        sessions = gemini_client.memory.get_sessions()

        return {
        "sessions": sessions
    }
    except Exception as e:
        print("Error fetching sessions:", e)
        return {
        "sessions": []
    }
        return {
            "sessions": []}
        
# ======================================
# GET CHAT HISTORY
# ======================================

@app.get("/chat-history/{session_id}")
def get_chat_history(session_id: str):

    try:

        history = gemini_client.memory.get_history(session_id)

        return {
            "history": history
        }

    except Exception as e:

        print("History error:", e)

        return {
            "history": []
        }
