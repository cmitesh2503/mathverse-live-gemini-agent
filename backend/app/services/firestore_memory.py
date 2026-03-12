import firebase_admin
from firebase_admin import credentials, firestore


class FirestoreMemory:

    def __init__(self):

        if not firebase_admin._apps:
            cred = credentials.Certificate("firebase-key.json")
            firebase_admin.initialize_app(cred)

        self.db = firestore.client()

    # ===============================
    # SAVE MESSAGE
    # ===============================

    def save_message(self, session_id, role, text):

        session_ref = self.db.collection("conversations").document(session_id)

        # create session if first student message
        if role == "student":

            session_doc = session_ref.get()

            if not session_doc.exists:

                session_ref.set({
                    "title": text[:50],
                    "created_at": firestore.SERVER_TIMESTAMP
                })

        session_ref.collection("messages").add({
            "role": role,
            "text": text,
            "timestamp": firestore.SERVER_TIMESTAMP
        })

    # ===============================
    # GET CHAT HISTORY
    # ===============================

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

    # ===============================
    # GET ALL SESSIONS
    # ===============================

    def get_sessions(self):

        docs = self.db.collection("conversations").stream()

        sessions = []

        for doc in docs:

            data = doc.to_dict()

            sessions.append({
                "id": doc.id,
                "title": data.get("title", "New Chat")
            })

        return sessions