from flask import Flask, request

app = Flask(__name__)

@app.route('/',methods=['GET','POST'])
def receive():
    data = request.form.get('key')
    if data:
        return data, 200
    else:
        return 'No data received', 400
    
if __name__ == '__main__':
    app.run(debug=True)