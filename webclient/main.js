import { GestureRecognizer, FilesetResolver, DrawingUtils } from "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.3";

const messagepresision = 3;

let client;

try {
    client = mqtt.connect("ws://<IP with mosquitto broker>:9001");  // ----ip goes here----
} catch (e) {
    console.log(e);
}

client.on("connect", () => {
    console.log("Connected to MQTT broker!");
});

// Function to send a message to a specified topic
function sendMessage(topic, message) {
    const payload = JSON.stringify(message);
    if (topic === "" || message === "") {
        console.warn("Topic and message cannot be empty!");
        return;
    }
    client.publish(topic, payload);
}

let gestureRecognizer;
let runningMode = "VIDEO";
let enableWebcamButton;
let webcamRunning = false;
const videoHeight = "360px";
const videoWidth = "480px";

// Function to create the gesture recognizer
const createGestureRecognizer = async () => {
    const vision = await FilesetResolver.forVisionTasks("https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.3/wasm");
    gestureRecognizer = await GestureRecognizer.createFromOptions(vision, {
        baseOptions: {
            modelAssetPath: "https://storage.googleapis.com/mediapipe-models/gesture_recognizer/gesture_recognizer/float16/1/gesture_recognizer.task",
            delegate: "GPU"
        },
        runningMode: runningMode
    });
};
createGestureRecognizer();

const video = document.getElementById("webcam");
const canvasElement = document.getElementById("output_canvas");
const canvasCtx = canvasElement.getContext("2d");
const gestureOutput = document.getElementById("gesture_output");

// Function to round a value to a specified number of decimals
function roundTo(value, decimals) {
    return Number(value.toFixed(decimals));
}

// Function to process landmarks and round their coordinates
function processLandmarks(landmarksArray, decimals = 4) {
    return landmarksArray.map(landmarkSet => 
        landmarkSet.map((point, index) => ({
            id: index,  // Assign an ID
            x: roundTo(point.x, decimals),
            y: roundTo(point.y, decimals) // Remove 'y', keep 'x' and 'z'
        }))
    );
}

// Check if webcam access is supported
function hasGetUserMedia() {
    return !!(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
}

if (hasGetUserMedia()) {
    enableWebcamButton = document.getElementById("webcamButton");
    enableWebcamButton.addEventListener("click", enableCam);
} else {
    console.warn("getUserMedia() is not supported by your browser");
}

// Enable the live webcam view and start detection
function enableCam(event) {
    document.getElementById("hiddentext").style.display = "block";
    if (!gestureRecognizer) {
        alert("Please wait for gestureRecognizer to load");
        return;
    }
    if (webcamRunning === true) {
        webcamRunning = false;
        enableWebcamButton.innerText = "ENABLE PREDICTIONS";
    } else {
        webcamRunning = true;
        enableWebcamButton.innerText = "DISABLE PREDICTIONS";
    }
    const constraints = {
        video: true
    };
    navigator.mediaDevices.getUserMedia(constraints).then(function (stream) {
        video.srcObject = stream;
        video.addEventListener("loadeddata", predictWebcam);
    });
}

let lastVideoTime = -1;
let results = undefined;

// Function to predict gestures from the webcam feed
async function predictWebcam() {
    const webcamElement = document.getElementById("webcam");
    if (runningMode === "IMAGE") {
        runningMode = "VIDEO";
        await gestureRecognizer.setOptions({ runningMode: "VIDEO" });
    }

    let nowInMs = Date.now();
    if (video.currentTime !== lastVideoTime) {
        lastVideoTime = video.currentTime;
        results = gestureRecognizer.recognizeForVideo(video, nowInMs);
    }
    canvasCtx.save();
    canvasCtx.clearRect(0, 0, canvasElement.width, canvasElement.height);
    const drawingUtils = new DrawingUtils(canvasCtx);
    canvasElement.style.height = videoHeight;
    webcamElement.style.height = videoHeight;
    canvasElement.style.width = videoWidth;
    webcamElement.style.width = videoWidth;

    if (results.landmarks) {
        for (const landmarks of results.landmarks) {
            drawingUtils.drawConnectors(landmarks, GestureRecognizer.HAND_CONNECTIONS, {
                color: "#00FF00",
                lineWidth: 5
            });
            drawingUtils.drawLandmarks(landmarks, {
                color: "#FF0000",
                lineWidth: 2
            });
        }
    }
    
    canvasCtx.restore();
    if (results.gestures.length > 0) {
        gestureOutput.style.display = "block";
        gestureOutput.style.width = videoWidth;
        
        const categoryName = results.gestures[0][0].categoryName;
        const categoryScore = parseFloat(results.gestures[0][0].score * 100).toFixed(2);
        const handedness = results.handednesses[0][0].displayName;

        gestureOutput.innerText = `GestureRecognizer: ${categoryName}\n Confidence: ${categoryScore} %\n Handedness: ${handedness}`;
        sendMessage("landmarks", processLandmarks(results.landmarks, messagepresision));
    } else {
        gestureOutput.style.display = "none";
    }
    if (webcamRunning === true) {
        window.requestAnimationFrame(predictWebcam);
    }
}
