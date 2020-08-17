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
    ["torch_iteration"] = 4,
    ["current_torch_count"] = 0,
    ["current_fuel_count"] = 0,
    ["current_utility_block_count"] = 0,
    ["current_face"] = 0,   -- 0 = forward, 1 = right, 2 = backward, 3 = left
    ["dig_count"] = 0,
    ["debug_mode"] = true,
    ["sim_mode"] = turtle == nil
}
local item = {
    ["torch"] = {["id"] = "minecraft:torch", ["name"] = "torch", ["setting"] = "current_torch_count"},
    ["fuel"] = {["id"] = "minecraft:coal", ["name"] = "coal", ["setting"] = "current_fuel_count"},
    ["utility_block"] = {["id"] = "minecraft:cobblestone", ["name"] = "cobble", ["setting"] = "current_utility_block_count"},
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

local function selectItem(item_to_select)
    for i = 1, 16, 1 do
        turtle.select(i)
        if not(turtle.getItemDetail() == nil) then
            local item_to_check = turtle.getItemDetail()

            if item_to_check.name == item_to_select.id then
                break
            end
        end
    end
end

local function countItem(item_to_count)
    if not(settings.sim_mode) then
        settings[item_to_count.setting] = 0
        for i = 1, 16, 1 do
            turtle.select(i)
            
            if not(turtle.getItemDetail() == nil) then
                local item_to_check = turtle.getItemDetail()

                if item_to_check.name == item_to_count.id then
                    local item_count = turtle.getItemCount(i)
                    settings[item_to_count.setting] = settings[item_to_count.setting] + item_count
                end
            end
        end
    end
end

local function hasEnoughFuel(length, torch_iteration)
    if not(settings.sim_mode) then
        settings.current_fuel_count = turtle.getFuelLevel()
        if (length + ((length / torch_iteration) * 4) > settings.current_fuel_count) then
            return false
        else
            return true
        end
    end
end

local function hasEnoughTorches(iteration)
    print(settings.length / iteration)
    if (settings.length / iteration > settings.current_torch_count) then
        return false
    else
        return true
    end
end

local function promptForItem(item_to_prompt, amount)
    print("Feed the turtle " .. amount .. " " .. item_to_prompt.name .. "(s) and press enter.")
    local prompt = io.read()
end

local function initialCheck()
    countItem(item.torch)
    countItem(item.fuel)
    if (hasEnoughFuel(settings.length, 3)) then
        if (hasEnoughTorches(3)) then
            promptForItem(item.torch, settings.length / 3 - settings.current_torch_count)
            initialCheck()
        end
    else
        promptForItem(item.coal)
        initialCheck()
    end
end

local function placeTorch()
    if (settings.debug_mode == true) then
        print(formatted_24_hour_time .. "Placing torch at y_position " .. y_position .. ".")
    end
    if not(settings.sim_mode) then
        selectItem(item.torch)
        turtle.move("r")
        turtle.move("r")
        turtle.place()
        turtle.move("r")
        turtle.move("r")
        settings.current_torch_count = settings.current_torch_count - 1
    end
end

local function detectLiquid()
    if (turtle.detect() or turtle.detectDown() or turtle.detectUp()) then
        local success, data = turtle.inspect()
        if (data.name == "minecraft:lava" or data.name == "minecraft:water") then
            return true
        else
            return false
        end
    end
end

local function detectAir()
    if not(turtle.detectDown()) then
        return true
    else
        return false
    end
end

local function returnSequence(amount_to_return)
    if settings.current_pos.z == 0 then
        dig("u") -- just incase
        move("u")
    end
    for i = 1, amount_to_return, 1 do
        move("b")
    end
end

local function mineSequence(length)
    if (length > 0) then
        for i = 1, settings.length, 1 do
            if (settings.current_pos.y + 1 % 4 == 0) then
                placeTorch(settings.current_pos.y, 4)
            end
            dig("f")
            move("f")
            if detectLiquid() then
                selectItem(item.utility_block)
                turtle.place()
                returnSequence(length)
            end
            if (detectAir()) then
                selectItem(item.utility_block)
                turtle.placeDown()
            end
            dig("u")
        end
    end
    returnSequence(length)
end

handleArguments()
initialCheck()
mineSequence(settings.length)