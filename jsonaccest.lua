local mqtt = require("mqtt")
local json = textutils.unserializeJSON  -- Use CC:Tweaked's built-in JSON parser

local keep_alive = 60
local monitor = peripheral.find("monitor")

if monitor then
    monitor.setTextScale(0.5)
    monitor.clear()
end

-- Create MQTT client
local client = mqtt.client {
    uri = "192.168.68.179:9001",
    clean = true,
    keep_alive = keep_alive
}

print("Created MQTT client", client)

client:on {
    connect = function(connack)
        if connack.rc ~= 0 then
            print("Connection to broker failed:", connack:reason_string(), connack)
            return
        end
        print("Connected:", connack)

        -- Subscribe to the landmarks topic
        assert(client:subscribe { topic = "landmarks", qos = 1, callback = function(suback)
            print("Subscribed:", suback)
        end })
    end,

    message = function(msg)
        assert(client:acknowledge(msg))  -- Acknowledge message

        -- Try to parse the incoming JSON payload
        local landmarks = json(msg.payload)
        
        if not landmarks then
            print("Failed to parse JSON:", msg.payload)
            return
        end
        
        -- Clear the monitor and display the new data
        if monitor then
            monitor.clear()
            monitor.setCursorPos(1, 1)
            monitor.write("Live Landmarks Data:")
            
            local line = 2
            for _, landmarkSet in ipairs(landmarks) do
                for _, landmark in ipairs(landmarkSet) do
                    monitor.setCursorPos(1, line)
                    monitor.write(string.format("ID: %d X: %.3f Z: %.3f", landmark.id, landmark.x, landmark.z))
                    line = line + 1
                    if line > 18 then break end  -- Prevents overflowing the screen
                end
            end
        end
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
        print("Running client in synchronous mode")
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
