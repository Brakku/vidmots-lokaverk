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
            canvas[y][x] = "."
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

-- Generate ASCII image
local function generateHandAscii(landmarks)
    local canvas = createCanvas()
    local mappedLandmarks = mapLandmarks(landmarks, width, height)

    for _, point in ipairs(mappedLandmarks) do
        canvas[point.y][point.x] = "#"
    end

    renderCanvas(canvas)
end

-- Call function with fixed data
generateHandAscii(exampleLandmarks)
