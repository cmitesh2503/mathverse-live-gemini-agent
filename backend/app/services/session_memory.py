class SessionMemory:

    def __init__(self):
        self.sessions = {}

    def get_history(self, session_id):

        if session_id not in self.sessions:
            self.sessions[session_id] = []

        return self.sessions[session_id]

    # ======================================
    # ADD MESSAGE
    # ======================================

    def add_message(self, session_id, role, content):

        if session_id not in self.sessions:
            self.sessions[session_id] = []

        self.sessions[session_id].append({
            "role": role,
            "content": content
        })

        # Auto title from first student question
        if len(self.sessions[session_id]) == 1 and role == "student":

            title = content[:40]

            self.session_titles[session_id] = title

        # keep last 10 messages for latency control
        if len(history) > 10:
            history.pop(0)


session_memory = SessionMemory()

# ======================================
# GET ALL SESSIONS
# ======================================

def get_sessions(self):

    sessions = []

    for session_id in self.sessions:
        
        title = self.session_titles.get(session_id, "New Chat")

        sessions.append({
            "id": session_id,
            "title": title
        })

    return sessions