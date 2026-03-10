from google import genai

client = genai.Client(api_key="AIzaSyASpwFkQ9CgBEU2W0T4w_jGR4IbN33eMp0")

models = client.models.list()

for model in models:
    print(model.name)