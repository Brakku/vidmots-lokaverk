-- Get the monitor peripheral
local mon = peripheral.find("monitor")
if not mon then
    print("No monitor found!")
    return
end

mon.setTextScale(0.5)  -- Adjust scale for better resolution
local width, height = mon.getSize()

-- Function to initialize canvas
local function createCanvas()
    local canvas = {}
    for y = 1, height do
        canvas[y] = {}
        for x = 1, width do
            canvas[y][x] = string.char(0x07) -- was . for the character
        end
    end
    return canvas
end

-- Function to map hand landmarks to monitor size
local function mapLandmarks(landmarks, w, h)
    local mapped = {}
    for _, point in ipairs(landmarks) do
        -- Clamp X between 0 and 1
        local x = math.max(0, math.min(1, point.x))
        -- Clamp Y between 0 and 1, and invert the Y-axis
        local y = 1 - math.max(0, math.min(1, point.y))

        -- Scale to screen size
        local screenX = math.floor(x * w)
        local screenY = math.floor(y * h)

        -- Ensure the points stay within bounds
        table.insert(mapped, {x = math.max(1, math.min(w, screenX)), y = math.max(1, math.min(h, screenY))})
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

-- Your hand landmark data
local exampleLandmarks = {
    {id = 0, x = 2.8138, y = 8.3100}, 
    {id = 1, x = 4.1628, y = 7.9197}, 
    {id = 2, x = 5.2013, y = 6.9411}, 
    {id = 3, x = 5.8873, y = 5.8867}, 
    {id = 4, x = 6.4333, y = 5.1381}, 
    {id = 5, x = 4.3994, y = 4.3541}, 
    {id = 6, x = 4.8813, y = 2.9415}, 
    {id = 7, x = 5.1262, y = 2.0615}, 
    {id = 8, x = 5.2911, y = 1.2800}, 
    {id = 9, x = 3.5729, y = 4.0253}, 
    {id = 10, x = 3.7034, y = 2.4251}, 
    {id = 11, x = 3.7668, y = 1.4680}, 
    {id = 12, x = 3.8007, y = 0.7320}, 
    {id = 13, x = 2.7797, y = 4.0815}, 
    {id = 14, x = 2.7949, y = 2.5644}, 
    {id = 15, x = 2.8175, y = 1.6343}, 
    {id = 16, x = 2.8422, y = 0.8662}, 
    {id = 17, x = 2.0123, y = 4.4558}, 
    {id = 18, x = 1.9369, y = 3.3054}, 
    {id = 19, x = 1.8912, y = 2.5525}, 
    {id = 20, x = 1.8877, y = 1.8785} 
}

-- Generate ASCII image
local function generateHandAscii(landmarks)
    local canvas = createCanvas()
    local mappedLandmarks = mapLandmarks(landmarks, width, height)

    for _, point in ipairs(mappedLandmarks) do
        canvas[point.y][point.x] = string.char(0x7F) -- was # for the character
    end

    renderCanvas(canvas)
end

-- Call function with fixed data
generateHandAscii(exampleLandmarks)