from flask import Flask, render_template, redirect
import random
import string
from flask_socketio import SocketIO, send

app = Flask(__name__)

app.config['SECRET_KEY'] = 'secret!'

socketio = SocketIO(app, cors_allowed_origins="*")

@socketio.on("message")
def handleMessage(msg):
    a = 1/0
    print(msg)
    send(msg, broadcast=True)
    return None

@app.route('/')
def main():
    # Home page
    return """
<script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.0.1/socket.io.js" integrity="sha512-q/dWJ3kcmjBLU4Qc47E4A9kTB4m3wuTY7vkFJDTZKjTs8jhyGQnaUrxa0Ytd0ssMZhbNua9hE+E7Qv1j+DyZwA==" crossorigin="anonymous"></script>
<script type="text/javascript" charset="utf-8">
    var socket = io();
    socket.on('connect', function() {
        socket.emit('message', {data: "I'm connected!"});
    });
</script>
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


if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=8080, use_reloader=True)
