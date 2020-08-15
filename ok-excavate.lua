local args = {...}

local time = os.time()
local formatted_time = "[" .. textutils.formatTime(time, true) .. "] "
local debug = true

Settings = {
    --uses body relative directions
    ["arg_x"] = 1,      --right/left
    ["arg_y"] = 1,      --forward/backwards
    ["arg_z"] = 1,      --up/down
    ["cur_pos"] = {
        ["x"] = 0,
        ["y"] = 0,
        ["z"] = 0,
    },
    ["move_count"] = 0,
    ["cur_face"] = 0,   -- 0 = +y | 1 = +x | 2 = -y | 3 = -x
    ["dig_count"] = 0,
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
                Settings.arg_y = tonumber(args[i])
            elseif (i == 2) then
                Settings.arg_x = tonumber(args[i])
            elseif (i == 3) then
                Settings.arg_z = tonumber(args[i])
            else
                error("too many arguments")
            end
        else
            error("argument is not a number.")
        end
    end 
    else
        print("Usage: ok-excavate [y] [x] [z]\n[y] - fowards | [x] left | [z] down")
    end
end

local function moveDirection(direction)
    -- accepts forward / backward / up / down
    if (Settings.cur_face == 0) then
        Settings.cur_pos.y = Settings.cur_pos.y + 1
    elseif (Settings.cur_face == 1) then
        Settings.cur_pos.x = Settings.cur_pos.x + 1
    elseif Settings.cur_face == 2 then
        Settings.cur_pos.y = Settings.cur_pos.y - 1
    elseif (Settings.cur_face == 3) then
        Settings.cur_pos.x = Settings.cur_pos.x - 1
    end
    Settings["move_count"] = Settings["move_count"] + 1
    turtle[direction]()
    if debug then
        print(formatted_time .. "ok-excavate: Forward | Position: " .. "[" .. Settings.cur_pos.x .. "," .. Settings.cur_pos.y .. "," .. Settings.cur_pos.z .. "]")
    end
    if direction == "forward" then
        
    end
end

local function turnPlane(x_iteration)
    if not(x_iteration % 2 == 0) then
        if (Settings.cur_face == 3) then
            Settings.cur_face = 0
        else
            Settings.cur_face = Settings.cur_face + 1
        end
        turtle.turnRight()
        if (debug) then
            print(formatted_time .. "ok-e: turn right / face: " .. tostring(Settings.cur_face))
        end
    else
        if (Settings.cur_face == 0) then
            Settings.cur_face = 3
        else
            Settings.cur_face = Settings.cur_face - 1
        end
        turtle.turnLeft()
        if (debug) then
            print(formatted_time .. "ok-e: turn left / face: " .. tostring(Settings.cur_face))
        end
    end
end

local function dig()
    if (turtle.detect()) then
        turtle.dig()
        Settings.dig_count = Settings.dig_count + 1
        if debug then
            print(formatted_time .. "ok-e: Digging")
        end
    end
end


local function calculateRequiredFuel()
    -- local fuel_level = turtle.getFuelLevel()
    local required_fuel = 0
    if tableLength(args) == 1 then
        required_fuel = (Settings.arg_y * 4) - fuel_level
    elseif tableLength(args) == 2 then
        required_fuel = ((Settings.arg_y * Settings.arg_x) * 4) - fuel_level
    elseif tableLength(args) == 3 then
        required_fuel = ((Settings.arg_y * Settings.arg_x * Settings.arg_z) * 4) - fuel_level
    end
    print("calculateRequiredFuel(): ", required_fuel)
    if (required_fuel > 0) then
        return required_fuel
    else
        return 0
    end
end

local function returnToStart()
    
end

local function minePlane()
    for iX = 1, Settings.arg_x, 1 do
        for iY = 1, Settings.arg_y, 1 do
            dig()
            moveDirection("forward")
        end
        if (not(iX == Settings.arg_x)) then
            turnPlane(iX)
            dig()
            moveDirection("forward")
            turnPlane(iX)
        end
    end
    returnToStart()
end
handleArguments()
-- calculateRequiredFuel()
minePlane()