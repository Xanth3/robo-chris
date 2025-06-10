from flask import Flask, request, jsonify
from summariser import summarise_code

app = Flask(__name__)

@app.route("/summarise", methods=["POST"])
def summarize():
    try:
        data = request.get_json()
        code = data.get("code", "")
        summary = summarise_code(code)
        return jsonify(summary=summary)
    except Exception as e:
        return jsonify(error=str(e)), 500

if __name__ == "__main__":
    app.run(debug=True)
