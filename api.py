from flask import Flask,request,jsonify

app=Flask(__name__)

app.route("/sendKey",methods=['GET','POST'])
def apiKey():
    key=request.form.get('key')

    if key:
        return jsonify({'message':'Key received successfully!'})
    else:
        return jsonify({'message':'No key provided'}), 400
    

if __name__=='__main__':
    app.run(debug=True,port=49486)
    

