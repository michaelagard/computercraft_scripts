local args = {...}

local time = os.time()
local formatted_24_hour_time = "[" .. textutils.formatTime(time, true) .. "] "

local settings = {
    --uses body relative directions 0 = +y | 1 = +x | 2 = -y | 3 = -x
    ["current_face"] = 0,   -- 0 = forward, 1 = right, 2 = backward, 3 = left
    ["current_pos"] = {     -- pos updates handled through move function
        ["x"] = 0,          -- + right      | - left
        ["y"] = 0,          -- + forward    | - backward
        ["z"] = 0,          -- + up         | - down
    },
    ["length"] = 0,         -- distance turtle will tunnel
    ["item"] = {            -- inventory management reference
        ["torch"] = {
            ["id"] = "minecraft:torch",
            ["count"] = 0,
            ["index"] = 0},
        ["coal"] = {
            ["id"] = "minecraft:coal",
            ["count"] = 0,
            ["index"] = 0},
        ["utility_block"] = {
            ["id"] = "minecraft:cobblestone",
            ["count"] = 0,
            ["index"] = 0}},
    ["current_fuel_count"] = turtle.getFuelLevel(),
    ["torch_iteration"] = 4,
    ["dig_count"] = 0,
    ["debug_mode"] = true,
}
local item = {
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
        if (turtle.detect()) then
            settings.dig_count = settings.dig_count + 1
            turtle.dig()
        end
        settings.dig_count = settings.dig_count + 1
    end
    if (direction == "d") then
        if (turtle.detectDown()) then
            settings.dig_count = settings.dig_count + 1
            turtle.digDown()
        end
        settings.dig_count = settings.dig_count + 1
    end
    if (direction == "u") then
        if (turtle.detectUp()) then
            settings.dig_count = settings.dig_count + 1
            turtle.digUp()
        end
        settings.dig_count = settings.dig_count + 1
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
        turtle.forward()
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
        turtle.back()
    elseif (direction == "r") then
        if (settings.current_face == 3) then
            settings.current_face = 0
        else
            settings.current_face = settings.current_face + 1
        end
        turtle.turnRight()
    elseif (direction == "l") then
        if (settings.current_face == 0) then
            settings.current_face = 3
        else
            settings.current_face = settings.current_face - 1
        end
        turtle.turnLeft()
    elseif (direction == "u") then
        settings.current_pos.z = settings.current_pos.z + 1
        turtle.up()
    elseif (direction == "d") then
        settings.current_pos.z = settings.current_pos.z - 1
        turtle.down()
    else
        error("'" .. direction .. "' is not a valid direction.")
    end
end

local function selectItem(item_index)
    turtle.select(item_index)
end

local function countItem(item_to_count)
    settings.item[item_to_count].count = 0
    for i = 1, 16, 1 do
        turtle.select(i)
        if not(turtle.getItemDetail() == nil) then
            if (turtle.getItemDetail().name == item_to_count.id) then
                settings.item[item_to_count].count = settings.item[item_to_count].count + turtle.getItemCount(i)
                settings.item[item_to_count].index = i
            end
        end
    end
end

local function hasEnoughFuel(length, torch_iteration)
    if (length + ((length / torch_iteration) * 4) > settings.current_fuel_count) then
        return false
    else
        return true
    end
end

local function hasEnoughTorches(iteration)
    return (settings.length / iteration > settings.current_torch_count)
end

local function promptForItem(item_to_prompt, amount)
    print("Feed the turtle " .. amount .. " " .. item_to_prompt.name .. "(s) and press enter.")
    local prompt = io.read()
end

local function placeTorch()
    selectItem(settings.item.torch.index)
    move("r")
    move("r")
    turtle.place()
    move("r")
    move("r")
    settings.item.torch.count = settings.item.torch.count - 1
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

local function initialCheck()
    countItem("torch")
    countItem("coal")
    countItem("utility_block")
    if (hasEnoughFuel(settings.length, 3)) then
        if (hasEnoughTorches(3)) then
            promptForItem(settings.item.torch, settings.length / 3 - settings.current_torch_count)
            initialCheck()
        end
    else
        promptForItem(settings.item.coal)
        initialCheck()
    end
end

local function mineSequence(length)
    if (length > 0) then
        for i = 1, settings.length, 1 do
            if (settings.current_pos.y + 1 % 4 == 0) then
                placeTorch()
            end
            dig("f")
            move("f")
            if detectLiquid() then
                selectItem(settings.item.utility_block.index)
                turtle.place()
                returnSequence(length)
            end
            if (detectAir()) then
                selectItem(settings.item.utility_block.index)
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