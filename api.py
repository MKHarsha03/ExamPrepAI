from flask import Flask, request
import os

app = Flask(__name__)

UPLOAD_FOLDER='/Desktop/'

@app.route('/upload',methods=['GET'])
def upload_file():
    if 'pdf' not in request.files:
        return 'No file part',400
    
    file = request.files['pdf']

    if file.filename=='':
        return 'No selected file',400
    
    return 'File uploaded successfully',200

if __name__=='__main__':
    app.run(debug=True)
