from flask import Flask, request, jsonify

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
