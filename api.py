from flask import Flask, request, jsonify
from groq import Groq
from dotenv import load_dotenv
import os
from flask_cors import CORS
from langchain_community.document_loaders import PyPDFLoader
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_chroma import Chroma

load_dotenv()
api_key = os.getenv("API_KEY")
app = Flask(__name__)
CORS(app)
client = Groq(api_key=api_key)
embeddings = HuggingFaceEmbeddings(model_name='sentence-transformers/all-MiniLM-L6-v2')

text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000, chunk_overlap=200, add_start_index=True
)
db = Chroma(embedding_function=embeddings)  # Initialize Chroma with embeddings

app.config['UPLOAD_FOLDER'] = r"C:\Users\khmam\Desktop\temp_storage"

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

@app.route('/send_prompt', methods=['POST'])
def receive_prompt():
    try:
        query = request.form['query']
        print(f"Query: {query}")
        results = db.similarity_search(query, k=5)
        context = " ".join([result.page_content for result in results])
        print(results)
        completion = client.chat.completions.create(
            messages=[
                {'role': 'system', 'content': """Answer the question making it easy for the user to make notes. Layout the content with headings, subheadings, bullet points etc.
                 If the user has doubts clarify with the data from the context and bit of your knowledge as well. The layout is mandatory in either case. If the answer to the question is not in context ask
                 the user to rephrase. Don't rewrite the users query."""},
                {'role': 'user', 'content': f"Context: {context}, Question: {query}"}
            ],
            model="llama-3.2-1b-preview",
        )
        return jsonify({'bot_response': completion.choices[0].message.content}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route("/send_docs", methods=['POST'])
def receive_docs():
    try:
        if 'file' not in request.files:
            return jsonify({'message': 'No file part'}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({'message': 'No selected file'}), 400
        if file:
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
            file.save(file_path)  # Ensure the file is saved before attempting to load
            loader = PyPDFLoader(file_path)
            docs = loader.load()
            print("The pdf is loaded under docs variable")
            all_splits = text_splitter.split_documents(docs)
            print("Text has been split accordingly")
            db.add_documents(documents=all_splits)
            print("Stored in vector store")
            return jsonify({'message': 'The file has been processed successfully'}), 200
    except Exception as e:
        app.logger.error(f"Error processing file: {e}")
        return jsonify({'message': 'Internal Server Error'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)

