
let client; // Declare a variable for the MQTT client

try {
  // Attempt to connect to the MQTT broker via WebSocket (port 9001)
  client = mqtt.connect("ws://192.168.68.179:9001");
} catch (e) {
  // Log any connection errors
  console.log(e);
}

// Event listener for successful MQTT connection
client.on("connect", () => {
  console.log("Connected to MQTT broker!");

  // Subscribe to the "test" topic
  client.subscribe("test", (err) => {
    if (!err) {
      console.log("Subscribed to topic: test");

      // Publish a message to the "test" topic
      client.publish("test", "Hello mqtt");
      console.log("Message published: Hello mqtt");
    } else {
      console.error("Subscription error:", err);
    }
  });
});

// Event listener for incoming messages
client.on("message", (topic, message) => {
  // Convert the received message (Buffer) to a string and print it
  console.log(`Received message on topic '${topic}': ${message.toString()}`);

  // Close the MQTT connection after receiving a message
  client.end();
});

// Event listener for errors
client.on("error", (err) => {
  console.error("MQTT Error:", err);
});