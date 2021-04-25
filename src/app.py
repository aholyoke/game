from flask import Flask, redirect
import random
import string
app = Flask(__name__)

@app.route('/')
def main():
    # Home page
    return """
<form action="/game" method="post">
  <input type="submit" value="New Game">
</form>
"""


@app.route('/game', methods=['POST'])
def create_game():
    random_id = ''.join(random.choice(string.ascii_lowercase) for _ in range(10))
    return redirect(random_id)


@app.route('/<game_id>', methods=['GET'])
def lobby(game_id):
    return f"""
Welcome to game: {game_id}
<br>
Press start when ready
<br>
<form action="/start/{game_id}" method="post">
  <input type="submit" value="Start">
</form>
"""


@app.route('/start/<game_id>', methods=['POST'])
def game(game_id):
    return f"You are now playing game: {game_id}"

