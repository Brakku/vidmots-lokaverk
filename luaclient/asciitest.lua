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
    {id = 0, x = 0.1134, y = 0.9589}, 
    {id = 1, x = 0.1800, y = 0.9711}, 
    {id = 2, x = 0.2412, y = 0.9552}, 
    {id = 3, x = 0.2611, y = 0.9283}, 
    {id = 4, x = 0.2501, y = 0.8823}, 
    {id = 5, x = 0.2072, y = 0.7356}, 
    {id = 6, x = 0.1742, y = 0.8186}, 
    {id = 7, x = 0.1732, y = 0.8983}, 
    {id = 8, x = 0.1838, y = 0.9208}, 
    {id = 9, x = 0.1227, y = 0.7204}, 
    {id = 10, x = 0.0942, y = 0.8526}, 
    {id = 11, x = 0.0993, y = 0.9416}, 
    {id = 12, x = 0.1067, y = 0.9524}, 
    {id = 13, x = 0.0492, y = 0.7408}, 
    {id = 14, x = 0.0279, y = 0.8752}, 
    {id = 15, x = 0.0395, y = 0.9493}, 
    {id = 16, x = 0.0490, y = 0.9505}, 
    {id = 17, x = 0.0, y = 0.7783},  -- Fixed negative value
    {id = 18, x = 0.0, y = 0.8810},  -- Fixed negative value
    {id = 19, x = 0.0, y = 0.9438},  -- Fixed negative value
    {id = 20, x = 0.0, y = 0.9488}   -- Fixed negative value
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