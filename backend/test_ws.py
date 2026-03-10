import asyncio
import websockets

async def test():

    uri = "ws://127.0.0.1:8000/ws"

    async with websockets.connect(uri) as websocket:

        await websocket.send("Solve 2x + 5 = 13")

        while True:
            response = await websocket.recv()
            print(response)

asyncio.run(test())