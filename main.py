from flask import Flask, jsonify

# Creating a new "app" by using the Flask constructor. Passes __name__ as a parameter.
app = Flask(__name__)

games = [
  {
    "id": 0,
    "name": "Scrabble",
    "editor": "mattel",
    "year_published": "1978",
    "description": "descp",
    "category": "family",
    "time": "60min",
    "number_player": "2-5"
  },
  {
    "id": 1,
    "name": "Aventuriers du rail",
    "editor": "asmodee",
    "year_published": "2006",
    "description": "descp",
    "category": "family",
    "time": "45min",
    "number_player": "2-5"
  }
]

# Annotation that allows the function to be hit at the specific URL.
@app.route("/")
# Generic Python functino that returns "Hello world!"
def index():
    return "Hello world DevOps!"

@app.route("/jeux")
def listeJeux():
    return jsonify({"games": games})

@app.route("/jeux", methods=["POST"])
# This function requires a parameter from the URL.
def get_Addgame(object_game):
    # Traitement ajout de donnée
    pass


# Checks to see if the name of the package is the run as the main package.
if __name__ == "__main__":
    # Runs the Flask application only if the main.py file is being run.
    app.run(host='0.0.0.0')