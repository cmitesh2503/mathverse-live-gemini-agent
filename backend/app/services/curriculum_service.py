class CurriculumService:

    def get_lesson(self, grade, chapter):

        lessons = {
            "Linear Equations": {
                "concept": """
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
        }

        return lessons.get(chapter)