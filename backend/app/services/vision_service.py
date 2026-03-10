from vertexai.generative_models import GenerativeModel, Part
from app.core.config import settings

class VisionService:

    def __init__(self):

        self.model = GenerativeModel("gemini-2.0-flash")

    def solve_math_from_image(self, image_bytes):

        prompt = """
You are a math equation recognition system.

Your job is to read a math equation from the image and solve it.

The equation may be handwritten on paper.

Steps you must follow:

1. Carefully read the equation in the image.
2. Rewrite the equation in text.
3. Solve it step-by-step.
4. Show the final value of x.

Example:

Image equation:
3x + 2 = 8

Solution:
3x + 2 = 8
3x = 6
x = 2

If you cannot read an equation return exactly:

Unable to detect equation
"""

        try:

            response = self.model.generate_content(
                [
                    prompt,
                    Part.from_data(image_bytes, mime_type="image/jpeg")
                ]
            )

            if response and response.text:
                return response.text

            return "Unable to detect equation"

        except Exception as e:

            print("Vision error:", e)

            return "Unable to detect equation"