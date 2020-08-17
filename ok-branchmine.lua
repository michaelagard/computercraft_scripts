local args = {...}

local time = os.time()
local formatted_24_hour_time = "[" .. textutils.formatTime(time, true) .. "] "

local settings = {
    --uses body relative directions 0 = +y | 1 = +x | 2 = -y | 3 = -x
    ["length"] = 0,
    ["current_pos"] = {
        ["x"] = 0,
        ["y"] = 0,
        ["z"] = 0,
    },
    ["minecraft:torch"] = 0,
    ["torch_iteration"] = 4,
    ["current_face"] = 0,   -- 0 = forward, 1 = right, 2 = backward, 3 = left
    ["dig_count"] = 0,
    ["debug_mode"] = true,
    ["sim_mode"] = turtle == nil
}

local function tableLength(table)
    local table_count = 0
    if (type(table) == "table") then
        for key, value in pairs(table) do
            table_count = table_count + 1
        end
        return table_count
    end
    return 0
end

local function handleArguments()
    if tableLength(args) > 0 then
    for i = 1, tableLength(args), 1 do
        if (type(tonumber(args[i])) == "number") then
            if (i == 1) then
                settings.length = tonumber(args[i])
            else
                error("too many arguments")
            end
        else
            error("argument is not a number.")
        end
    end 
    else
        print("Usage: ok-branchmine [length]")
    end
end

local function dig(direction)
    if (direction == "f") then
        if (settings.sim_mode == false) then
            if (turtle.detect()) then
                settings.dig_count = settings.dig_count + 1
                turtle.dig()
            end
        else
            settings.dig_count = settings.dig_count + 1
        end
        if settings.debug_mode == true then
            -- print(formatted_24_hour_time .. "Digging " .. direction .. ".")
        end
    end
    if (direction == "d") then
        if (settings.sim_mode == false) then
            if (turtle.detectDown()) then
                settings.dig_count = settings.dig_count + 1
                turtle.digDown()
            end
        else
            settings.dig_count = settings.dig_count + 1
        end
        if settings.debug_mode == true then
            -- print(formatted_24_hour_time .. "Digging " .. direction .. ".")
        end
    end
    if (direction == "u") then
        if (settings.sim_mode == false) then
            if (turtle.detectUp()) then
                settings.dig_count = settings.dig_count + 1
                turtle.digUp()
            end
        else
            settings.dig_count = settings.dig_count + 1
        end
        if settings.debug_mode == true then
            -- print(formatted_24_hour_time .. "Digging " .. direction .. ".")
        end
    end
end

local function move(direction)
    if (direction == "f") then
        if (settings.current_face == 0) then
            settings.current_pos.y = settings.current_pos.y + 1
        elseif (settings.current_face == 1) then
            settings.current_pos.x = settings.current_pos.x + 1
        elseif (settings.current_face == 2) then
            settings.current_pos.y = settings.current_pos.y - 1
        elseif (settings.current_face == 3) then
            settings.current_pos.x = settings.current_pos.x - 1
        end
        if (settings.sim_mode == false) then
            turtle.forward()
        end
    elseif (direction == "b") then
        if (settings.current_face == 0) then
            settings.current_pos.y = settings.current_pos.y - 1
        elseif (settings.current_face == 1) then
            settings.current_pos.x = settings.current_pos.x - 1
        elseif (settings.current_face == 2) then
            settings.current_pos.y = settings.current_pos.y + 1
        elseif (settings.current_face == 3) then
            settings.current_pos.x = settings.current_pos.x + 1
        end

        if (settings.sim_mode == false) then
            turtle.back()
        end
    elseif (direction == "r") then
        if (settings.current_face == 3) then
            settings.current_face = 0
        else
            settings.current_face = settings.current_face + 1
        end
        if (settings.sim_mode == false) then
            turtle.turnRight()
        end
    elseif (direction == "l") then
        if (settings.current_face == 0) then
            settings.current_face = 3
        else
            settings.current_face = settings.current_face - 1
        end
        if (settings.sim_mode == false) then
            turtle.turnLeft()
        end
    elseif (direction == "u") then
        settings.current_pos.z = settings.current_pos.z + 1
        if (settings.sim_mode == false) then
            turtle.up()
        end
    elseif (direction == "d") then
        settings.current_pos.z = settings.current_pos.z - 1
        if (settings.sim_mode == false) then
            turtle.down()
        end
    else
        error("'" .. direction .. "' is not a valid direction.")
    end

    local formatted_current_pos = "[" .. settings.current_pos.x .. "," .. settings.current_pos.y .. "," .. settings.current_pos.z .. "] "
    local formatted_current_face = "F" .. settings.current_face .. " "
    
    if (settings.debug_mode == true) then
        print(formatted_24_hour_time .. formatted_current_pos .. formatted_current_face .. direction)
    end
end

local function checkForItem(item_to_check)
    if not(settings.sim_mode) then
        for i = 1, 16, 1 do
            turtle.select(i)
            
            if not(turtle.getItemDetail() == nil) then

                local item = turtle.getItemDetail()

                if item.name == item_to_check then
                    local item_count = turtle.getItemCount(i)
                    print("Found " .. item_count .. " " .. item.name .. ".")
                    settings["minecraft:torch"] = item_count
                    return true
                end
            end
        end
        io.write("Feed the turtle " .. item .. " and press enter.")
        local wait_for_enter = io.read()
        checkForItem(item_to_check)
    end
end

local function hasEnoughFuel(move_count)
    local fuel_count = turtle.getFuelLevel()
    if (move_count > fuel_count) then
        return false
    else
        return true
    end
end

local function hasEnoughTorches(move_count, iteration)
    if (move_count / iteration  > settings["minecraft:torch"]) then
        return false
    else
        return true
    end
end

local function initialCheck()
    if (hasEnoughFuel(settings.length) and hasEnoughTorches(settings.length, 4)) then
        if (checkForItem("minecraft:torch")) then
            if turtle.detectDown() then -- align turtle with top of tunnel
                turtle.up()
            end
        else
            error("No torches found.")
        end
    else
        checkForItem("minecraft:coal")
    end
end

local function placeTorch(y_position, iteration)
    if (y_position % iteration == 0) then -- place torch every x blocks
        if (settings.debug_mode == true) then
            print(formatted_24_hour_time .. "Placing torch at y_position " .. y_position .. ".")
        end
        if not(settings.sim_mode) then
            turtle.placeDown()
            settings["minecraft:torch"] = settings["minecraft:torch"] - 1
        end
    end
end

local function mineSequence(length)
    if (length > 0) then
        for i = 1, settings.length, 1 do
            placeTorch(settings.current_pos.y, 4)
            dig("f")
            move("f")
            dig("d")
        end
    end
end

handleArguments()
initialCheck()
mineSequence(settings.length)