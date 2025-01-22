from flask import Flask, request, jsonify
from groq import Groq
from dotenv import load_dotenv
import os

load_dotenv()
api_key=os.getenv(".env")
app = Flask(__name__)
client = Groq(api_key=api_key)

@app.route('/', methods=['POST'])
def receive_key():
    try:
        key = request.form['key']
        # Do something with the key
        print(f"Received key: {key}")
        return jsonify({"message": "Key received successfully!"}), 200
    
    except Exception as e:
        print(f"Fix this bro: {e}")
        return jsonify({"error": str(e)}), 400

@app.route('/send_prompt',methods=['POST'])
def recieve_prompt():
    try:
        query=request.form['query']
        completion = client.chat.completions.create(
        messages=[
            {'role':'system','content':'Just a friendly chatbot there to help'},
            {'role':'user','content':query},
        ],
        model="llama3-8b-8192",
        )
        print(completion.choices[0].message.content)
        return jsonify({'bot_response':completion.choices[0].message.content}), 200
    
    except Exception as e:
        return jsonify({"error": str(e)}), 400


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
