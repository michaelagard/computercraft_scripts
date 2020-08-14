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

Move = {
    ["forward"] = {["command"] = function() turtle.forward(); Move.forward.count = Move.forward.count + 1; end, ["count"] = 0, ["reverse"] = "back"},
    ["back"] = {["command"] = function() turtle.back() end, ["count"] = 0, ["reverse"] = "forward"},
    ["turnLeft"] = {["command"] = function() turtle.turnLeft() end, ["count"] = 0, ["reverse"] = "turnRight"},
    ["turnRight"] = {["command"] = function() turtle.turnRight() end, ["count"] = 0, ["reverse"] = "turnLeft"},
    ["up"] = {["command"] = function() turtle.up() end, ["count"] = 0, ["reverse"] = "down"},
    ["down"] = {["command"] = function() turtle.down() end, ["count"] = 0, ["reverse"] = "up"},
    ["MoveSequence"] = {}
}

Settings = {
    --uses body relative directions
    ["arg_x"] = 0, --right/left
    ["arg_y"] = 0, --forward/backwards
    ["arg_z"] = 0, --up/down
    ["total_args"] = tableLength(args),
}

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

local function minePlane()

    for iX = 1, Settings.arg_x, 1 do

        for iY = 1, Settings.arg_y, 1 do

            if(turtle.detect()) then
                turtle.dig()
            end

            Move.forward.command()
        end
        if (not(iX == Settings.arg_x)) then
            Move.turnRight.command()
    
            if(turtle.detect()) then
                turtle.dig()
            end
    
            Move.forward.command()
            Move.turnRight.command()
        end
    end
end
handleArguments()
calculateRequiredFuel()
minePlane()