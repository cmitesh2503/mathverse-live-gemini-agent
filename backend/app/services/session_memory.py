class SessionMemory:

    def __init__(self):
        self.sessions = {}

    def get_history(self, session_id):

        if session_id not in self.sessions:
            self.sessions[session_id] = []

        return self.sessions[session_id]

    def add_message(self, session_id, role, content):

        history = self.get_history(session_id)

        history.append({
            "role": role,
            "content": content
        })

        # keep last 10 messages for latency control
        if len(history) > 10:
            history.pop(0)


session_memory = SessionMemory()