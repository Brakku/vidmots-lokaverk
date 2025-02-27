local mqtt = require("mqtt")
local json = textutils.unserializeJSON  -- CC:Tweaked's JSON parser

-- Monitor setup
local mon = peripheral.find("monitor")
if not mon then
    print("No monitor found!")
    return
end

mon.setTextScale(0.5)  -- Adjust text size
local width, height = mon.getSize()

-- Define characters
local dotChar = "."   -- Background (.)
local lineChar = "#" -- Line (#)

-- MQTT Setup
local keep_alive = 60
local client = mqtt.client {
    uri = "<IP with mosquitto broker>:9001",
    clean = true,
    keep_alive = keep_alive
}

-- Initialize blank canvas
local function createCanvas()
    local canvas = {}
    for y = 1, height do
        canvas[y] = {}
        for x = 1, width do
            canvas[y][x] = dotChar
        end
    end
    return canvas
end

-- Bresenham's line algorithm for drawing connections
local function drawLine(canvas, x1, y1, x2, y2)
    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)
    local sx = (x1 < x2) and 1 or -1
    local sy = (y1 < y2) and 1 or -1
    local err = dx - dy

    while true do
        if x1 >= 1 and x1 <= width and y1 >= 1 and y1 <= height then
            canvas[y1][x1] = lineChar
        end
        if x1 == x2 and y1 == y2 then break end
        local e2 = 2 * err
        if e2 > -dy then
            err = err - dy
            x1 = x1 + sx
        end
        if e2 < dx then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

-- Function to map landmarks to monitor size
local function mapLandmarks(landmarks, w, h)
    local mapped = {}

    for _, point in ipairs(landmarks) do
        -- Ensure the point has valid x and y values
        if type(point) == "table" and type(point.x) == "number" and type(point.y) == "number" then
            local x = math.max(0, math.min(1, point.x))
            local y = math.max(0, math.min(1, point.y))

            -- Mirror X and Flip Y
            local screenX = math.floor((1 - x) * w)  -- Mirror X
            local screenY = math.floor(y * h)        -- Flip Y

            screenX = math.max(1, math.min(w, screenX))
            screenY = math.max(1, math.min(h, screenY))

            mapped[#mapped + 1] = {x = screenX, y = screenY}
        else
            print("Invalid landmark received:", textutils.serialize(point))
        end
    end

    return mapped
end

-- Function to render ASCII art to the monitor
local function renderCanvas(canvas)
    mon.clear()
    for y, row in ipairs(canvas) do
        mon.setCursorPos(1, y)
        mon.write(table.concat(row, ""))
    end
end

-- Hand connection pairs (from Mediapipe hand landmarks)
local connections = {
    {0, 1}, {1, 2}, {2, 3}, {3, 4},  -- Thumb
    {0, 5}, {5, 6}, {6, 7}, {7, 8},  -- Index Finger
    {0, 9}, {9, 10}, {10, 11}, {11, 12},  -- Middle Finger
    {0, 13}, {13, 14}, {14, 15}, {15, 16},  -- Ring Finger
    {0, 17}, {17, 18}, {18, 19}, {19, 20},  -- Pinky
    {5, 9}, {9, 13}, {13, 17}  -- Webbing
}

-- Generate ASCII hand with line drawing
local function generateHandAscii(landmarks)
    local canvas = createCanvas()
    local mappedLandmarks = mapLandmarks(landmarks, width, height)

    -- Draw connections
    for _, conn in ipairs(connections) do
        local p1 = mappedLandmarks[conn[1] + 1]  -- Lua indices start at 1
        local p2 = mappedLandmarks[conn[2] + 1]
        drawLine(canvas, p1.x, p1.y, p2.x, p2.y)
    end

    renderCanvas(canvas)
end

-- MQTT Connection Handling
client:on {
    connect = function(connack)
        if connack.rc ~= 0 then
            print("Connection failed:", connack:reason_string(), connack)
            return
        end
        print("Connected to MQTT broker")

        -- Subscribe to the landmarks topic
        assert(client:subscribe { topic = "landmarks", qos = 1, callback = function(suback)
            print("Subscribed to landmarks topic")
        end })
    end,

    message = function(msg)
        assert(client:acknowledge(msg))  -- Acknowledge message

        -- Try to parse JSON
        local success, landmarks = pcall(json, msg.payload)

        if not success or type(landmarks) ~= "table" then
            print("Invalid or non-JSON message received:", msg.payload)
            return  -- Ignore non-JSON messages
        end

        -- Ensure landmarks contain valid ID, X, and Z
        local validLandmarks = {}
        for _, landmarkSet in ipairs(landmarks) do
            for _, landmark in ipairs(landmarkSet) do
                if type(landmark) == "table" and landmark.id and landmark.x then
                    table.insert(validLandmarks, landmark)
                end
            end
        end

        -- Render the hand on the monitor
        generateHandAscii(validLandmarks)
    end,

    error = function(err)
        print("MQTT client error:", err)
    end,

    close = function()
        print("MQTT connection closed")
    end
}

-- Run MQTT client loop
parallel.waitForAny(
    function()
        print("Running MQTT client")
        mqtt.run_sync(client)
        print("Client stopped")
    end,
    function()
        while true do
            os.sleep(keep_alive)
            client:send_pingreq()
        end
    end
)
