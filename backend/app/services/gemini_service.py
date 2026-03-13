from google import genai
from app.core.config import settings
from app.services.firestore_memory import FirestoreMemory


class GeminiService:

    def __init__(self):
        # Initialize Gemini client
        self.client = genai.Client(
            api_key=settings.GEMINI_API_KEY
        )

        # Firestore conversation memory
        self.memory = FirestoreMemory()

    # ======================================
    # SIMPLE ASK
    # ======================================
    def simple_ask(self, question, context):

        name = context.get("name", "Student")
        grade = context.get("grade", "Unknown")
        board = context.get("board", "Unknown")
        chapter = context.get("current_chapter", "General Math")

        prompt = f"""
    You are MathVerse AI Tutor.

    Student:
    Name: {name}
    Grade: {grade}
    Board: {board}
    Chapter: {chapter}

    Answer in MAXIMUM 4 short sentences.

    Student question:
    {question}
    """

        try:
            response = self.client.models.generate_content(
                model=settings.GEMINI_MODEL,
                contents=prompt
            )

            # Gemini sometimes returns text in different structures
            if response.text:
                return response.text

            return response.candidates[0].content.parts[0].text

        except Exception as e:
            return f"Gemini ERROR: {str(e)}"

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

- Use ONLY plain text
- Do NOT use Markdown (** or *)
- Do NOT use LaTeX ($)
- Always use math symbols: +  -  ×  ÷  =

Format answers like this:

2x + 3 = 11
2x = 11 - 3
2x = 8
x = 4

Explain briefly but keep math clean.
"""

        try:
            response = self.client.models.generate_content(
                model=settings.GEMINI_MODEL,
                contents=prompt
            )

            if response.text:
                answer = response.text
            else:
                answer = response.candidates[0].content.parts[0].text

        except Exception as e:
            return f"Gemini ERROR: {str(e)}"

        # Clean formatting artifacts
        answer = answer.replace("**", "")
        answer = answer.replace("*", "")
        answer = answer.replace("$", "")
        answer = answer.replace("\\(", "")
        answer = answer.replace("\\)", "")

        # Normalize symbols
        answer = answer.replace(" X ", " x ")

        # Save conversation to Firestore
        self.memory.save_message(session_id, "student", message)
        self.memory.save_message(session_id, "assistant", answer)

        return answer