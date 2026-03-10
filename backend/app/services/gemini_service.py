from google import genai
from app.core.config import settings
from app.services.session_memory import SessionMemory
from app.services.firestore_memory import FirestoreMemory
class GeminiService:

    def __init__(self):

        self.client = genai.Client(
            api_key=settings.GEMINI_API_KEY
        )

        self.memory = FirestoreMemory()


# ======================================
# SIMPLE ASK
# ======================================
    def simple_ask(self, question, context):

        prompt = f"""

    You are MathVerse AI Tutor.

    Student:
    Name: {context["name"]}
    Grade: {context["grade"]}
    Board: {context["board"]}
    Chapter: {context["current_chapter"]}

    Answer in MAXIMUM 4 short sentences.

    Student question:
    {question}
    """

        response = self.client.models.generate_content(
            model=settings.GEMINI_MODEL,
            contents=prompt
        )

        return response.text


# ======================================
# CHAT WITH MEMORY
# ======================================
    def chat_with_memory(self, session_id, message, student_context):

        history = self.memory.get_history(session_id)

        prompt = f"""
    You are MathVerse AI Tutor helping a Grade {student_context["grade"]} student.

    Conversation history:
    {history}

    Student question:
    {message}

    Important formatting rules:

    - Use ONLY plain text.
    - Do NOT use Markdown (** or *).
    - Do NOT use LaTeX ($).
    - Do NOT use words like "plus" or "minus".
    - Always use math symbols: +  -  ×  ÷  =

    Format answers like this:

    2x + 3 = 11
    2x = 11 - 3
    2x = 8
    x = 4

    Explain briefly but keep math clean.
    """

        response = self.client.models.generate_content(
            model=settings.GEMINI_MODEL,
            contents=prompt
        )

        answer = response.text
        

        # remove markdown artifacts
        answer = answer.replace("**", "")
        answer = answer.replace("*", "")
        answer = answer.replace("$", "")
        answer = answer.replace("\\(", "")
        answer = answer.replace("\\)", "")

        # normalize symbols
        answer = answer.replace("x ", "x ")
        answer = answer.replace(" X ", " x ")

        self.memory.save_message(session_id, "student", message)
        self.memory.save_message(session_id, "assistant", answer)

        return answer