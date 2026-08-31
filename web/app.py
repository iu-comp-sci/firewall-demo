from flask import Flask
app = Flask(__name__)
@app.route('/')
def home():
    return '<http><head><title>Web Service</title></head><body><h1>Web Service</h1></body></http>'
app.run(host='0.0.0.0', port=5000)
