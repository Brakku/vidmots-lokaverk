---@diagnostic disable: undefined-field
local width, height = term.getSize()

local function update(text)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1, 9)
    term.clearLine()
    term.setCursorPos(math.floor(width / 2 - string.len(text) / 2), 9)
    write(text)
end

local function bar(ratio)
    term.setBackgroundColor(colors.gray)
    term.setTextColor(colors.lime)
    term.setCursorPos(1, 11)

    for i = 1, width do
        if (i / width < ratio) then
            write("]")
        else
            write(" ")
        end
    end
end

local function download(path, repo, destination)
    update("Downloading " .. path .. "...")
    
    local url = "https://raw.githubusercontent.com/" .. repo .. "/main/" .. path
    
    local rawData = http.get(url)
    if rawData then
        local data = rawData.readAll()
        rawData.close()
        
        local file = fs.open(destination .. path, "w")
        file.write(data)
        file.close()
    else
        print("Failed to download " .. path)
    end
end

function install()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.yellow)
    term.clear()

    local str = "LuaMQTT:ComputerCraft Installer"
    term.setCursorPos(math.floor(width / 2 - #str / 2), 2)
    write(str)

    local total = 14
    update("Installing...")
    bar(0)

    local mainRepo = "WhyKickAmooCow/luamqtt-computercraft"
    local additionalRepo = "Brakku/vidmots-lokaverk"
    
    download("LICENSE", mainRepo, "")
    bar(1 / total)
    download("README.md", mainRepo, "")
    bar(2 / total)

    update("Creating mqtt folder...")
    fs.makeDir("mqtt")
    
    local mqttFiles = {"bitwrap.lua", "cc_websocket.lua", "client.lua", "const.lua", "init.lua", "ioloop.lua", "luasocket.lua", "protocol.lua", "protocol4.lua", "protocol5.lua", "tools.lua"}
    for i, file in ipairs(mqttFiles) do
        download("mqtt/" .. file, mainRepo, "")
        bar((2 + i) / total)
    end

    update("Creating examples folder...")
    fs.makeDir("examples")
    download("examples/cc_websocket.lua", mainRepo, "")
    bar(13 / total)

    -- Additional repository downloads
    update("Downloading additional files...")
    download("luaclient.lua", additionalRepo, "")
    bar(14 / total)
    
    update("Installation finished!")
    sleep(1)
    
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()

    term.setCursorPos(1, 1)
    write("Finished installation!\nPress any key to close...")
    os.pullEventRaw()

    term.clear()
    term.setCursorPos(1, 1)
end

install()
