import math


def calculate(expression: str):

    try:
        result = eval(expression, {"__builtins__": None}, math.__dict__)
        return str(result)

    except Exception:
        return "Calculation error"