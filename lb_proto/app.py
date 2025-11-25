from flask import Flask
import socket
import os
import time

app = Flask(__name__)


counter = 0
hostname = socket.gethostname()

@app.route("/add")
def index():
    hostname = socket.gethostname()
    global counter
    counter = counter + 1
    return f"Hello from Flask! Host: {hostname}, PORT: {os.getenv('FLASK_PORT')}\n"

@app.route("/get")
def getCounter():
    global counter
    time.sleep(0.05)
    return f"this Flask Server >> Host: {hostname}, PORT : {os.getenv('FLASK_PORT')} <<<< \nCalled: {counter} TIMES\n"

if __name__ == "__main__":
    port = int(os.getenv("FLASK_PORT", "5001"))
    app.run(host="0.0.0.0", port=port, threaded = False)
