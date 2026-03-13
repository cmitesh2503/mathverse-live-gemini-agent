from vertexai.generative_models import GenerativeModel, Part
from app.core.config import settings
import cv2
import numpy as np


def normalize_equation(text: str) -> str:
    """
    Fix mirrored or reversed equations from camera images
    """

    if not text:
        return text

    lines = text.split("\n")
    cleaned_lines = []

    for line in lines:

        eq = line.strip()

        if "=" in eq:

            # Example: 8 = 5 + x3  → reverse
            if eq.replace(" ", "").startswith(("8=", "9=", "7=", "6=", "5=", "4=", "3=", "2=", "1=")):
                eq = eq[::-1]

        cleaned_lines.append(eq)

    return "\n".join(cleaned_lines)

def preprocess_image(image_bytes):

    np_arr = np.frombuffer(image_bytes, np.uint8)
    image = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # remove shadows / increase contrast
    blur = cv2.GaussianBlur(gray, (5,5),0)

    thresh = cv2.adaptiveThreshold(
        blur,
        255,
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
        cv2.THRESH_BINARY_INV,
        11,
        2
    )

    return cv2.imencode(".jpg", thresh)[1].tobytes()

class VisionService:

    def __init__(self):

        self.model = GenerativeModel("gemini-2.5-flash")

    def solve_math_from_image(self, image_bytes):

        prompt = """
You are an expert handwritten math OCR system.

Your job is to read a handwritten algebra equation from the image.

Important rules:

1. Handwritten digits may be misread (2 may look like 5, 7 like 1, etc).
2. Carefully analyze the equation structure.
3. If the equation does not make mathematical sense, correct the digit.
4. Ensure the equation is logically valid before solving.

Then solve step-by-step.

Example:

3x + 2 = 8

3x = 8 - 2
3x = 6
x = 2

Return ONLY the clean equation and solution steps.

If no equation is visible return exactly:

Unable to detect equation
"""

        try:
            
            image_bytes = preprocess_image(image_bytes)
            
            response = self.model.generate_content(
                [
                    prompt,
                    Part.from_data(image_bytes, mime_type="image/jpeg")
                ]
            )

            if response and response.text:

                cleaned = normalize_equation(response.text)

                return cleaned

            return "Unable to detect equation"

        except Exception as e:

            print("Vision error:", e)

            return "Unable to detect equation"