import firebase_admin
from firebase_admin import credentials, firestore

class FirestoreMemory:


    def __init__(self):

        if not firebase_admin._apps:

            cred = credentials.Certificate("firebase-key.json")

            firebase_admin.initialize_app(cred)

        self.db = firestore.client()


    def get_history(self, session_id):

        docs = (
            self.db.collection("conversations")
            .document(session_id)
            .collection("messages")
            .order_by("timestamp")
            .stream()
        )

        history = ""

        for doc in docs:

            data = doc.to_dict()

            role = data["role"]
            text = data["text"]

            history += f"{role}: {text}\n"

        return history


    def save_message(self, session_id, role, text):

        self.db.collection("conversations") \
            .document(session_id) \
            .collection("messages") \
            .add({
                "role": role,
                "text": text,
                "timestamp": firestore.SERVER_TIMESTAMP
            })
