local args = {...}

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
local debug = true
Move = {
    ["forward"] = {["command"] = 
        function()
            turtle.forward()
            Move.forward.count = Move.forward.count + 1
            if debug then
                print("ok-excavate: Moving Forward")
            end
        end,
        ["count"] = 0, ["reverse"] = "back"},
    ["back"] = {["command"] =
        function()
            turtle.back()
            Move.back.count = Move.back.count + 1
            if debug then
                print("ok-excavate: Moving Back")
            end
        end,
        ["count"] = 0, ["reverse"] = "forward"},
    ["turnLeft"] = {["command"] =
        function()
            turtle.turnLeft()
            Move.turnLeft.count = Move.turnLeft.count + 1
            if (Move.facing == 0) then
                Move.facing = 4
            end
            if debug then
                print("ok-excavate: Turning Left")
                print("ok-excavate: Facing:", Move.facing)
            end
        end,
        ["count"] = 0, ["reverse"] = "turnRight"},
    ["turnRight"] = {["command"] =
        function()
            turtle.turnRight()
            Move.turnRight.count = Move.turnRight.count + 1
            if (Move.facing == 4) then
                Move.facing = 0
            end
            Move.facing = Move.facing + 1
            if debug then
                print("ok-excavate: Turning Right")
                print("ok-excavate: Facing:", Move.facing)
            end
        end,
        ["count"] = 0, ["reverse"] = "turnLeft"},
    ["up"] = {["command"] =
        function()
            turtle.up()
            Move.up.count = Move.up.count + 1
            if debug then
                print("ok-excavate: Moving Up")
            end
        end,
        ["count"] = 0, ["reverse"] = "down"},
    ["down"] = {["command"] =
        function()
            turtle.down()
            Move.down.count = Move.down.count + 1
            if debug then
                print("ok-excavate: Moving Down")
            end
        end,
        ["count"] = 0, ["reverse"] = "up"},
    ["dig"] = {["command"] =
        function ()
            if (turtle.detect()) then
                turtle.dig()
                Move.dig.count = Move.dig.count + 1
                if debug then
                    print("ok-excavate: Digging")
                end
            end
        end, ["count"] = 0},
    ["move_sequence"] = {},
    ["facing"] = 0
}

Settings = {
    --uses body relative directions
    ["arg_x"] = 1, --right/left
    ["arg_y"] = 1, --forward/backwards
    ["arg_z"] = 1, --up/down
    ["total_args"] = tableLength(args),
}

local function turn(x_iteration)
    if (x_iteration % 2 == 0 or x_iteration == 0) then
        Move.turnRight.command()
    else
        Move.turnLeft.command()
    end
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
        print("Help line.")
    end
end



local function calculateRequiredFuel()
    local fuel_level = turtle.getFuelLevel()
    local required_fuel = 0
    if tableLength(args) == 1 then
        required_fuel = (Settings.arg_y * 4) - fuel_level
    elseif tableLength(args) == 2 then
        required_fuel = ((Settings.arg_y * Settings.arg_x) * 4) - fuel_level
    elseif tableLength(args) == 3 then
        required_fuel = ((Settings.arg_y * Settings.arg_x * Settings.arg_z) * 4) - fuel_level
    else
        error("No args detected.")
    end
    print("calculateRequiredFuel(): ", required_fuel)
    if (required_fuel > 0) then
        return required_fuel
    else
        return 0
    end
end

local function returnToStart(x, y, z)
    for i = 1, x, 1 do
        Move.
    end
    for i = 1, y, 1 do
        
    end
    for i = 1, z, 1 do
        
    end
end

local function minePlane()

    for iX = 1, Settings.arg_x, 1 do

        for iY = 1, Settings.arg_y, 1 do
            Move.dig.command()
            Move.forward.command()
        end
        if (not(iX == Settings.arg_x)) then
            turn(iX)
            Move.dig.command()
            Move.forward.command()
            turn(iX)
        end
    end
end
handleArguments()
calculateRequiredFuel()
minePlane()