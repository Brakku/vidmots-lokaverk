-- Get the monitor peripheral
local mon = peripheral.find("monitor")
if not mon then
    print("No monitor found!")
    return
end

mon.setTextScale(0.5)  -- Adjust for higher resolution
local width, height = mon.getSize()

-- Define characters
local dotChar = string.char(0x07)   -- Background
local fillChar = string.char(0x7F)  -- Hand area

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

        table.insert(mapped, {x = screenX, y = screenY})
    end
    return mapped
end

-- Compute the convex hull using Graham scan algorithm
local function convexHull(points)
    table.sort(points, function(a, b)
        return a.x < b.x or (a.x == b.x and a.y < b.y)
    end)

    local function cross(o, a, b)
        return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)
    end

    local hull = {}

    -- Build lower hull
    for _, p in ipairs(points) do
        while #hull >= 2 and cross(hull[#hull - 1], hull[#hull], p) <= 0 do
            table.remove(hull)
        end
        table.insert(hull, p)
    end

    -- Build upper hull
    local lowerSize = #hull
    for i = #points - 1, 1, -1 do
        local p = points[i]
        while #hull > lowerSize and cross(hull[#hull - 1], hull[#hull], p) <= 0 do
            table.remove(hull)
        end
        table.insert(hull, p)
    end

    table.remove(hull)  -- Last point is duplicate
    return hull
end

-- Scanline fill for convex polygon
local function fillPolygon(canvas, hull)
    local minY, maxY = height, 1
    local edges = {}

    for i = 1, #hull do
        local p1 = hull[i]
        local p2 = hull[(i % #hull) + 1]

        if p1.y ~= p2.y then
            table.insert(edges, {x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y})
            minY = math.min(minY, p1.y, p2.y)
            maxY = math.max(maxY, p1.y, p2.y)
        end
    end

    for y = minY, maxY do
        local intersections = {}

        for _, edge in ipairs(edges) do
            if (edge.y1 <= y and edge.y2 > y) or (edge.y2 <= y and edge.y1 > y) then
                local x = edge.x1 + (y - edge.y1) * (edge.x2 - edge.x1) / (edge.y2 - edge.y1)
                table.insert(intersections, math.floor(x))
            end
        end

        table.sort(intersections)

        for i = 1, #intersections, 2 do
            local xStart, xEnd = intersections[i], intersections[i + 1]
            if xStart and xEnd then
                for x = xStart, xEnd do
                    canvas[y][x] = fillChar
                end
            end
        end
    end
end

-- Function to render ASCII art to the monitor
local function renderCanvas(canvas)
    mon.clear()
    for y, row in ipairs(canvas) do
        mon.setCursorPos(1, y)
        mon.write(table.concat(row, ""))
    end
end

-- Example hand landmarks
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
    {id = 17, x = 0.0, y = 0.7783},  
    {id = 18, x = 0.0, y = 0.8810},  
    {id = 19, x = 0.0, y = 0.9438},  
    {id = 20, x = 0.0, y = 0.9488}   
}

-- Generate ASCII hand with convex hull fill
local function generateHandAscii(landmarks)
    local canvas = createCanvas()
    local mappedLandmarks = mapLandmarks(landmarks, width, height)
    local hull = convexHull(mappedLandmarks)
    fillPolygon(canvas, hull)
    renderCanvas(canvas)
end

generateHandAscii(exampleLandmarks)
