-- Get the monitor peripheral
local mon = peripheral.find("monitor")
if not mon then
    print("No monitor found!")
    return
end

mon.setTextScale(0.5)  -- Adjust text size for higher resolution
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
        local y = math.max(0, math.min(1, point.y))  -- DO NOT invert Y yet

        -- Mirror X and Flip Y
        local screenX = math.floor((1 - x) * w)  -- Mirror X
        local screenY = math.floor(y * h)        -- Flip Y

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
    {id = 0, x = 0.2813771963119507, y = 0.831003725528717}, 
    {id = 1, x = 0.41627541184425354, y = 0.791965126991272}, 
    {id = 2, x = 0.520128607749939, y = 0.6941092610359192}, 
    {id = 3, x = 0.5887344479560852, y = 0.5886747241020203}, 
    {id = 4, x = 0.6433324813842773, y = 0.5138118863105774}, 
    {id = 5, x = 0.4399354159832001, y = 0.43541327118873596}, 
    {id = 6, x = 0.4881315231323242, y = 0.29414957761764526}, 
    {id = 7, x = 0.5126233100891113, y = 0.20615211129188538}, 
    {id = 8, x = 0.529113233089447, y = 0.12800383567810059}, 
    {id = 9, x = 0.35728856921195984, y = 0.4025281071662903}, 
    {id = 10, x = 0.3703385889530182, y = 0.24250686168670654}, 
    {id = 11, x = 0.3766821622848511, y = 0.14680373668670654}, 
    {id = 12, x = 0.38006913661956787, y = 0.07320061326026917}, 
    {id = 13, x = 0.2779727578163147, y = 0.4081544876098633}, 
    {id = 14, x = 0.2794930338859558, y = 0.25644195079803467}, 
    {id = 15, x = 0.2817540764808655, y = 0.16342702507972717}, 
    {id = 16, x = 0.28422459959983826, y = 0.08662369847297668}, 
    {id = 17, x = 0.20123419165611267, y = 0.44557973742485046}, 
    {id = 18, x = 0.19369491934776306, y = 0.33054035902023315}, 
    {id = 19, x = 0.18912269175052643, y = 0.25524789094924927}, 
    {id = 20, x = 0.1887734979391098, y = 0.18784886598587036} 
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
