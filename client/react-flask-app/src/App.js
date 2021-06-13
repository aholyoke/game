import React, { useState, useEffect } from 'react';
import logo from './logo.svg';
import './App.css';
//import io from "socket.io-client";
import socketIOClient from "socket.io-client";

const ENDPOINT = "http://127.0.0.1:8080";

//let socket = io.connect("https://localhost:8080");

function App() {
  const [currentTime, setCurrentTime] = useState(0);

  useEffect(() => {
    const socket = socketIOClient(ENDPOINT);
    socket.on('connect', () => {
      socket.emit('message', {data: "I'm connected!"});
    });

    fetch('/time').then(res => res.json()).then(data => {
      setCurrentTime(data.time);
    });
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
          It's <time dateTime={response}>{response}</time>
          <p>The current time is {currentTime}.</p>
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
