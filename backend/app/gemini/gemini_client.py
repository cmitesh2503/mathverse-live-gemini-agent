import asyncio
from google import genai
from google.genai.types import LiveConnectConfig
from app.core.config import settings

class GeminiLiveClient:

    def __init__(self):
        self.connected = False
        self.client = None
        self.session = None
        self.live_config = None
        self.session_context = None
        self.SYSTEM_INSTRUCTION = """

    You are MathVerse Live, a professional mathematics tutor and mentor.
    Teach clearly. Focus strictly on math. Redirect non-math politely.
    """

    async def connect(self):
        """
        Initialize the Gemini client and prepare Live configuration
        """

        self.client = genai.Client(
        vertexai=True,
        project=settings.GOOGLE_CLOUD_PROJECT,
        location=settings.VERTEX_LOCATION)
        self.live_config = LiveConnectConfig(
            response_modalities=["TEXT"]
        )
        self.connected = True
        # Prepare configuration for Gemini Live sessions
        self.live_config = LiveConnectConfig(
            response_modalities=["TEXT"]
        )

        self.connected = True


    
    async def start_live_session(self):

        if not self.client:
            await self.connect()

        # Create Live session context manager
        self.session_context = self.client.aio.live.connect(
            model= "models/" + settings.GEMINI_MODEL,
            config=self.live_config
        )

        # Enter the async context
        self.session = await self.session_context.__aenter__()
    
    async def stream(self, message: str, student_context: dict):

        if not self.connected:
            raise Exception("Gemini client not connected.")

        if not self.session:
            await self.start_live_session()

        full_prompt = f"""

    {self.SYSTEM_INSTRUCTION}

    Student Profile:

    * Grade: {student_context['grade']}
    * Board: {student_context['board']}
    * Chapter: {student_context['current_chapter']}

    Student Question:
    {message}
    """

        # Send message to Gemini Live session
        await self.session.send(input=full_prompt)

        # Receive streaming responses
        async for response in self.session.receive():

            if hasattr(response, "text") and response.text: 
                yield response.text