from flask import Flask, redirect, render_template

import random
import string
from flask_socketio import SocketIO, send, emit
import time

app = Flask(__name__, template_folder="../build", static_folder="../build/static", static_url_path="/static")

app.config['SECRET_KEY'] = 'secret!'
app.config['TEMPLATES_AUTO_RELOAD'] = True

socketio = SocketIO(app, cors_allowed_origins="*")

@app.route('/time')
def get_current_time():
 return {'time': time.time()}



@socketio.on("message")
def handleMessage(msg):
    a = 1/0
    print(msg)
    send(msg, broadcast=True)
    return None

@socketio.on('connect')
def test_connect(auth=None):
    emit('FromAPI', {'data': '12pm'})



@socketio.on('disconnect')
def test_disconnect():
    print('Client disconnected')


@app.route('/')
def main():
    # Home page
    return render_template("index.html")


@app.route('/manifest.json')
def manifest():
    return {
      "name": "Sayless",
      "short_name": "Sayless",
      "description": "Please don't say so much",
      "start_url": "/",
      "background_color": "#000000",
      "theme_color": "#0f4a73",
      "icons": [],
    }


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


if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=8080, use_reloader=True)
