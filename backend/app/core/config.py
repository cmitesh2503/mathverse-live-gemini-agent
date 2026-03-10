import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    GOOGLE_CLOUD_PROJECT: str = os.getenv("GOOGLE_CLOUD_PROJECT")
    VERTEX_LOCATION: str = os.getenv("VERTEX_LOCATION", "global")
    GEMINI_MODEL: str = os.getenv("GEMINI_MODEL", "gemini-1.5-flash")
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY")

settings = Settings()