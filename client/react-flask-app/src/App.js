import React, { useState, useEffect } from 'react';
import './App.css';
import { io } from "socket.io-client";

const ENDPOINT = "http://127.0.0.1:8080";

function App() {
  const [response, setResponse] = useState("");

  useEffect(() => {
    const socket = io(ENDPOINT);
    socket.on("FromAPI", data => {
      setResponse(data);
      console.log(data)
    });
  }, []);

  return (
    <p>
      Test
    </p>
  );
}

export default App;
