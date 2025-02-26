-- Get the monitor peripheral
local mon = peripheral.find("monitor")
if not mon then
    print("No monitor found!")
    return
end

mon.setTextScale(0.5)  -- Adjust for higher resolution
local width, height = mon.getSize()

-- Define characters
local dotChar = string.char(0x07)   -- Background (.)
local lineChar = string.char(0x7F)  -- Line (#)

-- Function to initialize a blank canvas
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

-- Bresenham's line algorithm for drawing lines
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

-- Function to map hand landmarks to monitor size
local function mapLandmarks(landmarks, w, h)
    local mapped = {}
    for _, point in ipairs(landmarks) do
        local x = math.max(0, math.min(1, point.x))
        local y = 1 - math.max(0, math.min(1, point.y))  -- Invert Y-axis

        local screenX = math.floor(x * w)
        local screenY = math.floor(y * h)

        screenX = math.max(1, math.min(w, screenX))
        screenY = math.max(1, math.min(h, screenY))

        mapped[#mapped + 1] = {x = screenX, y = screenY}
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

-- Example hand landmarks (normalized coordinates)
local exampleLandmarks = {
    {id = 0, x = 0.5, y = 0.9},   -- WRIST
    {id = 1, x = 0.4, y = 0.7},   -- THUMB_CMC
    {id = 2, x = 0.35, y = 0.6},  -- THUMB_MCP
    {id = 3, x = 0.3, y = 0.5},   -- THUMB_IP
    {id = 4, x = 0.25, y = 0.4},  -- THUMB_TIP
    {id = 5, x = 0.55, y = 0.7},  -- INDEX_FINGER_MCP
    {id = 6, x = 0.57, y = 0.6},  -- INDEX_FINGER_PIP
    {id = 7, x = 0.58, y = 0.5},  -- INDEX_FINGER_DIP
    {id = 8, x = 0.59, y = 0.4},  -- INDEX_FINGER_TIP
    {id = 9, x = 0.65, y = 0.7},  -- MIDDLE_FINGER_MCP
    {id = 10, x = 0.67, y = 0.6}, -- MIDDLE_FINGER_PIP
    {id = 11, x = 0.68, y = 0.5}, -- MIDDLE_FINGER_DIP
    {id = 12, x = 0.69, y = 0.4}, -- MIDDLE_FINGER_TIP
    {id = 13, x = 0.75, y = 0.7}, -- RING_FINGER_MCP
    {id = 14, x = 0.77, y = 0.6}, -- RING_FINGER_PIP
    {id = 15, x = 0.78, y = 0.5}, -- RING_FINGER_DIP
    {id = 16, x = 0.79, y = 0.4}, -- RING_FINGER_TIP
    {id = 17, x = 0.85, y = 0.7}, -- PINKY_MCP
    {id = 18, x = 0.87, y = 0.6}, -- PINKY_PIP
    {id = 19, x = 0.88, y = 0.5}, -- PINKY_DIP
    {id = 20, x = 0.89, y = 0.4}  -- PINKY_TIP
}

-- Hand connection pairs (from Mediapipe hand landmarks)
local connections = {
    {0, 1}, {1, 2}, {2, 3}, {3, 4},  -- Thumb
    {0, 5}, {5, 6}, {6, 7}, {7, 8},  -- Index Finger
    {0, 9}, {9, 10}, {10, 11}, {11, 12},  -- Middle Finger
    {0, 13}, {13, 14}, {14, 15}, {15, 16},  -- Ring Finger
    {0, 17}, {17, 18}, {18, 19}, {19, 20}  -- Pinky
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

generateHandAscii(exampleLandmarks)
