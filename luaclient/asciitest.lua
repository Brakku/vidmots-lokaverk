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
        local x = math.floor(point.x * w)
        local y = math.floor(point.y * h)
        table.insert(mapped, {x = math.max(1, math.min(w, x)), y = math.max(1, math.min(h, y))})
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

-- Example: Replace this with your MediaPipe hand landmark data (normalized 0-1)
local exampleLandmarks = {
    {x = 0.3, y = 0.3}, {x = 0.4, y = 0.25}, {x = 0.5, y = 0.2}, -- Example points
    {x = 0.6, y = 0.3}, {x = 0.7, y = 0.4}, {x = 0.5, y = 0.5}, -- More example points
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

-- Call function with example data
generateHandAscii(exampleLandmarks)