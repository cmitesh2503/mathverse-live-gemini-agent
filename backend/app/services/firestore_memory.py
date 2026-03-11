import firebase_admin
from firebase_admin import credentials, firestore


class FirestoreMemory:

    def __init__(self):

        if not firebase_admin._apps:
            cred = credentials.Certificate("firebase-key.json")
            firebase_admin.initialize_app(cred)

        self.db = firestore.client()

    # ======================================
    # SAVE MESSAGE
    # ======================================

    def save_message(self, session_id, role, text):

        self.db.collection("conversations") \
            .document(session_id) \
            .collection("messages") \
            .add({
                "role": role,
                "text": text,
                "timestamp": firestore.SERVER_TIMESTAMP
            })

    # ======================================
    # GET CHAT HISTORY
    # ======================================

    def get_history(self, session_id):

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
                "role": data["role"],
                "content": data["text"]
            })

        return history

    # ======================================
    # GET ALL SESSIONS
    # ======================================

    def get_sessions(self):

        docs = self.db.collection("conversations").stream()

        sessions = []

        for doc in docs:

            session_id = doc.id

            messages = (
                self.db.collection("conversations")
                .document(session_id)
                .collection("messages")
                .limit(1)
                .stream()
            )

            title = "New Chat"

            for m in messages:
                title = m.to_dict()["text"][:40]

            sessions.append({
                "id": session_id,
                "title": title
            })

        return sessions