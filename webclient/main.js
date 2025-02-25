let client;

try {
    client = mqtt.connect("ws://192.168.68.179:9001");
} catch (e) {
    console.log(e);
}

client.on("connect", () => {
    console.log("Connected to MQTT broker!");
});

// Function to send a message to a specified topic
function sendMessage() {
    const topic = document.getElementById("topicInput").value.trim();
    const message = document.getElementById("messageInput").value.trim();

    if (topic === "" || message === "") {
        console.warn("Topic and message cannot be empty!");
        return;
    }

    client.publish(topic, message);
    console.log(`Message published to '${topic}': ${message}`);
}

// Attach event listener to the button
document.getElementById("sendButton").addEventListener("click", sendMessage);

// Listen for incoming messages (subscribe to any topic entered)
client.on("message", (topic, message) => {
    console.log(`Received message on '${topic}': ${message.toString()}`);
});

// Error handling
client.on("error", (err) => {
    console.error("MQTT Error:", err);
});
