from flask import Flask, jsonify
from app import __version__

app = Flask(__name__)


@app.get("/")
def home():
    return jsonify(
        {
            "application": "Docker CI Demo",
            "version": __version__,
            "message": "Hello from the Docker CI application",
        }
    )


@app.get("/health")
def health():
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
