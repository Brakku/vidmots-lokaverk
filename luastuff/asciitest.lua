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

-- Example hand landmarks (normalized coordinates) see link for detales: https://camo.githubusercontent.com/cc87e384b553a0f19dcf8a36341b37a7081edc0b21b0d0ac364200b9e3bb98a1/68747470733a2f2f6d65646961706970652e6465762f696d616765732f6d6f62696c652f68616e645f6c616e646d61726b732e706e67
local exampleLandmarks = {
    {id = 0, x = 0.2814, y = 0.8310}, 
    {id = 1, x = 0.4163, y = 0.7920}, 
    {id = 2, x = 0.5201, y = 0.6941}, 
    {id = 3, x = 0.5887, y = 0.5887}, 
    {id = 4, x = 0.6433, y = 0.5138}, 
    {id = 5, x = 0.4399, y = 0.4354}, 
    {id = 6, x = 0.4881, y = 0.2941}, 
    {id = 7, x = 0.5126, y = 0.2062}, 
    {id = 8, x = 0.5291, y = 0.1280}, 
    {id = 9, x = 0.3573, y = 0.4025}, 
    {id = 10, x = 0.3703, y = 0.2425}, 
    {id = 11, x = 0.3767, y = 0.1468}, 
    {id = 12, x = 0.3801, y = 0.0732}, 
    {id = 13, x = 0.2780, y = 0.4082}, 
    {id = 14, x = 0.2795, y = 0.2564}, 
    {id = 15, x = 0.2818, y = 0.1634}, 
    {id = 16, x = 0.2842, y = 0.0866}, 
    {id = 17, x = 0.2012, y = 0.4456}, 
    {id = 18, x = 0.1937, y = 0.3305}, 
    {id = 19, x = 0.1891, y = 0.2552}, 
    {id = 20, x = 0.1888, y = 0.1878} 
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
