import firebase_admin
from firebase_admin import credentials, firestore


class SessionMemory:

    def __init__(self):

        try:
            if not firebase_admin._apps:
                cred = credentials.Certificate("firebase-key.json")
                firebase_admin.initialize_app(cred)

            self.db = firestore.client()

        except Exception as e:
            print("Firebase init error:", e)
            self.db = None

    # -------------------------
    # SAVE MESSAGE
    # -------------------------
    def save_message(self, session_id, role, text):

        if not self.db:
            return

        session_ref = self.db.collection("conversations").document(session_id)

        if role == "student":

            session_doc = session_ref.get()

            if not session_doc.exists:

                session_ref.set({
                    "title": text[:50]
                })

        session_ref.collection("messages").add({
            "role": role,
            "text": text,
            "timestamp": firestore.SERVER_TIMESTAMP
        })

    # -------------------------
    # GET HISTORY
    # -------------------------
    def get_history(self, session_id):

        if not self.db:
            return []

        docs = (
            self.db.collection("conversations")
            .document(session_id)
            .collection("messages")
            .order_by("timestamp")
            .stream()
        )

        history = []

        for doc in docs:
            data = doc.to_dict()

            history.append({
                "role": data.get("role"),
                "content": data.get("text")
            })

        return history

    # -------------------------
    # GET SESSIONS
    # -------------------------
    def get_sessions(self):

        if not self.db:
            return []

        sessions = []

        docs = self.db.collection("conversations").stream()

        for doc in docs:

            data = doc.to_dict()

            sessions.append({
                "id": doc.id,
                "title": data.get("title", "New Chat")
            })

        return sessions