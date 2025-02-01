from flask import Flask, request, jsonify
from groq import Groq
from dotenv import load_dotenv
import os
from flask_cors import CORS
from langchain_community.document_loaders import PyPDFLoader
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_core.vectorstores import InMemoryVectorStore
import torch


load_dotenv()
api_key=os.getenv(".env")
app = Flask(__name__)
CORS(app)
client = Groq(api_key=api_key)
#device = torch.device("cuda")
embeddings = HuggingFaceEmbeddings(model_name='sentence-transformers/all-mpnet-base-v2',model_kwargs={'device':'cpu'}) #Change to cuda if you have Nvidia gpu

text_splitter=RecursiveCharacterTextSplitter(
    chunk_size=1000,chunk_overlap=200,add_start_index=True
)
vector_store=InMemoryVectorStore(embeddings)
app.config['UPLOAD_FILE'] = r"C:\Users\khmam\Desktop\temp_storage"

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
        print(f"Query: {query}")
        results=vector_store.similarity_search(query,k=5)
        completion = client.chat.completions.create(
        messages=[
        {'role':'system','content':"Answer the question making it easy for the user to make notes. Layout the content with headings, subheadings, bullet points etc."},
         {'role':'user','content':f"Context:{results[:5]},Question:{query}"}
        ],
        model="llama3-8b-8192",
        )
        #print(completion.choices[0].message.content)
        return jsonify({'bot_response':completion.choices[0].message.content}), 200
    
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
            file_path = os.path.join(app.config['UPLOAD_FILE'], file.filename)
            file.save(file_path)  # Ensure the file is saved before attempting to load
            loader = PyPDFLoader(file_path)
            docs = loader.load()
            print("The pdf is loaded under docs variable")
            all_splits = text_splitter.split_documents(docs)
            print("Text has been splitted accordingly")
            vector_store.add_documents(documents=all_splits)
            print("Stored in vector store")
            return jsonify({'message': 'The file has been processed successfully'}), 200
    except Exception as e:
        app.logger.error(f"Error processing file: {e}")
        return jsonify({'message': 'Internal Server Error'}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
