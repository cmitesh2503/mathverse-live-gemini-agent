import re


class TutorBrain:

    def detect_question_type(self, message: str):

        message = message.lower().strip()

        # Arithmetic detection
        if re.match(r"^[0-9\.\+\-\*\/\(\)\s]+$", message):
            if any(op in message for op in ["+", "-", "*", "/"]):
                return "arithmetic"

        # Algebra
        if "solve" in message or "equation" in message or "x" in message:
            return "algebra"

        # Geometry
        if "area" in message or "triangle" in message or "circle" in message:
            return "geometry"

        # Word problems
        if "train" in message or "speed" in message or "distance" in message:
            return "word_problem"

        return "general"