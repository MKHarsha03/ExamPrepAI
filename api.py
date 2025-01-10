from flask import Flask
from groq import Groq
import os
from dotenv import load_dotenv

app=Flask(__name__)
load_dotenv()
api_key=os.getenv('.env')

client = Groq(api_key=api_key)

@app.route('/')
def response():
    completion = client.chat.completions.create(
    messages=[
        {'role':'system','content':'''Answer the questions from the prompt and the context given by the user. If the answer is not
         found, reply "Cannot provide answer", don't give any additional explanation about the question.Give the answer with proper headings,subheadings and bullet points if it is a long answer.
         You have to help the user understand the answer to the question and format it for notes making.Do not give answers from outside provided context'''},
        {'role':'user','content':f"Context:'Sachin tendulkar is a cricketer',Question:who is sachin tendulkar?"}
    ],
    model="llama3-8b-8192",
    )
    return "<p>{completion.choices[0].message.content}</p>"
